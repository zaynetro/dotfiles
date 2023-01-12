# Dev setup

Bash scripts to help set up dev tools on new machine

* Generate SSH key `ssh-keygen -t rsa -b 4096 -C "<email>"`
* (Not always required) Add SSH key to the agent `eval "$(ssh-agent -s)"` and `ssh-add ~/.ssh/id_rsa`
* Add SSH pub key to github https://github.com/settings/keys

## Fedora Silverblue

* Generate SSH keys
* `git clone git@github.com:zaynetro/dotfiles.git`
* `rpm-ostree upgrade`
* `./setup-ostree-overrides.sh`
* If previous step tells you to reboot then reboot (Alternatively, you can `sudo rpm-ostree ex apply-live`)
* `./setup-fedora.sh`
* Use fish `sudo usermod --shell /usr/bin/fish <user>`
* Gnome extension to show tray icons https://extensions.gnome.org/extension/615/appindicator-support/
    * Open "Extensions Manager" and install "AppIndicator and KStatusNotifierItem Support"
    
## Nix on Fedora Silverblue

Ref: https://gist.github.com/queeup/1666bc0a5558464817494037d612f094

- ### Change SELinux mode to permissive  
  ``` bash
  sudo setenforce Permissive
  sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
  ```
- ### Create the nix directory in a persistent location  
  ``` bash
  sudo mkdir /var/lib/nix
  sudo chown $USER:$USER /var/lib/nix
  ```
- ### `/etc/systemd/system/mkdir-rootfs@.service`  
  ```ini
  [Unit]
  Description=Enable mount points in / for ostree
  ConditionPathExists=!%f
  DefaultDependencies=no
  Requires=local-fs-pre.target
  After=local-fs-pre.target

  [Service]
  Type=oneshot
  ExecStartPre=chattr -i /
  ExecStart=mkdir -p '%f'
  ExecStopPost=chattr +i /
  ```
- ### `/etc/systemd/system/nix.mount`  
  ```ini
  [Unit]
  Description=Nix Package Manager
  DefaultDependencies=no
  After=mkdir-rootfs@nix.service
  Wants=mkdir-rootfs@nix.service
  Before=sockets.target
  After=ostree-remount.service
  BindsTo=var.mount

  [Mount]
  What=/var/lib/nix
  Where=/nix
  Options=bind
  Type=none

  [Install]
  WantedBy=local-fs.target
  ```
- ### Enable and mount the nix mount.
  ``` bash
  # Ensure systemd picks up the newly created units
  sudo systemctl daemon-reload
  # Enable the nix mount on boot.
  sudo systemctl enable nix.mount
  # Mount the nix mount now.
  sudo systemctl start nix.mount
  ```
- ## Install Nix
    
  ``` bash
  curl -L https://nixos.org/nix/install | sh
  ```
  
- ## Enable flakes `~/.config/nix/nix.conf`
  
  ```
  experimental-features = nix-command flakes
  ```

## Old setup

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
