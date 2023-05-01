{ config, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = (builtins.readFile ./config/fish/conf.d/interactive.fish);
    shellAliases = {
      wget = "wget -c";
    };
    functions = {
      fish_prompt = (builtins.readFile ./config/fish/functions/fish_prompt.fish);
    };
  };
}
