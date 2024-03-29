# NickOS

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nushell
    vim
    git
    tmux
    w3m
    sway
    foot
    dmenu
    qutebrowser
    gitkraken
    xdg-utils
  ];

  # sway requires polkit to work - without polikit, sway will report permission errors about seats and logind and stuff...
  security.polkit.enable = true;

  hardware.opengl.enable = true;

  xdg.mime.defaultApplications = {
    "text/html" = "qutebrowser.desktop";
    "x-scheme-handler/http" = "qutebrowser.desktop";
    "x-scheme-handler/https" = "qutebrowser.desktop";
    "x-scheme-handler/about" = "qutebrowser.desktop";
    "x-scheme-handler/unknown" = "qutebrowser.desktop";
  };

  fonts = {
    fonts = with pkgs; [
      iosevka
    ];

    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        monospace = ["iosevka"];
      };
    };
  };

  time.timeZone = "Australia/Melbourne";

  sound.enable = true;

  networking = import ./networking.nix;

  users = import ./users.nix pkgs;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
