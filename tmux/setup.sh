#!/bin/bash
set -e

tmux_installed=`which tmux`
if [[ -z $tmux_installed ]]; then
  echo "Install tmux first"
  exit 1
fi

echo "Copying tmux configuration..."
cp ./tmux.conf $HOME/.tmux.conf

tmux_dir=$HOME/.tmux
if [[ ! -d $tmux_dir ]]; then
  echo "Creating $tmux_dir..."
  mkdir $tmux_dir
fi

if [[ ! -d $tmux_dir/plugins/tpm ]]; then
  echo "Installing tpm..."
  git clone https://github.com/tmux-plugins/tpm $tmux_dir/plugins/tpm
else
  echo "Updating tpm..."
  (cd $tmux_dir/plugins/tpm && \
    git pull origin master)
fi

echo "Sourcing tmux config..."
tmux source $HOME/.tmux.conf

echo "Installing tpm plugins..."
bash $tmux_dir/plugins/tpm/bin/install_plugins
