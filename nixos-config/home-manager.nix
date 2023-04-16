{ config, pkgs, ... }:

let
  user = "exu";
  hostname = "nixos";
in
{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.users.${user} = { pkgs, ... }: {
    home.stateVersion = "22.11";
    home.packages = [
      pkgs.firefox
      pkgs.kitty
      pkgs.wget
    ];
  };
}
