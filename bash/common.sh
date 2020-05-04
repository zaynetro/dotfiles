# Common bash environment

# Go PATH
if [[ -d $HOME/go ]]; then
    export GOPATH="$HOME/go"
    export PATH=$PATH:$GOPATH/bin
fi

# Cargo
if [[ -d $HOME/.cargo ]]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

# Nix-env
if [ -e /home/zaynetro/.nix-profile/etc/profile.d/nix.sh ]; then
    . /home/zaynetro/.nix-profile/etc/profile.d/nix.sh;
fi # added by Nix installer

# Default editor
export EDITOR='nvim'

# Show colors in the terminal
force_color_prompt=yes
if [[ "$TERM" == "xterm" ]]; then
  export TERM=xterm-256color
fi

# Aliases
alias tmux='tmux -2'

# Case insensitive completion
bind "set completion-ignore-case on"

# Ignore dublicate commands in bash history
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
# append to history, don't overwrite it
shopt -s histappend
#Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
# Useful timestamp format
HISTTIMEFORMAT='%F %T '

# Git aware prompt
export GITAWAREPROMPT=$HOME/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"

# Custom bash prompt
export PS1="\n\u@\h:\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\n\$ "

# OS specific environment
case $OSTYPE in
  "darwin"*)
    source "$HOME/.bash/osx.sh"
    ;;
  "linux-gnu")
    source "$HOME/.bash/linux.sh"
    ;;
esac

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# Use VI editing mode
# http://www.catonmat.net/blog/bash-vi-editing-mode-cheat-sheet/
set -o vi

# User-friendly nix
alias nix-rz="bash $HOME/.bash/nix-rz.sh"
