{ lib, pkgs }:

let
  stripQuotes = lib.replaceStrings [ "\"" ] [ "" ];

  # A niri bind is one line of `KEY { action args...; }`. Anything else
  # (comments, blank lines, the surrounding block) yields null and is dropped.
  parseLine =
    line:
    let
      m = builtins.match "[[:space:]]*([^[:space:]{]+)[[:space:]]*[{][[:space:]]*(.+);[[:space:]]*[}][[:space:]]*" line;
    in
    if m == null then
      null
    else
      let
        parts = builtins.filter (p: p != "") (lib.splitString " " (builtins.elemAt m 1));
      in
      {
        key = builtins.elemAt m 0;
        action = builtins.head parts;
        args = lib.concatStringsSep " " (map stripQuotes (builtins.tail parts));
      };

  parseBinds =
    files:
    let
      lines = lib.concatMap (f: lib.splitString "\n" (builtins.readFile f)) files;
    in
    lib.imap0 (order: bind: bind // { inherit order; }) (
      builtins.filter (b: b != null) (map parseLine lines)
    );
in
pkgs.writeText "binds.json" (
  builtins.toJSON {
    binds = parseBinds [
      ../keybinds.kdl
      ./keybinds.kdl
    ];
  }
)
