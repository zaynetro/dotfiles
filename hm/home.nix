# Search for packages with https://search.nixos.org
{ pkgs, pkgs-unstable, fenix, docs, ... }: {

  home.username = "roman";
  home.homeDirectory = "/Users/roman";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11";

  home.packages = [
    # Editor
    pkgs.emacs29
    pkgs.fd
    pkgs.neovim
    pkgs.ripgrep

    # Can't use pkgs.rustup because it provides rust-analyzer symlink that conflicts with an actual rust-analyzer...
    # Use `fenix.complete.withComponents` for nightly components
    # (fenix.complete.withComponents [
    (fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    pkgs-unstable.rust-analyzer

    # Tools
    pkgs.git
    pkgs.shellcheck
    pkgs-unstable.deno
    # pkgs-unstable.duckdb
    pkgs.protobuf
    pkgs.sqlite
    pkgs.tig
    pkgs.tree
    # pkgs-unstable.youtube-dl
    pkgs.zstd
    # pkgs.zola
    pkgs.shadowsocks-rust

    # Node
    pkgs.nodePackages.typescript-language-server
    # pkgs.nodejs

    # Elixir
    # pkgs-unstable.erlang_26
    # pkgs-unstable.elixir_1_15
    # pkgs-unstable.elixir-ls

    # Cloud:
    # pkgs-unstable.flyctl

    # Go
    pkgs.go
    pkgs-unstable.gopls

    # Python
    pkgs.poetry
    pkgs.python310

    # Fonts
    pkgs.fantasque-sans-mono
    # For icons in Doom
    (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })

    # Fuzzy search all cheatsheets
    (pkgs.writeShellApplication {
      name = "rzsnova";
      runtimeInputs = [ pkgs.fzf pkgs.gnugrep docs ];
      text = ''
        cd ${docs}/docs
        ${builtins.readFile ../scripts/rzsnova.sh}
      '';
    })
  ];

  home.file = {
    ".config/doom" = {
      source = ../emacs/doom.d;
      onChange = ''
        export PATH=~/.nix-profile/bin:$PATH
        if [[ -x ".config/emacs/bin/doom" ]]; then
          .config/emacs/bin/doom sync
        else
          echo 'Doom is not set up yet';
        fi
      '';
    };

    # I don't use programs.git.extraConfig because the order of sections is important.
    ".config/git/config" = {
      text = ''
        [user]
        	email = "roman@zaynetro.com"
        	name = "Roman Zaynetdinov"

        [init]
        	defaultBranch = main
      '';
    };
  };

  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;

    font.package = pkgs.fantasque-sans-mono;
    font.name = "Fantasque Sans Mono";
    font.size = 15;

    shellIntegration.enableFishIntegration = true;

    # Config options: https://sw.kovidgoyal.net/kitty/conf/
    extraConfig = ''
      shell  /Users/roman/.nix-profile/bin/fish
      remember_window_size  yes

      tab_bar_style        powerline
      tab_powerline_style  round

      scrollback_lines  100000

      # Use ctrl+shift+enter to open new window in home dir
      map cmd+enter        new_window_with_cwd
      # Use ctrl+shift+t to open new tab in home dir
      map cmd+t        new_tab_with_cwd
    '';

    # Use `kitten themes` to trial themes
    theme = "Gruvbox Light";
  };

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ../fish/config.fish;
  };
}
