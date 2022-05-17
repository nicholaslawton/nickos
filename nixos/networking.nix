{
  hostName = "nickos";
  wireless.enable = true;
  wireless.networks = {
    %ssid% = {
      psk = "%psk%";
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  useDHCP = false;
  interfaces.%ifname%.useDHCP = true;
}
