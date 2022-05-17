{
  users.%account% = {
    isNormalUser = true;
    home = "/home/%account%";
    description = "%name%";
    extraGroups = [ "wheel" ];
  }
}
