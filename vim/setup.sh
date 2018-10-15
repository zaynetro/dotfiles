#!/bin/bash

if [[ ! -a "$HOME/.vimrc" ]]; then
  touch "$HOME/.vimrc"
fi

vimrc_changed=`diff -q vimrc $HOME/.vimrc`

# Check if user has vim and git
check_requirements() {
  local vimloc=`which vim`
  if [[ ! -x $vimloc ]]; then
    echo "vim is required"
    exit 1
  fi

  local gitloc=`which git`
  if [[ ! -x $gitloc ]]; then
    echo "git is required"
    exit 1
  fi

  local curl_loc=`which pip3`
  if [[ ! -x $curl_loc ]]; then
    echo "curl is required"
    exit 1
  fi
}

# Copy .vimrc file to $HOME
copy_vimrc() {
  if [[ -z $vimrc_changed ]]; then
    return
  fi

  echo "Copying .vimrc..."
  cp vimrc $HOME/.vimrc
}

# Install Vim-plug only if needed
install_vim_plug() {
  local plugdir=$HOME/.vim/autoload/plug.vim

  if [[ ! -d $plugdir ]]; then
    echo "Saving vim-plug to $plugdir..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

# Install vim plug plugins
install_plugins() {
  echo "Installing vim plugins..."
  local nvimloc=`which nvim`
  if [[ ! -x $nvimloc ]]; then
    vim +PlugInstall! +qall
  else
    nvim +PlugInstall! +qall
  fi
}

neovim_specific() {
  local nvim_dir="$HOME/.config"

  local nvimloc=`which nvim`
  if [[ ! -x $nvimloc ]]; then
    echo "nvim is NOT installed, consider installing"
    echo "Skipping neovim specific installations.."
    return
  fi

  echo "Creating config dir $nvimdir.."
  mkdir -p $nvim_dir

  if [[ ! -d "$nvim_dir/nvim" ]]; then
    echo "Linking nvimdir $nvimdir/nvim.."
    ln -s $HOME/.vim $nvim_dir/nvim
  fi

  if [[ ! -f "$nvim_dir/nvim/init.vim" ]]; then
    echo "Linking to $nvim_dir/nvim/init.vim.."
    ln -s $HOME/.vimrc $nvim_dir/nvim/init.vim
  fi

  local pip3loc=`which pip3`
  if [[ ! -x $pip3loc ]]; then
    echo "pip3 is NOT installed"
    echo "Skipping deoplete installation..."
    return
  fi

  local python_neovim=`pip3 list --format=columns | grep neovim | wc -l`
  if [[ $python_neovim -eq 0 ]]; then
    echo "Installing neovim python3 support..."
    pip3 install neovim
  else
    echo "Updating neovim python3 support..."
    pip3 install --upgrade neovim
  fi

  echo "Updating remote plugins..."
  nvim +UpdateRemotePlugins +qall
}

# Install Tomorrow theme if needed
install_theme() {
  local colordir=$HOME/.vim/colors
  local tmpdir=/tmp

  if [[ -d $colordir ]]; then
    local themes=`ls -l $colordir | grep -e 'Tomorrow.*\.vim$' | wc -l`

    if [[ $themes -gt "0" ]]; then
      return
    fi
  fi

  echo "Installing Tomorrow-Night theme..."
  local themedir="$tmpdir/tomorrow"
  git clone https://github.com/chriskempson/tomorrow-theme.git $themedir

  # Copy vim theme colors
  cp -R $themedir/vim/* $HOME/.vim/

  echo "Tomorrow theme location:"
  echo "  $themedir"
}

check_requirements
copy_vimrc
install_vim_plug
install_theme
if [[ "$1" != "quick" ]]; then
  echo "Installing plugins: $1"
  install_plugins
fi
neovim_specific

echo "Vim was set up"
