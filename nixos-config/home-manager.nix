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

  programs.fish.enable = true;

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
        shellAliases = {
          wget = "wget -c";
        };
        functions = {
          fish_prompt =
  ''
  # Defined in /home/marc/.config/fish/functions/fish_prompt.fish @ line 2
  # slightly modified from defaults
      set -l last_pipestatus $pipestatus
      set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
      set -l normal (set_color normal)

      # Color the prompt differently when we're root
      set -l color_cwd $fish_color_cwd
      set -l suffix '>'

      # If we're running via SSH, change the host color.
      set -l color_host $fish_color_host

      # Write pipestatus
      # If the status was carried over (e.g. after `set`), don't bold it.
      set -l bold_flag --bold
      set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
      if test $__fish_prompt_status_generation = $status_generation
          set bold_flag
      end
      set __fish_prompt_status_generation $status_generation
      set -l prompt_status (__fish_print_pipestatus "[" "]" "|" (set_color $fish_color_status) (set_color $bold_flag $fish_color_status) $last_pipestatus)

      echo -n -s (set_color $fish_color_user) "$USER" $normal (set_color $fish_color_separator) @ $normal (set_color $color_host) (prompt_hostname) $normal ' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
  end
  '';
        };
      };
    };
  };
}
