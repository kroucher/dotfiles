{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          # homeConfigurations = {
          #   "daniel" = inputs.home-manager.lib.homeManagerConfiguration {
          #     system = "x86_64-linux";
          #     homeDirectory = "/home/daniel";
          #     username = "daniel";
          #     configuration.imports = [ ./hosts/default/home.nix ];
          #   };
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/default/configuration.nix
            inputs.home-manager.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.daniel = import ./hosts/default/home.nix;
            }
          ];
        };
      };
    };
}
