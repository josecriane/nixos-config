{
  config,
  lib,
  pkgs,
  ...
}:

let
  sharedDir = "${config.xdg.configHome}/3dprinting";

  orca-slicer = pkgs.symlinkJoin {
    name = "orca-slicer";
    paths = [ pkgs.orca-slicer ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/orca-slicer \
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
        --run "${orcaImportSharedPrinters} || true"
    '';
  };

  bcn3d-stratos = pkgs.symlinkJoin {
    name = "bcn3d-stratos";
    paths = [ pkgs.bcn3d-stratos ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/bcn3d-stratos \
        --set XDG_CONFIG_HOME ${sharedDir}/stratos/config \
        --set XDG_DATA_HOME ${sharedDir}/stratos/data
    '';
  };

  rayforge = pkgs.symlinkJoin {
    name = "rayforge";
    paths = [ pkgs.rayforge ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rayforge \
        --set RAYFORGE_CONFIG_DIR ${sharedDir}/rayforge
    '';
  };

  orcaImportSharedPrinters = pkgs.writeShellScript "orca-import-shared-printers" ''
    conf="${config.xdg.configHome}/OrcaSlicer/OrcaSlicer.conf"
    shared="${sharedDir}/orcaslicer"
    profiles="${pkgs.orca-slicer}/share/OrcaSlicer/profiles"
    jq=${lib.getExe pkgs.jq}

    shopt -s nullglob
    entries=$(
      for preset in "$shared"/*/machine/*.json; do
        parent=$("$jq" -r '.inherits // empty' "$preset" 2> /dev/null)
        [ -n "$parent" ] || continue
        for profile in "$profiles"/*/machine/"$parent".json; do
          vendor=''${profile#"$profiles"/}
          "$jq" -c --arg vendor "''${vendor%%/*}" \
            'select(.printer_model and .printer_variant)
              | {model: .printer_model, nozzle_diameter: .printer_variant, vendor: $vendor}' \
            "$profile"
        done
      done | "$jq" -s 'unique'
    )
    [ "$entries" != "[]" ] || exit 0

    mkdir -p "$(dirname "$conf")"
    [ -s "$conf" ] || echo '{}' > "$conf"

    if ! "$jq" -e 'type == "object"' "$conf" > /dev/null 2>&1; then
      echo "orca-import-shared-printers: skipping, $conf is not a JSON object" >&2
      exit 0
    fi

    "$jq" -e --argjson entries "$entries" '($entries - (.models // [])) == []' "$conf" > /dev/null && exit 0

    tmp=$(mktemp "$conf.XXXXXX")
    trap 'rm -f "$tmp"' EXIT
    "$jq" --argjson entries "$entries" '.models = ((.models // []) + ($entries - (.models // [])))' "$conf" > "$tmp" \
      && mv "$tmp" "$conf"
  '';
in
{
  home.packages = with pkgs; [
    bcn3d-stratos
    freecad
    lycheeslicer
    orca-slicer
    rayforge
  ];

  home.activation.sharedPrintingDirs = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
    mkdir -p ${sharedDir}/orcaslicer ${sharedDir}/stratos ${sharedDir}/rayforge
  '';

  xdg.configFile."OrcaSlicer/user".source =
    config.lib.file.mkOutOfStoreSymlink "${sharedDir}/orcaslicer";
}
