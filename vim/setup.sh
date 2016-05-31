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
}

# Copy .vimrc file to $HOME
copy_vimrc() {
	if [[ -z $vimrc_changed ]]; then
		return
	fi

	echo "Copying .vimrc..."
	cp vimrc $HOME/.vimrc

  echo "Linking to $nvim_dir/nvim/init.vim"
  ln -s $HOME/.vimrc $nvim_dir/nvim/init.vim
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

# Install vim plug plugins
install_plugins() {
	if [[ -z $vimrc_changed ]]; then
    echo "Updating vim plugins..."
	  vim +PlugUpdate +qall
		return
	fi

	echo "Installing vim plugins..."
	vim +PlugInstall +qall
  echo "NOTE: install go binaries if needed"
  echo "  vim -c \":GoInstallBinaries\""
}

neovim_specific() {
  local nvim_dir="$HOME/.config"

  local nvimloc=`which nvim`
  if [[ ! -x $nvimloc ]]; then
    echo "nvim is NOT installed, consider installing"
    echo "Skipping neovim specific installations.."
    return
  fi

  if [[ ! -d $nvim_dir ]]; then
    echo "Creating config dir $nvimdir.."
    mkdir $nvim_dir
  fi

  if [[ ! -d "$nvim_dir/nvim" ]]; then
    echo "Linking nvimdir $nvimdir/nvim.."
    ln -s $HOME/.vim $nvim_dir/nvim
  fi

  local pip3loc=`which pip3`
  if [[ ! -x $pip3loc ]]; then
    echo "pip3 is NOT installed"
    echo "Skipping deoplete installation..."
    return
  fi

  local python_neovim=`pip3 list | grep neovim | wc -l`
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

check_requirements
copy_vimrc
install_vim_plug
install_theme
install_plugins
neovim_specific

echo "Vim was set up"
