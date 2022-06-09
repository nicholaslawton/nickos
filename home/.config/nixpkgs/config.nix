# To apply this configuation:
# nickos home rebuild

{
  packageOverrides = pkgs: with pkgs; {
    %account% = pkgs.buildEnv {
      name = "%account%";
      paths = [
        sway
        foot
      ];
    };
  };
}
