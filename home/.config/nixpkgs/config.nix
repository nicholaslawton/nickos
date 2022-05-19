# To apply this configuation:
# nix-env -iA nixos.%account%

{
  packageOverrides = pkgs: with pkgs; {
    %account% = pkgs.buildEnv {
      name = "%account%";
      paths = [
        tmux
        w3m
      ];
    };
  };
}
