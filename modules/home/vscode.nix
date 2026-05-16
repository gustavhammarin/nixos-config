{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;   # byt till pkgs.vscodium om du föredrar det

    extensions = with pkgs.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide
      mkhl.direnv

      # Git
      eamodio.gitlens
      mhutchie.git-graph

      # Allmänt
      vscodevim.vim               # ta bort om du inte vill ha vim-keybinds
      esbenp.prettier-vscode
      usernamehw.errorlens
      gruntfuggly.todo-tree
      pkief.material-icon-theme

      # Tema — Catppuccin passar bra med Noctalia
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];

    userSettings = {
      # Wayland-stöd (viktigt i Niri!)
      "window.titleBarStyle" = "custom";

      # Utseende
      "workbench.colorTheme"   = "Catppuccin Mocha";
      "workbench.iconTheme"    = "catppuccin-mocha";
      "editor.fontFamily"      = "'JetBrainsMono Nerd Font', monospace";
      "editor.fontSize"        = 14;
      "editor.fontLigatures"   = true;
      "editor.lineHeight"      = 1.6;
      "editor.cursorBlinking"  = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.formatOnSave"    = true;
      "editor.minimap.enabled" = false;

      # Terminal
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
      "terminal.integrated.fontSize"   = 13;

      # Nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath"           = "nil";
      "nix.serverSettings".nil.formatting.command = [ "nixfmt" ];

      # Övrigt
      "telemetry.telemetryLevel" = "off";
      "files.autoSave"           = "onFocusChange";
      "explorer.confirmDelete"   = false;
      "breadcrumbs.enabled"      = true;
    };
  };

  # nil (Nix LSP) och nixfmt tillgängliga i PATH
  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
  ];
}
