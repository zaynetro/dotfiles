# Dev setup


## Mac setup

- Install Nix using [nix-installer](https://github.com/DeterminateSystems/nix-installer)
- Configure the system:

```sh
# Generate SSH key
ssh-keygen -t ed25519 -C "<email>"

# Add public key to GitHub
cat .ssh/id_ed25519.pub

# Clone this repo
git clone git@github.com:zaynetro/dotfiles.git

# Init Home Manager
nix run home-manager/release-23.05 -- init ~/Code/dotfiles/hm
# Activate hm configuration
home-manager switch --flake ~/Code/dotfiles/hm
```

- Doom emacs:

```
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom sync
```

- Make sure there is no `~/.emacs.d` directory. Because it will be picked first.


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


**License:** MIT
