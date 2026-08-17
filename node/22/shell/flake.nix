{
  description        = "NodeJS Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nvim-config-pkg = {
      url = "github:SawyerHopkins/nvim-config";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nvim-config-pkg }:
    let
      supportedSystems = ["aarch64-linux"];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.ubase
              pkgs.nodejs_22
              pkgs.corepack
              pkgs.neovim-unwrapped
              pkgs.ripgrep
              pkgs.fd
              pkgs.lazygit
              pkgs.fzf
              pkgs.jq
              pkgs.tree-sitter
              pkgs.bashInteractive
            ];

            shellHook = ''
              echo "NodeJS Development Environment"
              node --version

              echo "Environment setup started"
              mkdir -p /root/.config/nvim
              cp -r ${nvim-config-pkg}/* /root/.config/nvim/
              echo "Environment setup complete"
            '';
          };
        }
      );
    };
}
