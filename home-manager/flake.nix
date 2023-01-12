{
  description = "Home Manager configuration of zaynetro";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Emacs overlay: https://nixos.wiki/wiki/Emacs
    # Nix overlays:  https://nixos.wiki/wiki/Overlays#In_a_Nix_flake
    emacs-overlay.url = "github:nix-community/emacs-overlay/1e4763dd90ad8712b459d1f5e53cbbc047b75dd0";
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; overlays = [(import emacs-overlay)]; };
    in {
      defaultPackage.x86_64-linux = home-manager.defaultPackage.${system};
      homeConfigurations.roman = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];
      };
    };
}
