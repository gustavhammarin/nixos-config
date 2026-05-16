{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll  = "ls -lah";
      gs  = "git status";
      gp  = "git push";
      gl  = "git pull";
      nr  = "sudo nixos-rebuild switch --flake ~/nixos-config#utm-vm";
      nfu = "nix flake update ~/nixos-config";
    };
    initExtra = ''
      # Snabb prompt
      export PS1="\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ "
    '';
  };

  # direnv — laddar .envrc automatiskt
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # fzf — fuzzy finder
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  home.packages = with pkgs; [
    bat     # bättre cat
    eza     # bättre ls
    delta   # bättre git diff
  ];
}
