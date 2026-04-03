{
  description = "NixOS Configuration flake";
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen.url = "github:/InioX/Matugen";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, nix-index-database, ... } @ inputs:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            nix-index-database.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.artem = ./modules/hm/home.nix;
              home-manager.backupFileExtension = "bck";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                sops-nix.homeManagerModules.sops
              ];
            }
            sops-nix.nixosModules.sops
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
