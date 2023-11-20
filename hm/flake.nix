{
  description = "Home Manager configuration of roman";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenixsrc = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, fenixsrc, ... }:
    let
      system = "aarch64-darwin";
      username = "roman";

      # pkgs definitions below allow to set up overlays:  https://nixos.wiki/wiki/Overlays#In_a_Nix_flake
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      fenix = fenixsrc.packages.${system};
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

        extraSpecialArgs = {
          inherit pkgs-unstable;
          inherit fenix;
        };
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
