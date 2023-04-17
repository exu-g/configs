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
      pkgs.emacsPackages.doom # doom emacs
      pkgs.acpilight # controlling laptop monitor backlight
      pkgs.networkmanagerapplet # network configuration
      pkgs.wofi # app launcher (wayland replacement for rofi)
      pkgs.freetype # font rendering and configuration
      pkgs.fira # fira sans font
      pkgs.fira-code # fira code font
      pkgs.fwupd # firmware updates
      pkgs.fwupd-efi # firmware updates additional EFI stuff
    ];
  };

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        wget = "wget -c";
      };
    };
  };
}
