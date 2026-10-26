_: {
  programs.zsh.shellAliases = {
    cdev = "_rcd dev";
    cdocs = "_rcd docs";
    cdl = "_rcd libs";
    cdtmp = "_rcd tmp";
    cdh = "_rcd .";
    cp = "cp -r";
    cdnix = "cd ~/nixos-config";
    noma-vpn-on = "sudo systemctl start openvpn-noma";
    noma-vpn-off = "sudo systemctl stop openvpn-noma";
    noma-vpn-status = "sudo systemctl status openvpn-noma";
  };

  programs.zsh.initContent = ''
    _rcd() {
      local base_dir="''${1:-dev}"
      local sub_dir="''${2}"

      if [ "$base_dir" = "." ]; then
        if [ -z "$sub_dir" ]; then
          cd ~
        else
          cd ~/"$sub_dir"
        fi
      else
        if [ -z "$sub_dir" ]; then
          cd ~/"$base_dir"
        else
          cd ~/"$base_dir"/"$sub_dir"
        fi
      fi
    }
  '';
}
