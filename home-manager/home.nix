# Search for packages with https://search.nixos.org
{ pkgs, pkgs-unstable, fenix, ... }: {

  home.packages = [
    # Editor
    pkgs.emacs29
    pkgs.fd
    pkgs.neovim
    pkgs.ripgrep

    # Needed for Rust to work...
    # https://github.com/mozilla/nixpkgs-mozilla/issues/82
    # pkgs.clang
    # Can't use rustup because it provides rust-analyzer symlink that conflicts with an actual rust-analyzer...
    # pkgs.rustup
    # Use fenix.complete.withComponents for nightly components
    # (fenix.complete.withComponents [
    (fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    pkgs-unstable.rust-analyzer

    # For OpenSSL
    # pkgs.perl
    # pkgs.gnumake

    # Tools
    pkgs-unstable.deno
    # pkgs-unstable.duckdb
    pkgs.protobuf
    pkgs.sqlite
    pkgs.tig
    pkgs.tree
    # pkgs-unstable.youtube-dl
    pkgs.zstd
    # pkgs.zola
    pkgs-unstable.shadowsocks-rust

    # Node
    pkgs.nodePackages.typescript-language-server
    pkgs.nodejs

    # Elixir
    # pkgs-unstable.erlang_26
    # pkgs-unstable.elixir_1_15
    # pkgs-unstable.elixir-ls

    # Nats:
    # pkgs.natscli
    # pkgs-unstable.nats-server

    # Cloud:
    pkgs-unstable.flyctl

    # Package is broken to build it I needed:
    # > set NIXPKGS_ALLOW_BROKEN 1 <-- actually I think only config worked
    # > nix run . switch -- --flake . --impure
    # Didn't work still :/
    # pkgs-unstable.nsc

    # Go
    # pkgs.go
    # pkgs.gopls

    # Python
    pkgs-unstable.poetry
    pkgs.python311

    # For Flutter
    # Linux: https://docs.flutter.dev/get-started/install/linux#additional-linux-requirements
    # WIP (linux): https://github.com/NixOS/nixpkgs/pull/201027
    # WIP (darwin): https://github.com/NixOS/nixpkgs/pull/210067
    # pkgs.flutter
    # pkgs.clang
    # pkgs.cmake
    # pkgs.gtk3
    # pkgs.ninja
    # pkgs.pkg-config
  ];

  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Roman Zaynetdinov";
    userEmail = "roman@zaynetro.com";
  };

  programs.fish = {
    enable = true;

    shellInit = ''
      # Single-user installation
      # if test -e /Users/roman/.nix-profile/etc/profile.d/nix.fish;
      #     . /Users/roman/.nix-profile/etc/profile.d/nix.fish;
      # end

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
      fish_add_path $HOME/.pub-cache/bin
      fish_add_path $HOME/Code/flutter/bin

      # Add device specific overrides
      if test -e ~/.config/fish/local.fish;
          . ~/.config/fish/local.fish
      end
    '';
  };

  # services.syncthing.enable = true;
}

# Emacs extra config:
# - Nix saves desktop entries to `.nix-profile/share/applications`
# - By default those entries are not picked: https://github.com/nix-community/home-manager/issues/1439
# - Either extend XDG_DATA_DIRS env var
# - Or set up manually:
#
# Manual setup:
# - Create desktop entry in `.local/share/applications/emacs.desktop`
#   (copied from https://github.com/nix-community/home-manager/blob/master/modules/services/emacs.nix#L16 )
#
# [Desktop Entry]
# Type=Application
# Exec=emacs %F
# Terminal=false;
# Name=Emacs
# Icon=emacs
# Comment=Edit text
# GenericName=Text Editor
# MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
# Categories=Development;TextEditor;
# Keywords=Text;Editor;
# StartupWMClass=clientWMClass
#
# - Copy icons from `.nix-profile/share/icons` to `.local/share/icons`
