{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hello
  ];
}
