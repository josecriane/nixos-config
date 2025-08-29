{ pkgs, ... }:
{
  stylix = {
    # Style preview: https://dt.iki.fi/base16-previews
    # Style schemes: https://github.com/tinted-theming/schemes
    # Base16 Doc: https://github.com/chriskempson/base16/blob/main/styling.md

    base16Scheme = {
      base00 = "#303446";
      base01 = "#292c3c";
      base02 = "#414559";
      base03 = "#51576d";
      base04 = "#626880";
      base05 = "#c6d0f5";
      base06 = "#f2d5cf";
      base07 = "#babbf1";
      base08 = "#e78284";
      base09 = "#ef9f76";
      base0A = "#e5c890";
      base0B = "#a6d189";
      base0C = "#81c0c8";
      base0D = "#8caaee";
      base0E = "#a57fbd";
      base0F = "#ca9ee6";
    };

    polarity = "dark";

    opacity = {
      terminal = 0.95;
    };
  };
}
