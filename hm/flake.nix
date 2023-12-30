{
  description = "Home Manager configuration of roman";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
      file = builtins.readFile;

      # pkgs definitions below allow to set up overlays:  https://nixos.wiki/wiki/Overlays#In_a_Nix_flake
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      fenix = fenixsrc.packages.${system};

      # Store cheatsheet docs in Nix store
      docFiles = builtins.attrNames (builtins.readDir ../docs);
      storeDoc = name: pkgs.writeTextDir "docs/${name}" (file ../docs/${name});
      docPaths = map storeDoc docFiles;
      docs = pkgs.symlinkJoin {
        name = "docs";
        paths = docPaths;
      };

    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # inherit is the same as: `pkgs = pkgs;`
        inherit pkgs;

        modules = [
          ./home.nix
          # TODO: make this conditional
          # https://nix.dev/tutorials/file-sets
          # ./work.nix
        ];

        extraSpecialArgs = {
          inherit pkgs-unstable;
          inherit fenix;
          inherit docs;
        };
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
