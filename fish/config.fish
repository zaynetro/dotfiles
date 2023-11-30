
# Nix installer tries to put this under /etc/fish if that file exists.
# I manage fish with Nix so it is not there during Nix installation.
# Ref: https://github.com/DeterminateSystems/nix-installer/blob/df9610edba01194e3c342c13ddba80f2251304c4/src/action/common/configure_shell_profile.rs#L69
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish;
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
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

# Deno
fish_add_path ~/.deno/bin

# Global utilities (like Docker)
fish_add_path /usr/local/bin

# Add device specific overrides
if test -e ~/.config/fish/local.fish;
    . ~/.config/fish/local.fish
end
