self: super:
let
  inherit (self) callPackage;
in
{
  dracula-rofi-theme = callPackage (import ./dracula-rofi-theme.nix) { };
  rofi-wayland-vpn = self.rofi-vpn.overrideAttrs (new: old: {
    installPhase = ''
      runHook preInstall
      install -D --target-directory=$out/bin/ ./rofi-vpn
      wrapProgram $out/bin/rofi-vpn \
        --prefix PATH ":" ${
        self.lib.makeBinPath [self.rofi-wayland self.networkmanager]
      }
      runHook postInstall
    '';
  });

  xwayland = super.xwayland.overrideAttrs (old: {
    patches =
      (old.patches or [ ])
      ++ [
        ./patches/xwayland-vsync.patch
        ./patches/xwayland-hidpi.patch
      ];
  });

  wlroots = super.wlroots.overrideAttrs (old: {
    patches =
      (old.patches or [ ])
      ++ [
        ./patches/wlroots-hidpi.patch
      ];
  });

    # font-vscode-codicons = callPackage (import ./codicons.nix) {};

    #jetbrains.idea-community = super.jetbrains.idea-community.overrideAttrs (old: rec {
    #  version = "2022.2.3";
    #  src = super.lib.fetchurl {
    #    url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
    #    sha256 = "1vglidfy7vz85l480c40v79qd013w850iblz16sqvma8mnpzm9ab";
    #  };
    #});

    # rustc = super.rustc.overrideAttrs (attrs: {
    #   postInstall = ''
    #     RUST_SRC_PATH=$out/lib/rustlib/src/rust
    #     mkdir -p $(dirname $RUST_SRC_PATH)
    #     ln -sf ${super.rust.packages.stable.rustPlatform.rustcSrc} $RUST_SRC_PATH
    #   '';
    # });
    }
