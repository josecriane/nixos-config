{
  pkgs,
  lib,
  ...
}:
{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentry.package = pkgs.pinentry-qt;
  };

  # Import GPG keys from agenix secrets
  home.activation.importGpgKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
        if ! ${pkgs.gnupg}/bin/gpg --batch --quiet --import "$key_path"; then
          echo "warning: failed to import GPG key $key_name" >&2
        fi
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
      if ! ${pkgs.gnupg}/bin/gpg --batch --quiet --import-ownertrust < "/run/agenix/gpg-trust-db"; then
        echo "warning: failed to import the GPG trust database" >&2
      fi
    fi

    echo "GPG keys import completed"
  '';
}
