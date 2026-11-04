{
  pkgs,
  tsRuntime,
  nvimConfig
}:
let
  gitSetup = pkgs.callPackage ./git.nix {
    userName = "Sawyer Hopkins";
    userEmail = "sawyer@sawyerhopkins.com";
  };
in
pkgs.mkShell {
  buildInputs = [
    # utilities
    pkgs.ubase
    pkgs.htop
    pkgs.ripgrep
    pkgs.fd
    pkgs.lazygit
    pkgs.fzf
    pkgs.jq
    pkgs.tree-sitter
    pkgs.bashInteractive

    # node
    pkgs.nodejs_22
    pkgs.corepack

    # devops
    pkgs.awscli2
    pkgs.opentofu

    # editor
    pkgs.neovim-unwrapped

    # slopware
    pgs.claude-code

    # language servers
    pkgs.vscode-langservers-extracted
    pkgs.vtsls
    pkgs.vue-language-server
    pkgs.tailwindcss-language-server
    pkgs.lua-language-server
    pkgs.typos-lsp
    pkgs.lemminx
    pkgs.yaml-language-server
    pkgs.terraform-ls
    pkgs.bash-language-server
    pkgs.shellcheck
    pkgs.nixd

    # debug adapters
    pkgs.vscode-js-debug
  ];

  shellHook = ''
    echo "NodeJS Development Environment"
    node --version

    echo "Environment setup started"

    echo "Configuring Neovim"
    mkdir -p /root/.config/nvim
    cp -r ${nvimConfig}/* /root/.config/nvim/

    echo "Configurating Tree Sitter"
    export NVIM_TS_RUNTIME=${tsRuntime}
    export VUE_LS_PATH=${pkgs.vue-language-server}/lib/language-tools/packages/language-server
    export JS_DAP_PATH=${pkgs.vscode-js-debug}/lib/node_modules/js-debug/./dist/src/dapDebugServer.js

    echo Configuring Git
    ${gitSetup}/bin/setup-git

    echo "Environment setup complete"

    unset shellHook
  '';
}
