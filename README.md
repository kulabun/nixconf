# NixOS Configuration
```
# Generate new boot configuration
sudo nixos-rebuild boot --flake .#hx90

# Update current configuration
sudo nixos-rebuild switch --flake .#hx90
```

# Secrets
Checkout / copy files:
- ~/.secrets
- ~/secrets

# Tailscale
1. Go to https://login.tailscale.com/admin/settings/keys
2. Generate auth key
3. Login to tailscale
```
tailscale up -authkey <auth key>
```

# Bitwarden
```
bw config server https://bitwarden.snowy-butterfly.ts.net/
bw login konstantin.labun@gmail.com
```

# Other
```
# Setup rust tools
rustup default stable


```
