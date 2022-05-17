pkgs:

{
  users.%account% = {
    isNormalUser = true;
    home = "/home/%account%";
    shell = pkgs.nushell;
    description = "%name%";
    extraGroups = [ "wheel" ];
  };
}
