# nginx-ensite --- Bash completion function for nginx_ensite/nginx_dissite.

# Copyright (C) 2010 António P. P. Almeida <appa@perusio.net>

# Author: António P. P. Almeida <appa@perusio.net>

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

#!/bin/bash:wq

# Except as contained in this notice, the name(s) of the above copyright
# holders shall not be used in advertising or otherwise to promote the sale,
# use or other dealings in this Software without prior written authorization.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.


## Handling of both enabled and available sites.
_nginx_sites() {
    # Get the available or enabled sites for nginx.
    COMPREPLY=( $( compgen -W '$( command find /etc/nginx/$1 \
      \( -type l -o -type f \) -printf "%P " 2>/dev/null \
      | sed 's/[.]conf$//' )' -- $cur  ) )
}

_nginx_ensite()
{
       local cur

       COMPREPLY=()
       cur=${COMP_WORDS[COMP_CWORD]}

       _nginx_sites sites-available
}

complete -F _nginx_ensite nginx_ensite

_nginx_dissite()
{
       local cur

       COMPREPLY=()
       cur=${COMP_WORDS[COMP_CWORD]}

       _nginx_sites sites-enabled
}

complete -F _nginx_dissite nginx_dissite
