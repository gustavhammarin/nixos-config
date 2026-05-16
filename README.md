# nixos-config

NixOS-konfiguration för UTM på Apple Silicon (M1/M2/M3).
**Stack:** Niri · Noctalia Shell · VSCode · Flakes + Home Manager

## Struktur

```
nixos-config/
├── flake.nix                     # Inputs och outputs
├── hosts/
│   └── utm-vm/
│       ├── configuration.nix     # System-konfiguration
│       ├── hardware-configuration.nix  # Genereras på plats
│       └── home.nix              # Home Manager
├── modules/
│   ├── system/
│   │   ├── niri.nix              # Niri + GDM + PipeWire
│   │   └── fonts.nix             # Typsnitt
│   └── home/
│       ├── niri.nix              # Niri config.kdl
│       ├── vscode.nix            # VSCode + extensions
│       └── shell.nix             # Bash + direnv + verktyg
└── dotfiles/
    └── niri/
        └── config.kdl            # Niri-keybinds och layout
```

## Första gången — installation i UTM

### 1. Förbered UTM

- Skapa ny VM: **Virtualize** → Linux → aarch64 NixOS ISO
- Aktivera **Rosetta**: Settings → Virtualization → "Enable Rosetta on Linux"
- Ge VM minst halva dina kärnor och hälften av RAM

### 2. Installera NixOS

Starta från ISO och kör i terminalen:

```bash
# Bli root
sudo -i

# Partitionera disk (anpassa /dev/vda vid behov)
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart primary 512MB 100%
parted /dev/vda -- mkpart ESP fat32 1MB 512MB
parted /dev/vda -- set 2 esp on

mkfs.ext4 -L nixos /dev/vda1
mkfs.fat -F 32 -n boot /dev/vda2

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# Generera hårdvarukonfiguration
nixos-generate-config --root /mnt

# Installera ett grundsystem (för att kunna klona repo)
nixos-install
reboot
```

### 3. Klona och deploya detta repo

Efter omstart, logga in och kör:

```bash
# Aktivera flakes temporärt
nix-shell -p git

# Klona repot
git clone https://github.com/DITT-ANVÄNDARNAMN/nixos-config ~/nixos-config
cd ~/nixos-config

# Kopiera in den genererade hardware-configuration.nix
sudo cp /etc/nixos/hardware-configuration.nix hosts/utm-vm/

# !! Redigera hosts/utm-vm/configuration.nix:
#    - Byt "nixos" till ditt användarnamn
#    - Kontrollera tidszon
# !! Redigera hosts/utm-vm/home.nix:
#    - Byt namn och e-post i git-konfigurationen

# Bygg och aktivera
sudo nixos-rebuild switch --flake ~/nixos-config#utm-vm
```

### 4. Uppdatera lösenord

```bash
passwd  # sätt ett riktigt lösenord
```

## Daglig användning

```bash
# Rebuilda efter ändringar
sudo nixos-rebuild switch --flake ~/nixos-config#utm-vm

# Uppdatera alla inputs (nixpkgs, noctalia etc.)
nix flake update ~/nixos-config

# Snabbkommando (alias inbyggt i shell.nix)
nr   # = sudo nixos-rebuild switch --flake ~/nixos-config#utm-vm
nfu  # = nix flake update ~/nixos-config
```

## Niri-keybinds (de viktigaste)

| Kombination | Åtgärd |
|---|---|
| `Super+Return` | Öppna Alacritty |
| `Super+D` | App-launcher (fuzzel) |
| `Super+Q` | Stäng fönster |
| `Super+H/L` | Fokus vänster/höger |
| `Super+Shift+H/L` | Flytta kolumn |
| `Super+F` | Maximera kolumn |
| `Super+1-4` | Byt arbetsyta |
| `Super+Shift+E` | Avsluta Niri |
| `Print` | Skärmdump (välj region) |

## Anpassa

- **Niri layout/keybinds:** `dotfiles/niri/config.kdl`
- **VSCode extensions/inställningar:** `modules/home/vscode.nix`
- **Systempaket:** `hosts/utm-vm/configuration.nix`
- **Användarpaket:** `hosts/utm-vm/home.nix`
