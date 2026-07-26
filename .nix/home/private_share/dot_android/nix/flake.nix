{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      vmware = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./host/vmware/default.nix
          home-manager.nixosModules.default
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                open-vm-tools = import ./module/open-vm-tools-wayland { pkgs = prev; };
              })
            ];
          })
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.share = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };

      qemu = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./host/qemu/default.nix
          home-manager.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.share = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };

      aliyun = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./host/aliyun/default.nix
          home-manager.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.share = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
  };
}
