# Dev setup

Bash scripts to help set up dev tools on new machine

* Generate SSH key `ssh-keygen -t rsa -b 4096 -C "<email>"`
* (Not always required) Add SSH key to the agent `eval "$(ssh-agent -s)"` and `ssh-add ~/.ssh/id_rsa`
* Add SSH pub key to github https://github.com/settings/keys
* Install nix-env: https://nixos.org/nix/manual/#chap-installation
* Install tools

```
nix-env -i emacs
nix-env -i neovim
nix-env -i vim
nix-env -i ripgrep
nix-env -i tree
nix-env -i tig
nix-env -i nodejs
nix-env -i rustup
nix-env -i aspell
nix-env -f '<nixpkgs>' -iA aspellDicts.en
```

* Setup spacemacs: 

```
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d && git checkout develop`
```

* Setup git:

```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```


**License:** MIT
