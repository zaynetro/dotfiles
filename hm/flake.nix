{
  description = "Home Manager configuration of roman";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenixsrc = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # It could be that we need to install a specific version of a package.
    # Some package definitions let you pick the right version.
    # See `nodejs` for example: https://search.nixos.org/packages?channel=23.05&query=nodejs
    # You can pick `nodejs_20`, `nodejs_18` or `nodejs_16`.
    # This is very helpful but sometimes not enough.
    # You can use https://www.nixhub.io/ to find the commit reference that introduced the version.
    # nixpkgs-go-1_19.url = "github:NixOS/nixpkgs/8ba120420fbdd9bd35b3a5366fa0206d8c99ade3";
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
        # inherit pkgs;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

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
