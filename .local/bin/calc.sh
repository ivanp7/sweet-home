#!/bin/sh

python - << _EOF_
from math import *
print($(echo "$@"))
_EOF_

