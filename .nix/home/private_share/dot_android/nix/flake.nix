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
          ./profile/desktop/default.nix
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
            home-manager.users.share = import ./profile/desktop/home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };

      qemu = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./profile/desktop/default.nix
          ./host/qemu/default.nix
          home-manager.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.share = import ./profile/desktop/home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };

      aliyun = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./host/aliyun/default.nix   # 内含 base.nix + hardware + image
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                ossfs2 = import ./module/ossfs2 { pkgs = prev; };
              })
            ];
          })
          home-manager.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.share = import ./profile/server/home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
  };
}
