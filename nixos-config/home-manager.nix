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
    home.packages = with pkgs; [
      kitty # terminfo support
    ];

    imports = [
      ./home-manager/hyprland.nix
      ./home-manager/fish.nix
    ];

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
      libnotify # notifications
      mako # notification daemon
      xdg-desktop-portal-hyprland # desktop portal (hyprland fork)
    ];

    imports = [
      ./home-manager/hyprland.nix
      ./home-manager/fish.nix
    ];

    systemd.user.services = {
      service-name = {
        Unit = {
          Description = "SSH key agent";
        };
        Service = {
          Type = "simple";
          Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
          ExecStart = "/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };

  services.mako.enable = true;
  };
}
