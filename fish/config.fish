# Multi-user installation
fish_add_path /nix/var/nix/profiles/default/bin
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish;
    . /nix/var/nix/profiles/default/etc/profile.d/nix.fish;
end

set -x EDITOR nvim

# Use Vi
fish_vi_key_bindings

# Rust/Cargo
fish_add_path ~/.cargo/bin

# Go
fish_add_path ~/go/bin

# Python
fish_add_path ~/.local/bin

# Dart/Flutter
fish_add_path ~/.pub-cache/bin
fish_add_path ~/Code/flutter/bin

# Add device specific overrides
if test -e ~/.config/fish/local.fish;
    . ~/.config/fish/local.fish
end
