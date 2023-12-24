# To apply this configuation:
# nickos home rebuild

{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    %account% = pkgs.buildEnv {
      name = "%account%";
      paths = [
        gcc
        rustup
        helix
      ];
    };
  };
}
