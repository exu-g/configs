{ config, pkgs, ... }:

let
  user = "exu";
  hostname = "nixos";
in
{
  imports = [
    <home-manager/nixos>
  ];

  # root home
  home-manager.users.root = { pkgs, ... }: {
    home.username = "root";
    home.homeDirectory = "/root";
    home.stateVersion = "22.11";

    programs = {
      fish = {
        enable = true;
        interactiveShellInit = (builtins.readFile ./config/fish/conf.d/interactive.fish);
        shellAliases = {
          wget = "wget -c";
        };
        functions = {
          fish_prompt = (builtins.readFile ./config/fish/functions/fish_prompt.fish);
        };
      };
    };
  };

  # keep everything using home manager within this block
  home-manager.users.${user} = { pkgs, ... }: {
    home.username = "${user}";
    home.homeDirectory = "/home/${user}";
    home.stateVersion = "22.11";
    home.packages = with pkgs; [
      firefox # browser
      kitty # terminal
      pciutils # lspci command
      git # git
      emacs # emacs editor
      emacsPackages.doom # doom emacs configuration
      acpilight # controlling laptop monitor backlight
      networkmanagerapplet # network configuration
      wofi # app launcher (wayland replacement for rofi)
      freetype # font rendering and configuration
      fira # fira sans font
      fira-code # fira code font
      fish # fish shell
    ];

    programs = {
      fish = {
        enable = true;
        interactiveShellInit = (builtins.readFile ./config/fish/conf.d/interactive.fish);
        shellAliases = {
          wget = "wget -c";
        };
        functions = {
          fish_prompt = (builtins.readFile ./config/fish/functions/fish_prompt.fish);
        };
      };
    };
  };
}
