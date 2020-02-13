# Dev setup

Bash scripts to help set up dev tools on new machine

**License:** MIT


Install nix-env

```
nix-env -i emacs
nix-env -i neovim
nix-env -i vim
nix-env -i ripgrep
nix-env -i tree
nix-env -i tig
nix-env -i aspell
nix-env -f '<nixpkgs>' -iA aspellDicts.en
```
