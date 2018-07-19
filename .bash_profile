export PATH=/usr/local/bin:$PATH
export GOPATH=$HOME/dev/go
export SHELL=/usr/local/bin/bash
export PATH="${HOME}/.anyenv/bin:${PATH}"

if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

eval "$(anyenv init -)"
