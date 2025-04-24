{
  description = "wazuh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    nixosModules.wazuh-agent = ./modules/wazuh-agent;
    nixosModules.default = self.nixosModules.wazuh-agent;

    overlays.default = import ./overlay.nix;

    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = eachSystem (system: {
      wazuh-agent = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/wazuh-agent.nix {};
      default = self.packages.${system}.wazuh-agent;
    });
  };
}
