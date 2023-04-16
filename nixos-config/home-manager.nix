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
      pkgs.firefox # browser
      pkgs.kitty # terminal
      pkgs.pciutils # lspci command
      pkgs.git # git
    ];
  };
}
