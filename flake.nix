{
  description = "Mansoor Faqiri's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    self.submodules = true;

    nixosConfigurations = {
      myNixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
        };

        modules = [
          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              users = {
                mfaqiri = import ./home-manager/home.nix;
              };
            };
          }
        ];
      };
    };
  };
}
