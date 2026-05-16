{ pkgs, ... }:

{
  # Aktiverar Niri som display manager-alternativ
  programs.niri = {
    enable = true;
  };

  # GDM som login manager (visar Niri i sessionsmenyn)
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Polkit (krävs av Niri för privilegierade operationer)
  security.polkit.enable = true;

  # Ljud via PipeWire (rekommenderat för Wayland)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Keyring (för lösenordslagring, SSH-nycklar m.m.)
  services.gnome.gnome-keyring.enable = true;

  # XDG-portaler (skärmdelnig, filväljare etc.)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # Miljövariabler för Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";    # VSCode/Electron Wayland-stöd
    MOZ_ENABLE_WAYLAND = "1"; # Firefox
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };
}
