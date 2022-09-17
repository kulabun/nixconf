# NixOS and Home-Manager configuration files
```
NIX_PROFILE=hx90
home-manager switch --flake "/home/$USER/nixconf#$NIX_PROFILE" --extra-experimental-features "nix-command flakes" 
```
