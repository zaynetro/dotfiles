# Home configuration management with Nix

## Requirements

Enable flakes in `~/.config/nix/nix.conf`:
  
```
experimental-features = nix-command flakes
```

## Configure

* Configure in `home.nix`.
* Switch to new generation: `nix run . switch -- --flake .`

## Options

* Find available options: https://mipmip.github.io/home-manager-option-search/
* Find available package: https://search.nixos.org/packages

## Utils

* List generations: `nix run . generations`
* Enable old generation: `/nix/store/3z8-home-manager-generation/activate`
* Print help `nix run .` or `nix run . -- --help`
* Clean up old files: `nix store gc`


## References:

- https://github.com/nix-community/home-manager
- https://www.chrisportela.com/posts/home-manager-flake/
