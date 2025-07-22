# Usage

If you are using `flake.nix` for system configuration:

**flake.nix**
```nix
{
  inputs = {
    ...
    kobweb-cli = {
      url = "github:dshatz/kobweb-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = ...
}
```


**configuration.nix**
```nix
environment.systemPackages = [
   ...
  inputs.kobweb-cli.packages.${system}.kobweb-cli
];
```
