{
    description = "My Nix Configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
        hyprland.url = "github:hyprwm/Hyprland";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs@{
        self,
        nixpkgs,
        nixpkgs-stable,
        hyprland,
        home-manager,
        ...
    }:let 

        system = "x86_64-linux";
        lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages.legacyPackages.${system};
        pkgs-stable = nixpkgs-stable.legacyPackages.${system};
        username = "rick";
        name = "Rick";

    in {  

        nixosConfigurations.razor-crest = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit lib;
            modules = [ 
                ./system/configuration.nix
                hyprland.nixosModules.default
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.rick = import ./home-manager/home.nix;
                    home-manager.extraSpecialArgs = {
                        inherit inputs;
                        inherit self;
                        inherit username;
                    };
                }
            ];
            specialArgs = {
                inherit username;
                inherit name;
                inherit pkgs-stable;
                inherit inputs;
                inherit self;
            };
        };
    };
}
