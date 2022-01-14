#!/usr/bin/env bash

set -e

if ! fc-list | grep Hack; then
  echo "Installing Hack font..."
  curl -L -o Hack.zip https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
  unzip Hack.zip
  cp ttf/*.ttf ~/.local/share/fonts/
  fc-cache -f -v
  rm -r ttf
  rm Hack.zip
fi
