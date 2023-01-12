#!/usr/bin/env bash

set -e

echo "Installing Flatpak applications..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.chromium.Chromium
rpm-ostree override remove firefox
flatpak install -y flathub org.mozilla.firefox
# Run in Wayland session: https://old.reddit.com/r/LinuxCafe/comments/isdmmp/tip_use_firefox_flatpak_in_native_wayland_no/
flatpak --user override --socket=wayland --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox

flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Community
flatpak install -y flathub org.keepassxc.KeePassXC
flatpak install -y flathub io.github.seadve.Kooha
flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub com.slack.Slack
flatpak install -y flathub org.videolan.VLC
flatpak install -y flathub com.spotify.Client
# Manage Flatpak application permissions
flatpak install -y flathub com.github.tchx84.Flatseal

echo "Configuring Gnome..."
# Use ctrl-tab to cycle Gnome tabs. Ref: https://superuser.com/a/1538005
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ next-tab '<Primary>Tab'
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ prev-tab '<Primary><Shift>Tab'

gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface enable-hot-corners false

flatpak install -y flathub com.mattjakeman.ExtensionManager

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
  fd-find \
  sqlite \
  pkg-config openssl-devel

# Gnome Tweaks is for managing Startup applications
# TODO: disable workspaces (set to Static and 1) <- Find gsettings key for that
toolbox run sudo dnf -y install gnome-tweaks

echo "Configuring Syncthing..."
systemctl --user enable --now syncthing.service
# Web UI: http://localhost:8384/
# From https://src.fedoraproject.org/rpms/syncthing
#
# The syncthing user session service will not automatically be restarted after package updates.
# Instead, the user has to either restart syncthing from the web interface, log out and back in, or run the following commands manually:
#
# > systemctl --user daemon-reload
# > systemctl --user restart syncthing.service
