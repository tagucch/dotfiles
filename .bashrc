# ターミナル起動時にtmuxを起動する
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}
tmux_automatically_attach_session

# コマンドエイリアス
alias ll='ls -la'
alias updatedb='sudo /usr/libexec/locate.updatedb'
alias tree='tree -afL 2'
alias be='bundle exec'
alias localdelete='git branch --merged master | grep -vE '^\*|master$|develop$' | xargs -I % git branch -d %'

# プロンプトにカレントディレクトリへの絶対パスと現在のブランチ名を表示する
source /usr/local/git/contrib/completion/git-prompt.sh
source /usr/local/git/contrib/completion/git-completion.bash

GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\e[0;33m\]\w\[\e[00m\]\n\[\e[0;36m\]$(__git_ps1 [%s])\[\e[00m\]:\$ '

# 以下、ブランチ名を右端に表示する場合のスクリプト
# function length()
# {
#   echo -n ${#1}
# }
#
# function init-prompt-git-branch()
# {
#   git symbolic-ref HEAD 2>/dev/null >/dev/null &&
#   echo "[$(git symbolic-ref HEAD 2>/dev/null | sed 's/^refs\/heads\///')]"
# }
#
# if which git 2>/dev/null >/dev/null
# then
#   export PS1_GIT_BRANCH='\[\e[$[COLUMNS]D\]\[\e[0;36m\]\[\e[$[COLUMNS-$(length $(init-prompt-git-branch))]C\]$(init-prompt-git-branch)\[\e[$[COLUMNS]D\]\[\e[0;36m\]'
# else
#   export PS1_GIT_BRANCH=
# fi
# export PS1="\[\e[32;1m\]\u@\H \[\e[33;1m\]\w $PS1_GIT_BRANCH\n\[\e[36;1m\]\t \[\e[0m\]\$ "
# export PS1="\[\e[0;33m\]\w $PS1_GIT_BRANCH\n\[\e[00m\]:\$ "

# startup docker-machine
DOCKER_MACHINE="default"
if docker-machine status $DOCKER_MACHINE | grep "Running" &> /dev/null
  then
    eval "$(docker-machine env $DOCKER_MACHINE)"
  else
    docker-machine start $DOCKER_MACHINE && eval "$(docker-machine env $DOCKER_MACHINE)"
fi
eval $(docker-machine env default)

function command_not_found_handle() {
 if [ -e /usr/local/bin/imgcat ];then
    if [ -e ~/pop1.jpg ];then
      imgcat ~/pop1.jpg
    fi
  fi
}
