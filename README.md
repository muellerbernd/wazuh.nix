# use with NixOS

add the following to your flake inputs
```nix
  wazuh-nix = {
    url = "github:muellerbernd/wazuh.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
```

add the following to you system config
```nix
  imports = [inputs.wazuh-nix.nixosModules.default];

  services.wazuh-agent = {
    enable = true;
    package = inputs.wazuh-nix.packages.${pkgs.system}.default;
    managerIP = "X.X.X.X";
  };

```
