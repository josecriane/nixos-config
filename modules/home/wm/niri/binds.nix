{ lib }:

let
  stripQuotes = lib.replaceStrings [ "\"" ] [ "" ];

  capitalise =
    s: if s == "" then s else lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (-1) s;

  # `spawn "a" "b"` reads better as the command line; a niri action reads
  # better as prose.
  derivedTitle =
    body:
    let
      words = map stripQuotes (builtins.filter (p: p != "") (lib.splitString " " body));
    in
    if builtins.head words == "spawn" then
      lib.concatStringsSep " " (builtins.tail words)
    else
      capitalise (lib.concatStringsSep " " (lib.splitString "-" (lib.concatStringsSep " " words)));

  # Only lines shaped `KEY { action; }` match, so a bind that already carries a
  # hotkey-overlay-title (or anything else between the key and the brace) falls
  # through untouched and keeps the wording written by hand.
  annotate =
    line:
    let
      m = builtins.match "([[:space:]]*)([^[:space:]{]+)([[:space:]]*[{][[:space:]]*)(.+)(;[[:space:]]*[}][[:space:]]*)" line;
    in
    if m == null then
      line
    else
      let
        indent = builtins.elemAt m 0;
        key = builtins.elemAt m 1;
        open = builtins.elemAt m 2;
        body = builtins.elemAt m 3;
        close = builtins.elemAt m 4;
      in
      ''${indent}${key} hotkey-overlay-title="${derivedTitle body}"${open}${body}${close}'';
in
files:
lib.concatStringsSep "\n" (
  map annotate (lib.concatMap (f: lib.splitString "\n" (builtins.readFile f)) files)
)
