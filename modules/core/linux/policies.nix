_: {
  programs.chromium = {
    enable = true;
    extraOpts = {
      BraveRewardsDisabled = true;
      BraveWalletDisabled = true;
      BraveVPNDisabled = true;
      BraveAIChatEnabled = false;
      BraveNewsDisabled = true;
      ExtensionInstallForcelist = [
        "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx"
      ];
    };
  };
}
