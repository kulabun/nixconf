self: super:

let inherit (self) callPackage;
in {
  dracula-rofi-theme = callPackage (import ./dracula-rofi-theme.nix) { };
  rofi-wayland-vpn = self.rofi-vpn.overrideAttrs (new: old: {
    installPhase = ''
      runHook preInstall
      install -D --target-directory=$out/bin/ ./rofi-vpn
      wrapProgram $out/bin/rofi-vpn \
        --prefix PATH ":" ${
          self.lib.makeBinPath [ self.rofi-wayland self.networkmanager ]
        }
      runHook postInstall
    '';
  });
  # rustc = super.rustc.overrideAttrs (attrs: {
  #   postInstall = ''
  #     RUST_SRC_PATH=$out/lib/rustlib/src/rust
  #     mkdir -p $(dirname $RUST_SRC_PATH)
  #     ln -sf ${super.rust.packages.stable.rustPlatform.rustcSrc} $RUST_SRC_PATH
  #   '';
  # });
}
