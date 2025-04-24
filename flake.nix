# {
#   description = "A very basic flake";
#
#   inputs = {
#     nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
#     flake-utils.url = "github:numtide/flake-utils";
#   };
#
#   outputs = {
#     self,
#     nixpkgs,
#     flake-utils,
#   }:
#     flake-utils.lib.eachDefaultSystem (
#       system: let
#         pkgs = nixpkgs.legacyPackages.${system};
#       in rec {
#         formatter = pkgs.alejandra;
#         packages = {
#           wazuh-agent = pkgs.callPackage ./pkgs/wazuh-agent.nix {};
#         };
#         overlays = {
#           wazuh = _: __: {
#             inherit packages;
#           };
#         };
#         nixosModules = {
#           wazuh-agent = import ./modules/wazuh-agent;
#         };
#       }
#     );
# }
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
