{ pkgs, ... }:
{
  programs.wofi = {
    enable = true;
    style = ''
      window {
          margin: 0px;
          border: 2px solid #efefef;
          border-radius: 12px;
          background-color: rgba(0, 0, 0, 0.67);
          font-family: "NotoSans Nerd Font";
          font-size: 18px;
      }

      #input {
          margin: 5px;
          border: none;
          color: #f8f8f2;
          background-color: rgba(44, 44, 44, 0.5);
      }

      #inner-box {
          margin: 5px;
          border: none;
          background-color: transparent;
      }

      #outer-box {
          margin: 5px;
          border: none;
          background-color: transparent;
      }

      #text {
          margin: 5px;
          border: none;
          color: #f8f8f2;
      }

      #entry:selected {
          background-color: rgba(69, 69, 69, 0.7);
          border-radius: 6px;
      }
    '';
    settings = {
      mode = "drun";
      height = 540;
      width = 960;
      allow_images = true;
      allow_markup = true;
      parse_search = true;
      no_actions = true;
    };
  };

  home.packages = with pkgs; [
    wofi-emoji
    wofi-pass
  ];
}
