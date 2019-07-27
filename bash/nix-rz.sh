#!/bin/bash

set -e

# User friendly nix-env commands

USAGE="User friendly nix-env command.

Usage:
    nix-rz <command>

Commands:
    i[nstall] <package>   Install package
    u[pdate] <package>    Update package
    u[pdate] self         Update nix-env itself
    u[pdate]              Update all installed packages
    r[emove] <package>    Remove/Uninstall package
    l[ist]                List installed packages
    s[earch] <query>      Search available packages
    c[lean]               Clean/Delete old generations

See 'nix-rz' for this help message.

Examples:

    nix-rz install emacs                            Install emacs
    nix-rz i go                                     Install emacs
    nix-rz update ripgrep                           Update ripgrep
    nix-rz search ripgrep                           Search for ripgrep
    nix-rz s 'firefox.*'                            Search using regular expression

    nix-env -f '<nixpkgs>' -qaPA nodePackages       Search node packages
    nix-env -f '<nixpkgs>' -iA nodePackages.tern    Install node package
"

command=$1

case "$command" in
    "i"|"install") # Install package
        package=$2
        nix-env -i $package
        ;;
    "u"|"update") # Update package
        package=$2

        case "$package" in
            "self")
                nix-channel --update
                nix-env -iA nixpkgs.nix
                ;;
            *)
                if [[ -z $package ]]; then
                    # If package is empty nix-env will update all installed packages
                    echo "Do you wish to update all installed packages?"
                    select yn in "Yes" "No"; do
                        case $yn in
                            Yes)
                                nix-env -u;
                                break
                                ;;
                            No)
                                exit
                                ;;
                        esac
                    done
                else
                    nix-env -u $package
                fi
                ;;
        esac
        ;;
    "r"|"remove") # Remove/Uninstall package
        package=$2
        nix-env --uninstall
        ;;
    "l"|"list") # List installed packages
        nix-env -q
        ;;
    "s"|"search") # Search available packages
        query=$2
        nix-env -qa $query
        ;;
    "c"|"clean") # Clean/Delete old generations
        nix-collect-garbage -d
        ;;
    *) # Help
        echo "$USAGE"
        ;;
esac
