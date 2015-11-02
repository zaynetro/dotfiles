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
}

# Install Vim-plug only if needed
install_vim_plug() {
	local plugdir=$HOME/.vim/autoload/plug.vim

	if [[ ! -d $vundledir ]]; then
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

# Install Vundle plugins
install_plugins() {
	if [[ -z $vimrc_changed ]]; then
    echo "Updating vim plugins..."
	  vim +PlugUpdate +qall
		return
	fi

	echo "Installing vim plugins..."
	vim +PlugInstall +qall
  echo "Remember: unlink python installed with brew"
  echo "NOTE: install go binaries if needed"
  echo "  vim -c \":GoInstallBinaries\""
}

check_requirements
copy_vimrc
install_vim_plug
install_theme
install_plugins

echo "Vim was set up"
