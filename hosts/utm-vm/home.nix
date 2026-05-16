{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
    ../../modules/home/niri.nix
    ../../modules/home/vscode.nix
    ../../modules/home/shell.nix
  ];

  home.username = "nixos";         # byt till ditt användarnamn
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";

  # ── Noctalia Shell ────────────────────────────────────────────────────────
  programs.noctalia-shell = {
    enable = true;
    settings = {
      # Noctalia läser resten från dotfiles/noctalia/settings.json
      # Grundinställningar — anpassa efter smak
    };
  };

  # ── Alacritty (terminal) ──────────────────────────────────────────────────
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 12; y = 12; };
        decorations = "None";
      };
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 13;
      };
      colors = {
        # Enkel mörk färgpalett — Noctalia styr mest av UI:t
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
      };
    };
  };

  # ── Git ───────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName  = "Ditt Namn";      # ← byt
    userEmail = "din@email.com";  # ← byt
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # ── XDG-portalinställningar (krävs av Niri/Wayland) ──────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "*";
  };

  home.packages = with pkgs; [
    # Wayland-verktyg
    xwayland-satellite   # X11-appar i Niri
    wl-clipboard         # wl-copy / wl-paste
    grim                 # skärmdump
    slurp                # välj region för skärmdump
    fuzzel               # app-launcher (Niri:s standard)
    mako                 # notifikationer

    # Nerd Font (används av Alacritty + Noctalia)
    nerd-fonts.jetbrains-mono

    # Övriga verktyg
    btop
    unzip
  ];

  programs.home-manager.enable = true;
}
