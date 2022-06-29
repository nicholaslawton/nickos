# To apply this configuation:
# nickos home rebuild

{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    %account% = pkgs.buildEnv {
      name = "%account%";
      paths = [
        sway
        foot
        qutebrowser
        gitkraken
        firefox
      ];
    };
  };

  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/html" = "qutebrowser.desktop";
    "x-scheme-handler/http" = "qutebrowser.desktop";
    "x-scheme-handler/https" = "qutebrowser.desktop";
    "x-scheme-handler/about" = "qutebrowser.desktop";
    "x-scheme-handler/unknown" = "qutebrowser.desktop";
  };
  #environment.sessionsVariables.DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
}
