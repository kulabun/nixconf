self: super: {
  # rustc = super.rustc.overrideAttrs (attrs: {
  #   postInstall = ''
  #     RUST_SRC_PATH=$out/lib/rustlib/src/rust
  #     mkdir -p $(dirname $RUST_SRC_PATH)
  #     ln -sf ${super.rust.packages.stable.rustPlatform.rustcSrc} $RUST_SRC_PATH
  #   '';
  # });
}
