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
  home.stateVersion = "23.05";

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
    # pkgs-unstable.flyctl

    # Go
    # pkgs.go
    # pkgs.gopls

    # Python
    # pkgs-unstable.poetry
    # pkgs.python311

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
        selected=$(grep --line-buffered --color=never -H -r "" -- * | fzf --height=40%)

        file_with_name=$(echo "$selected" | awk -F# '{print $1}')
        file=$(echo "$file_with_name" | awk -F: '{print $1}')
        # Last awk command trims leading and trailing whitespace
        name=$(echo "$file_with_name" | awk -F: '{print $2}' | awk '{$1=$1};1')
        details=$(echo "$selected" | awk -F# '{print $2}')

        grey="\e[37m"
        italic="\e[3m"
        clear="\e[0m"

        # shellcheck disable=SC3037
        echo -e "''${grey}''${file}:$clear"
        # shellcheck disable=SC3037
        echo -e "  $name  $italic#''${details}$clear"
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
  };

  programs.home-manager.enable = true;

  # Cheatsheet
  # cmd+enter OR ctrl+shift+enter  Open new pane
  # ctrl+shift+l      Switch between layouts
  # ctrl+shift+esc    Open kitty shell (e.g there I can `goto-layout grid`)
  # ctrl+cmd+,        Reload config file
  # ctrl+shift+g      Open last command's output in the pager
  # ctrl+shift+right-click  Open any command's output in the pager
  # ctrl+shift+e      Open URL in the browser
  # ctrl+shift+n OR cmd+n  New OS window
  # cmd+r             Resize pane
  # cmd+{0,1,...}     Focus pane
  # ctrl+shift+[      Previous pane
  # ctrl+shift+]      Next pane
  # ctrl+shift+f      Move pane forward
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

      # Use ctrl+shift+enter to open new window in home dir
      map cmd+enter        new_window_with_cwd
      # Use ctrl+shift+t to open new tab in home dir
      map cmd+t        new_tab_with_cwd
    '';

    # Use `kitten themes` to trial themes
    theme = "Gruvbox Light";
  };

  programs.git = {
    enable = true;
    userName = "Roman Zaynetdinov";
    userEmail = "roman@zaynetro.com";
  };

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ../fish/config.fish;
  };
}
