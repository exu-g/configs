{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # an editor
    fwupd # firmware updates
    fwupd-efi # firmware updates additional EFI stuff
    wget # get stuff from the net
    #hyprland # window manager
    wayland # wayland server
    xdg-utils # xdg directories, open, etc
  ];

}
