{
  lib,
  runCommand,
  tree-sitter-grammars,
  queriesSrc
}:
let
  grammars = import ./grammars.nix tree-sitter-grammars;

  # Shipped by Neovim itself — don't shadow its parsers or queries.
  bundled = [ "c" "lua" "markdown" "markdown_inline" "query" "vim" "vimdoc" ];
in
  runCommand "nvim-ts-runtime" { passthru = { inherit grammars; }; } ''
    mkdir -p $out/parser $out/queries

    ${lib.concatStringsSep "\n" (lib.mapAttrsToList
      (lang: drv: "ln -s ${drv}/parser $out/parser/${lang}.so") grammars)}

    cp -r ${queriesSrc}/runtime/queries/. $out/queries/
    chmod -R u+w $out/queries
    ${lib.concatMapStringsSep "\n" (l: "rm -rf $out/queries/${l}") bundled}
  ''
