{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix   # genereras med nixos-generate-config
    ../../modules/system/niri.nix
    ../../modules/system/fonts.nix
  ];

  # ── Bootloader ────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Hostname ──────────────────────────────────────────────────────────────
  networking.hostName = "utm-vm";
  networking.networkmanager.enable = true;

  # ── Tidszon — ändra till din ──────────────────────────────────────────────
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "sv_SE.UTF-8";

  # ── Rosetta (x86_64 via Apple Virtualization-backend) ────────────────────
  # Aktivera "Enable Rosetta on Linux" i UTM:s inställningar först!
  virtualisation.rosetta.enable = true;

  # ── SSH ───────────────────────────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true; # byt till false + SSH-nyckel när du är klar
  };

  # ── Avahi (.local hostname) ───────────────────────────────────────────────
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  # ── OpenGL (krävs av Niri + Alacritty) ───────────────────────────────────
  hardware.graphics.enable = true;

  # ── QEMU-gästtjänster (klippbord, tidssynk) ──────────────────────────────
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # ── Flakes & nix-command ──────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "nixos" ];
  };

  # ── Användare — byt "nixos" till ditt namn ────────────────────────────────
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    initialPassword = "nixos"; # byt direkt efter första login
  };

  # ── Globala systempaket ───────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    neofetch
    ripgrep
    fd
    jq
  ];

  system.stateVersion = "25.05";
}
