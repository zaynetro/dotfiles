#!/usr/bin/env bash

set -e

# Create fish config directory
fish_dir=$HOME/.config/fish
mkdir -p $fish_dir

# Validate that fish.config exists
fish_config=$fish_dir/config.fish
if [[ ! -f $fish_config ]]; then
  echo "Creating $fish_config..."
  touch $fish_config
fi

# Link personal config to fish functions
mkdir -p $fish_dir/functions
config_fun_dest=$fish_dir/functions/fish_personal_config.fish
if [[ ! -f $config_fun_dest ]]; then
  echo "Linking to $config_fun_dest"
  ln -s $(pwd)/fish_personal_config.fish $config_fun_dest
fi

common_str="fish_personal_config"
if ! grep -Fxq "$common_str" $fish_config; then
  echo "Adding fish personal config to $fish_config..."
  echo "$common_str" >> $fish_config
fi

# Verify we have fenv installed
fenv_dir=$fish_dir/plugin-foreign-env
if [[ ! -d $fenv_dir ]]; then
  echo "Cloning fenv..."
  git clone https://github.com/oh-my-fish/plugin-foreign-env.git
fi

echo "Done."
