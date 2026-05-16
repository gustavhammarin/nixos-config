{ config, pkgs, ... }:

{
  # Niri konfigureras via config.kdl
  # Home Manager placerar den på rätt ställe automatiskt
  xdg.configFile."niri/config.kdl".source = ../../dotfiles/niri/config.kdl;
}
