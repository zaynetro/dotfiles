#!/bin/bash

set -e

# User friendly nix-env commands

USAGE="User friendly nix-env command.

Usage:
    nix-rz [flags] <command>

Flags:
    --dry                 Print commands without executing them

Commands:
    i[nstall] <package>   Install package
    u[pdate] <package>    Update package
    u[pdate] self         Update nix-env itself
    u[pdate]              Update all installed packages
    r[emove] <package>    Remove/Uninstall package

    l[ist]                List installed packages
    s[earch] <query>      Search available packages
    deps <package>        List package's dependencies

    c[lean]               Clean/Delete old generations
    g[enerations]         List generations
    r[ollback]            Rollback to previous generation
    switch <number>       Switch to generation (number can be obtained from generations' list)

    channels              List channels

See 'nix-rz' for this help message.

Examples:

    nix-rz install emacs                            Install emacs
    nix-rz i emacs                                  Install emacs
    nix-rz update ripgrep                           Update ripgrep
    nix-rz search ripgrep                           Search for ripgrep
    nix-rz s 'firefox.*'                            Search using regular expression

    nix-env -f '<nixpkgs>' -qaPA nodePackages       Search node packages
    nix-env -f '<nixpkgs>' -iA nodePackages.tern    Install node package
"

debug=

if [[ "$1" == "--dry" ]]; then
    debug=echo
    shift
fi

command=$1

case "$command" in
    "i"|"install") # Install package
        package=$2
        $debug nix-env -i $package
        ;;
    "u"|"update") # Update package
        package=$2

        case "$package" in
            "self")
                $debug nix-channel --update
                $debug nix-env -iA nixpkgs.nix
                ;;
            *)
                if [[ -z $package ]]; then
                    # If package is empty nix-env will update all installed packages
                    echo "Do you wish to update all installed packages?"
                    select yn in "Yes" "No"; do
                        case $yn in
                            Yes)
                                $debug nix-env -u;
                                break
                                ;;
                            No)
                                exit
                                ;;
                        esac
                    done
                else
                    $debug nix-env -u $package
                fi
                ;;
        esac
        ;;
    "r"|"remove") # Remove/Uninstall package
        package=$2
        $debug nix-env --uninstall $package
        ;;

    "l"|"list") # List installed packages
        $debug nix-env -q
        ;;
    "s"|"search") # Search available packages
        query=$2
        $debug nix-env -qa $query
        ;;
    "deps") # List package's dependencies
        package=$2
        $debug nix-store -q --tree `which $package`
        ;;

    "c"|"clean") # Clean/Delete old generations
        $debug nix-collect-garbage -d
        ;;
    "g"|"generations") # List generations
        $debug nix-env --list-generations
        ;;
    "r"|"rollback") # Rollback to previous generation
        $debug nix-env --rollback
        ;;
    "switch") # Switch to generation
        number=$2
        $debug nix-env -G $number
        ;;

    "channels") # List channels
        $debug nix-channel --list
        ;;

    *) # Help
        echo "$USAGE"
        ;;
esac
