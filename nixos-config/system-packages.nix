{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #vim # an editor
    neovim # text editor
    fwupd # firmware updates
    fwupd-efi # firmware updates additional EFI stuff
    wget # get stuff from the net
    #hyprland # window manager
    wayland # wayland server
    xdg-utils # xdg directories, open, etc
    sweet # gtk theme
    capitaine-cursors # cursor theme
    tumbler # image files thumbnail generator (+ base requirement)
    ffmpegthumbnailer # video files thumbnail generator
  ];

}
