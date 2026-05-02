{ config, pkgs, lib, ... }:

{
  # ===== DEVICE-SPECIFIC CONFIG =====
  raph.hostType = "laptop";
  # ===== NETWORK =====
  networking.hostName = "raph-laptop";

}
