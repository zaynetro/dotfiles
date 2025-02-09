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
    # (fenix.stable.withComponents [
    #   "cargo"
    #   "clippy"
    #   "rust-src"
    #   "rustc"
    #   "rustfmt"
    # ])
    # Use `complete` instead of `stable` for nightly components
    (with fenix; with stable; combine [
      cargo
      clippy
      rust-src
      rustc
      rustfmt
      # targets.wasm32-unknown-unknown.stable.rust-std
      # targets.aarch64-apple-ios.stable.rust-std
      # targets.aarch64-apple-ios-sim.stable.rust-std
    ])

    pkgs-unstable.rust-analyzer

    # For openssl-sys crate building
    # pkgs.pkgconfig
    # pkgs.openssl

    # Tools
    pkgs.git
    pkgs.shellcheck
    pkgs-unstable.deno
    # pkgs-unstable.duckdb
    # pkgs.protobuf
    pkgs.sqlite
    pkgs.tig
    pkgs.tree
    # pkgs-unstable.youtube-dl
    pkgs.zstd
    # pkgs.shadowsocks-rust
    pkgs-unstable.helix

    # Node
    pkgs.typescript # Needed for the language server
    pkgs.nodePackages.typescript-language-server
    # pkgs.nodejs

    # Elixir
    # pkgs-unstable.erlang_26
    # pkgs-unstable.elixir_1_15
    # pkgs-unstable.elixir-ls

    # Cloud:
    # pkgs-unstable.flyctl

    # Nix
    pkgs.nixd

    # Markdown
    pkgs.marksman

    # Go
    pkgs.go
    pkgs-unstable.gopls

    # Python
    pkgs.poetry
    pkgs.python313
    pkgs.pyright
    # pkgs-unstable.basedpyright

    # Zig
    # pkgs-unstable.zig
    # pkgs-unstable.zls

    # Creates wrong file permissions so using a downloaded SDK :/
    # pkgs.flutter327
    # pkgs.cocoapods
    # pkgs-unstable.flutter_rust_bridge_codegen
    # Can't install rustup but it is needed to build Flutter with Rust
    # Use: nix shell nixpkgs#rustup

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
        echo "............................................"
        echo "Remember to run: .config/emacs/bin/doom sync"
        echo "............................................"
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

    # Helix writes a debug log to ~/.cache/helix/helix.log
    # You can also start Helix in verbose mode: hx -v
    # Use :log-open command to open log file in the editor.
    ".config/helix/config.toml" = {
      text = ''
        # :theme and then tab to cycle between themes
        theme = "everforest_light"

        [editor]
        line-number = "relative"

        # Minimum severity to show a diagnostic after the end of a line:
        end-of-line-diagnostics = "hint"

        [editor.inline-diagnostics]
        # Minimum severity to show a diagnostic on the primary cursor's line.
        # Note that `cursor-line` diagnostics are hidden in insert mode.
        cursor-line = "error"
        # Minimum severity to show a diagnostic on other lines:
        other-lines = "error"

        [keys.normal.space]
        minus = "file_picker_in_current_buffer_directory"
      '';
    };

    ".config/helix/languages.toml" = {
      text = ''
        [language-server.pyright]
        command = "pyright-langserver"
        args = ["--stdio"]

        [[language]]
        name = "python"
        language-servers = ["pyright"]
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

      # Use left option key as Alt. By default it inserts unicode symbols.
      macos_option_as_alt left
    '';

    # Use `kitten themes` to trial themes.
    # Find the file name here: https://github.com/kovidgoyal/kitty-themes/tree/master/themes
    themeFile = "gruvbox-light";
  };

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ../fish/config.fish;
  };
}
