#!/usr/bin/env bash

set -e

echo "Installing Flatpak applications..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.chromium.Chromium
# TODO: how to repace firefox?
rpm-ostree override remove firefox
flatpak install flathub org.mozilla.firefox

flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community
flatpak install flathub org.keepassxc.KeePassXC
flatpak install flathub io.github.seadve.Kooha
flatpak install flathub org.telegram.desktop
# TODO: Syncthing GTK hasn't been updated in two years. Run syncthing directly https://src.fedoraproject.org/rpms/syncthing
flatpak install flathub me.kozec.syncthingtk
flatpak install flathub com.slack.Slack
flatpak install flathub org.videolan.VLC
flatpak install flathub com.spotify.Client

echo "Configuring Gnome..."
# Use ctrl-tab to cycle Gnome tabs. Ref: https://superuser.com/a/1538005
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ next-tab '<Primary>Tab'
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ prev-tab '<Primary><Shift>Tab'

gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday true

echo "Configuring Doom Emacs..."
if [[ ! -L ~/.doom.d ]]; then
  echo "Linking to ~/.doom.d"
  ln -s $(pwd)/emacs/doom.d ~/.doom.d
fi

if [[ ! -e ~/.emacs.d ]]; then
  echo "Cloning doom-emacs..."
  git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
  ~/.emacs.d/bin/doom install
fi

echo "Configuring Fish..."
./fish/setup.sh

echo "Configuring fonts..."
./setup-fonts.sh

echo "Configuring Toolbox..."
toolbox create || echo 'Perhaps, already exists'
toolbox run sudo dnf module install nodejs:14/default
toolbox run sudo dnf -y install \
  fish \
  make \
  maven \
  neovim \
  java-11-openjdk-devel \
  rust \
  cargo \
  ripgrep \
  fd-find
# Gnome Tweaks is for managing Startup applications
# TODO: disable workspaces (set to Static and 1)
# TODO: show week numbers in the calendar
toolbox run sudo dnf -y install gnome-tweaks
