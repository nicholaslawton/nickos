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
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };
  environment.sessionsVariables.DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
}
