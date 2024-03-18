{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "git+ssh://git@github.com/mitchellh/ghostty";
    };
  };

  outputs = { self, nixpkgs, home-manager, ghostty, ... }@inputs:
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/default/configuration.nix
            inputs.home-manager.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              environment.systemPackages = [
                ghostty.packages.x86_64-linux.default
              ];
            }
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
