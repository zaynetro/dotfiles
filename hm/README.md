# Home configuration management with Nix

Install Nix using <https://github.com/DeterminateSystems/nix-installer>

## Requirements

> This is not needed if Nix is installed using nix-installer from DeterminateSystems

Enable flakes in `~/.config/nix/nix.conf`:
  
```
experimental-features = nix-command flakes
```

## Configure

* Init home manager: `nix run home-manager/release-24.05 -- init --switch ~/Code/dotfiles/hm`
* Configure in `home.nix`.
* Switch to new generation: `home-manager switch --flake ~/Code/dotfiles/hm`

## Updates

* Update nixpkgs: `nix flake update`
* Upgrade Nix: `sudo nix upgrade-nix`

## Options

* Find available options: <https://mipmip.github.io/home-manager-option-search/>
* Find available package: <https://search.nixos.org/packages>

## Utils

> In case home-manager is not in the PATH. We can add  
> `packages.${system}.default = home-manager.defaultPackage.${system};`  
> And then run the flake directly with `nix run` 

* List generations: `home-manager generations`
* Enable old generation: `/nix/store/3z8-home-manager-generation/activate`
* Clean up old files: `nix store gc`
* Format `nix fmt`


## References:

- <https://github.com/nix-community/home-manager>
- <https://www.chrisportela.com/posts/home-manager-flake/>
