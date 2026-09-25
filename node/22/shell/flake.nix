{
  description = "NodeJS Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nvim-config-pkg = {
      url = "github:SawyerHopkins/nvim-config";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nvim-config-pkg,
    nvim-treesitter
  }:
  let
    supportedSystems = ["aarch64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;
    pkgsFor = system: import nixpkgs { inherit system; };
  in
  {
    packages = forAllSystems (system: {
      nvim-ts-runtime = (pkgsFor system).callPackage ./tree-sitter.nix {
        queriesSrc = nvim-treesitter;
      };
    });

    devShells = forAllSystems (system: {
      default = import ./shell.nix {
        pkgs = pkgsFor system;
        tsRuntime = self.packages.${system}.nvim-ts-runtime;
        nvimConfig = nvim-config-pkg;
      };
    });
  };
}
