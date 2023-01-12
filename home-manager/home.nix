{ pkgs, ... }: {
  home.username = "roman";
  home.homeDirectory = "/var/home/roman";
  home.stateVersion = "22.11";

  home.packages = [
    # Editor
    # See extra emacs config below
    pkgs.emacsPgtk
    pkgs.fd
    pkgs.neovim
    pkgs.ripgrep

    # Needed for Rust to work...
    # https://github.com/mozilla/nixpkgs-mozilla/issues/82
    pkgs.clang
    # pkgs.rustup

    # For OpenSSL
    pkgs.perl
    pkgs.gnumake

    # Tools
    pkgs.nixfmt
    pkgs.protobuf
    pkgs.sqlite
    pkgs.tig
    pkgs.zola

    # Node
    pkgs.nodePackages.typescript-language-server

    # For Flutter
    # Linux: https://docs.flutter.dev/get-started/install/linux#additional-linux-requirements
    # WIP: https://github.com/NixOS/nixpkgs/pull/201027
    # pkgs.flutter
    # pkgs.clang
    # pkgs.cmake
    # pkgs.gtk3
    # pkgs.ninja
    # pkgs.pkg-config
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Roman Zaynetdinov";
    userEmail = "a@zaynetro.com";
  };

  # TODO: configure fish
  # https://nix-community.github.io/home-manager/options.html#opt-programs.fish.enable

  # TODO: configure syncthing
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
