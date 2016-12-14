#!/bin/bash

set -e

# Configure i3 window manager

apps="feh arandr lxappearance rofi i3blocks xbacklight syncthing ranger"

echo "Installing apps..."
sudo apt install -y $apps

# Set a background
echo "Copying wallpaper..."
cp wallpaper.jpg ~/Pictures/

# Install font awesome
if [ ! -f ~/.fonts/fontawesome-webfont.ttf ]; then
  echo "Installing Font Awesome..."
  fontdir=`mktemp -d`
  fontversion="4.6.3"
  wget https://github.com/FortAwesome/Font-Awesome/archive/v$fontversion.zip -P $fontdir
  unzip $fontdir/v$fontversion.zip -d $fontdir
  if [ ! -d ~/.fonts ]; then
    echo "Creating ~/.fonts directory..."
    mkdir ~/.fonts
  fi
  cp $fontdir/Font-Awesome-$fontversion/fonts/fontawesome-webfont.ttf ~/.fonts/
else
  echo "Font Awesome is installed, skipping..."
fi

# Configure screens
echo "Configure screens in arandr if needed"

# Installing arc theme
if [ ! "$(apt-cache show arc-theme)" ]; then
  echo "Installing arc theme..."
  wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
  sudo apt-key add - < Release.key
  sudo apt update
  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
  sudo apt update
  sudo apt install -y arc-theme
  echo "Choose arc-theme in lxappearance"
else
  echo "arc-theme is installed, skipping..."
fi

# Install paper icons
if [ ! "$(apt-cache show paper-icon-theme)" ]; then
  echo "Installing paper icon theme..."
  sudo add-apt-repository ppa:snwh/pulp
  sudo apt update
  sudo apt install -y paper-icon-theme
  echo "Choose paper icon theme in lxappearance"
else
  echo "paper icon theme is installed, skipping..."
fi

echo "Suspending on lid close..."
# TODO: uncomment `HandleLidSwitch=suspend` line in /etc/systemd/logind.conf
if [ ! -d "/etc/acpi/local" ]; then
  echo "Creating /etc/acpi/local..."
  sudo mkdir /etc/acpi/local
fi
sudo cp lid.sh.post /etc/acpi/local/

# Configure i3blocks
echo "Configuring i3block..."
cp i3blocks.conf ~/.config/i3/i3blocks.conf

# Configure i3
echo "Copying i3 configuration file..."
cp config ~/.config/i3/

echo "Restart i3 with mod+Shift+r"
