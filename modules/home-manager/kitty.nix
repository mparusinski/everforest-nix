{ config, lib, ... }:

let
  cfg = config.everforest.kitty;
in

{
  # options.everforest.kitty = everforestLib.mkEverforestOption { name = "kitty"; };

  # imports = everforestLib.mkRenamedEverforestOptions {
  #   from = [
  #     "programs"
  #     "kitty"
  #     "catppuccin"
  #   ];
  #   to = "kitty";
  # };

  options.everforest.kitty = {
    enable = lib.mkEnableOption "Enable Everforest configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      # themeFile = "Catppuccin-${lib.toSentenceCase cfg.flavor}";
      themeFile = "everforest_dark_hard.conf";
    };
  };
}

