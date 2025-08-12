{ config, pkgs, lib, ... }:
{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  # Import GPG keys from agenix secrets
  home.activation.importGpgKeys = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create GPG home directory if it doesn't exist
    export GNUPGHOME="$HOME/.gnupg"
    mkdir -p "$GNUPGHOME"
    chmod 700 "$GNUPGHOME"

    # Function to import a key
    import_gpg_key() {
      local key_path="$1"
      local key_name="$2"
      
      if [ -f "$key_path" ]; then
        echo "Importing GPG key: $key_name"
        ${pkgs.gnupg}/bin/gpg --batch --import "$key_path" 2>/dev/null || true
      fi
    }

    # Import all keys
    import_gpg_key "/run/agenix/gpg-nomasystems" "Nomasystems"
    import_gpg_key "/run/agenix/gpg-jose-cribeiro" "Jose Cribeiro"
    import_gpg_key "/run/agenix/gpg-jose-cribeiro-subkeys" "Jose Cribeiro Subkeys"
    import_gpg_key "/run/agenix/gpg-inditex" "Inditex"
    import_gpg_key "/run/agenix/gpg-inditex-subkeys" "Inditex Subkeys"
    import_gpg_key "/run/agenix/gpg-gmail" "Gmail"

    # Import trust database
    if [ -f "/run/agenix/gpg-trust-db" ]; then
      echo "Importing GPG trust database"
      ${pkgs.gnupg}/bin/gpg --import-ownertrust < "/run/agenix/gpg-trust-db" 2>/dev/null || true
    fi

    echo "GPG keys import completed"
  '';
}
