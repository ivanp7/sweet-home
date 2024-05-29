#!/usr/bin/env python

import json
import os
import re
import sys

###############################################################################
### colors
###############################################################################

def color1(num: int=None, fg: bool=True) -> str:
    """Change foreground or background color of text.
    """
    assert num is None or (type(num) == int and num >= 0 and num < 256)

    s = chr(27) + "["
    if num is not None:
        s += f"{38 if fg else 48};5;{num}m"
    else:
        s += "0m"

    return s

def color2(fg: int=None, bg: int=None, transparent_bg: bool=False) -> str:
    """Change foreground and background color of text.
    """
    if bg is not None:
        s = color1(bg, False)
    else:
        s = color1(None) if transparent_bg else ''

    if fg is not None:
        s += color1(fg, True)

    return s

###############################################################################
### color transitions
###############################################################################

def p_fg(fg: int) -> str:
    """Set foreground color.
    """
    return color2(fg=fg)

def p_bg(bg: int, prev_bg: int=None, trans: str="", prev_bg_to_fg: bool=True) -> str:
    """Perform background color transition.
    """
    if not trans:
        return color2(bg=bg, transparent_bg=bg is None)
    elif prev_bg_to_fg:
        return color2(fg=prev_bg if prev_bg else 0, bg=bg, transparent_bg=bg is None) + trans
    else:
        return color2(fg=bg, bg=prev_bg, transparent_bg=prev_bg is None) + trans + \
                color2(bg=bg, transparent_bg=bg is None)

###############################################################################
### prompt widgets
###############################################################################

def widget_exit_code(style: dict, code: str) -> str:
    """Exit code widget.
    """
    if code is None:
        return "", 0

    if code == "0":
        text = style.get('success_text', code)
        return p_fg(style['success_fg']) + text, len(text)
    else:
        text = style.get('failure_text', {}).get(code, code)
        return p_fg(style['failure_fg']) + text, len(text)

def widget_exec_time(style: dict, seconds: int) -> str:
    """Execution time widget.
    """
    if seconds is None:
        return "", 0

    minutes = seconds // 60
    hours = minutes // 60
    days = hours // 24

    hours = hours % 24
    minutes = minutes % 60
    seconds = seconds % 60

    if days > 0:
        text = f"{days}d{hours}h"
    elif hours > 0:
        text = f"{hours}h{minutes}m"
    elif minutes > 0:
        text = f"{minutes}m{seconds}s"
    else:
        text = f"{seconds}s"

    return p_fg(style['fg']) + text, len(text)

def widget_directory(style: dict, path: str, depth_highlighted: int=0) -> str:
    """Directory path widget.
    """
    if not path:
        return "", 0

    components = [''.join([ch if ord(ch) >= 32 and ord(ch) != 127 else '/' for ch in component])
            for component in path.split('/') if component]

    is_absolute = (path[0] == '/')
    color = style['highlight_fg'] if depth_highlighted >= int(is_absolute) + len(components) \
            else style['normal_fg']

    s = p_fg(color) + "/" if is_absolute else ""
    slen = int(is_absolute)

    separator_color = style['separator_fg']
    nonprint_color = style['nonprint_fg']
    nonprint_char = style['nonprint_char']

    separators = [f"{i%10}" for i in range(len(components), 0, -1)]

    for i, component, sep in zip(range(len(components)), components, separators):
        s += p_fg(separator_color) + sep
        slen += len(sep)

        if len(components) - i == depth_highlighted:
            color = style['highlight_fg']

        for part in re.split('(/+)', component):
            if not part:
                continue
            elif part[0] == '/':
                s += p_fg(nonprint_color) + nonprint_char * len(part)
                slen += len(nonprint_char) * len(part)
            else:
                s += p_fg(color) + part
                slen += len(part)

    return s, slen

def widget_git(style: dict, head: str, head_detached: bool=False,
               commits_ahead: int=0, commits_behind: int=0, merging: bool=False,
               untracked: bool=False, modified: bool=False, staged: bool=False) -> str:
    """Git repository state widget.
    """
    if not head:
        return "", 0

    s = p_fg(style['head_branch_fg' if not head_detached else 'head_commit_fg']) + head
    slen = len(head)

    if commits_ahead or commits_behind:
        s += " "
        slen += 1

        if commits_ahead:
            num = str(commits_ahead)
            s += p_fg(style['ahead_fg']) + "↑" + num
            slen += 1 + len(num)
        if commits_behind:
            num = str(commits_behind)
            s += p_fg(style['behind_fg']) + "↓" + num
            slen += 1 + len(num)

    if merging or untracked or modified or staged:
        s += " "
        slen += 1

        if merging:
            s += p_fg(style['merging_fg']) + "↕"
            slen += 1
        if untracked:
            s += p_fg(style['untracked_fg']) + "•"
            slen += 1
        if modified:
            s += p_fg(style['modified_fg']) + "•"
            slen += 1
        if staged:
            s += p_fg(style['staged_fg']) + "•"
            slen += 1

    return s, slen

def widget_permissions(style: dict, readable: bool=True, writable: bool=True, executable: bool=True,
                       setuid: bool=False, setgid: bool=False, sticky: bool=False) -> str:
    """File permissions widget.
    """
    s = ""
    slen = 0

    if not readable or not writable or not executable:
        s += p_fg(style['unset_fg'])

        if not readable:
            s += "-r"
            slen += 2
        if not writable:
            s += "-w"
            slen += 2
        if not executable:
            s += "-x"
            slen += 2

    if setuid or setgid or sticky:
        s += p_fg(style['set_fg'])

        if setuid:
            s += "+s"
            slen += 2
        if setgid:
            s += "+S"
            slen += 2
        if sticky:
            s += "+t"
            slen += 2

    return s, slen

###############################################################################
### execution of built-in prompts
###############################################################################

if __name__ == '__main__':
    prompt_style = json.loads(os.environ['PROMPT_STYLE'])

    prompt_root = bool(os.environ.get('PROMPT_ROOT', ""))

    characters = os.environ.get('PROMPT_CHARS', "◀▶<>")
    chr_triangle_left = characters[0]
    chr_triangle_right = characters[1]
    chr_bracket_left = characters[2]
    chr_bracket_right = characters[3]

    arg_index = 1
    prompt_type = sys.argv[arg_index]

    prompt_string = ""
    prompt_length = 0

    if prompt_type == "cmd_result":
        arg_index += 1
        if len(sys.argv) > arg_index:
            exit_code = sys.argv[arg_index]
            if exit_code:
                style = prompt_style['exit_code']

                widget, widget_length = widget_exit_code(style, exit_code)

                bg = style['success_bg' if exit_code == "0" else 'failure_bg']
                prompt_string += p_fg(bg) + chr_bracket_left + p_bg(bg, None, chr_triangle_left, False) + \
                        widget + p_bg(None, bg, chr_triangle_right, True) + p_fg(bg) + chr_bracket_right
                prompt_length += len(chr_bracket_left) + len(chr_triangle_left) + widget_length + \
                        len(chr_triangle_right) + len(chr_bracket_right)

        arg_index += 1
        if len(sys.argv) > arg_index:
            exec_time = sys.argv[arg_index]
            if exec_time:
                style = prompt_style['exec_time']
                if exit_code:
                    style['fg'] = bg

                exec_time = int(exec_time)
                if exec_time > 0:
                    if exit_code:
                        prompt_string += " after "
                        prompt_length += 7

                    widget, widget_length = widget_exec_time(style, exec_time)

                    prompt_string += widget
                    prompt_length += widget_length
    elif prompt_type == "pwd":
        style = prompt_style['path']

        arg_index += 1
        directory = sys.argv[arg_index]

        arg_index += 1
        depth_highlighted = int(sys.argv[arg_index]) if len(sys.argv) > arg_index else 0

        widget, widget_length = widget_directory(style, directory, depth_highlighted)

        prompt_string += "→ " + widget
        prompt_length += 2 + widget_length

        arg_index += 1
        permissions = sys.argv[arg_index] if len(sys.argv) > arg_index else ""

        arg_index += 1
        git_head = sys.argv[arg_index] if len(sys.argv) > arg_index else ""
        if git_head:
            style = prompt_style['git']

            arg_index += 1
            git_head_detached = bool(sys.argv[arg_index]) if len(sys.argv) > arg_index else False

            arg_index += 1
            git_ahead = int(sys.argv[arg_index]) if len(sys.argv) > arg_index else 0

            arg_index += 1
            git_behind = int(sys.argv[arg_index]) if len(sys.argv) > arg_index else 0

            arg_index += 1
            git_merging = bool(sys.argv[arg_index]) if len(sys.argv) > arg_index else False

            arg_index += 1
            git_untracked = bool(sys.argv[arg_index]) if len(sys.argv) > arg_index else False

            arg_index += 1
            git_modified = bool(sys.argv[arg_index]) if len(sys.argv) > arg_index else False

            arg_index += 1
            git_staged = bool(sys.argv[arg_index]) if len(sys.argv) > arg_index else False

            widget, widget_length = widget_git(style, git_head, git_head_detached, git_ahead, git_behind,
                                               git_merging, git_untracked, git_modified, git_staged)

            bracket_fg = style['bracket_fg']
            prompt_string += " " + p_fg(bracket_fg) + chr_bracket_left + " " + \
                    widget + p_fg(bracket_fg) + " " + chr_bracket_right
            prompt_length += 1 + len(chr_bracket_left) + 1 + widget_length + 1 + len(chr_bracket_right)

        if permissions:
            style = prompt_style['perm']

            dir_not_readable = permissions.find('r') >= 0
            dir_not_writable = permissions.find('w') >= 0
            dir_not_executable = permissions.find('x') >= 0
            dir_setgid = permissions.find('S') >= 0
            dir_sticky = permissions.find('t') >= 0

            widget, widget_length = widget_permissions(style, not dir_not_readable, not dir_not_writable,
                                                       not dir_not_executable, False, dir_setgid, dir_sticky)

            prompt_string += " " + widget
            prompt_length += 1 + widget_length
    elif prompt_type == "left_prompt":
        style = prompt_style['lstatus']

        arg_index += 1
        status = sys.argv[arg_index] if len(sys.argv) > arg_index else ""

        fg = style['normal_fg' if not prompt_root else 'root_fg']
        bg = style['normal_bg' if not prompt_root else 'root_bg']
        bracket_fg = style['normal_bracket_fg' if not prompt_root else 'root_bracket_fg']
        prompt_string += p_bg(bg, None, chr_triangle_left, False) + \
                p_fg(fg) + status + p_bg(None, bg, chr_triangle_right, True) + p_fg(bracket_fg) + 2*chr_bracket_right + " "
        prompt_length += len(chr_triangle_left) + len(status) + len(chr_triangle_right) + 2*len(chr_bracket_right) + 1
    elif prompt_type == "right_prompt":
        style = prompt_style['rstatus']

        arg_index += 1
        status = sys.argv[arg_index] if len(sys.argv) > arg_index else ""

        fg = style['fg']
        bg = style['bg']
        prompt_string += p_fg(fg) + 2*chr_bracket_left + p_bg(bg, None, chr_triangle_left, False) + \
                p_fg(fg) + status + p_bg(None, bg, chr_triangle_right, True)
        prompt_length += 2*len(chr_bracket_left) + len(chr_triangle_left) + len(status) + len(chr_triangle_right)

    prompt_string += color1(None)

    prompt_esc = os.environ.get('PROMPT_ESC', '')
    if prompt_esc == 'zsh':
        prompt_string = "%" + str(prompt_length) + "{" + prompt_string + "%}"

    print(prompt_string, end="")
    # print(prompt_length, end="", file=sys.stderr)

