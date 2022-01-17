#!/usr/bin/env fish

function fish_personal_config -d "Configure Fish"
    # Use Vi
    fish_vi_key_bindings

    # Cargo
    if test -e $HOME/.cargo
        fish_add_path ~/.cargo/bin
    end

    # Go
    if test -e $HOME/go/bin
        fish_add_path ~/go/bin
    end

    # Python binaries
    if test -e $HOME/.local/bin
        fish_add_path ~/.local/bin
    end

    # User-friendly nix
    function nix-rz
        $HOME/.bash/nix-rz.sh $argv
    end

    # Default editor
    set -x EDITOR nvim
    set -x ASPELL_CONF "data-dir $HOME/.nix-profile/lib/aspell"

    #####################################################
    # Nix
    #####################################################
    if test -e $HOME/.nix-profile
        # include this plugin so nix will work
        # https://github.com/NixOS/nix/issues/1512
        # https://github.com/oh-my-fish/plugin-foreign-env
        set fish_function_path $fish_function_path $HOME/.config/fish/plugin-foreign-env/functions

        # initialize nix
        fenv source '$HOME/.nix-profile/etc/profile.d/nix.sh'
    end

end
