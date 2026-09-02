{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    newman
    postman
  ];
}
