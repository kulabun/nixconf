{ pkgs, jetbrains-pkgs, lib, ... }:
let
  plugins = jetbrains-pkgs.jetbrains.plugins;

  fetchPluginSrc = { url, hash, ... }:
    let
      isJar = lib.hasSuffix ".jar" url;
      fetcher = if isJar then pkgs.fetchurl else pkgs.fetchzip;
    in
    fetcher {
      executable = isJar;
      inherit url hash;
    };

  copilotInfo = rec {
    name = "github-copilot-intellij";
    id = 17718;
    updateId = 313933;
    version = "1.2.5.2507";
    url = "https://plugins.jetbrains.com/files/${toString id}/${toString updateId}/${name}-${version}.zip";
    hash = "sha256-AZ8qKwI2OGBVd/0ulFAElm+Al9N3Ea5MGm+cMPAYHn4=";
    special = true;
  };

  copilot-plugin =
    pkgs.stdenv.mkDerivation (copilotInfo // {
      src = (fetchPluginSrc copilotInfo);
      installPhase = "mkdir $out && cp -r . $out";
      # hash = "";
      inputs = [ pkgs.patchelf pkgs.glibc pkgs.gcc-unwrapped ];
      patchPhase =
        let libPath = lib.makeLibraryPath [ pkgs.glibc pkgs.gcc-unwrapped ]; in
        ''
          agent="copilot-agent/bin/copilot-agent-linux"
          orig_size=$(stat --printf=%s $agent)
          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $agent
          patchelf --set-rpath ${libPath} $agent
          chmod +x $agent
          new_size=$(stat --printf=%s $agent)
          # https://github.com/NixOS/nixpkgs/pull/48193/files#diff-329ce6280c48eac47275b02077a2fc62R25
          ###### zeit-pkg fixing starts here.
          # we're replacing plaintext js code that looks like
          # PAYLOAD_POSITION = '1234                  ' | 0
          # [...]
          # PRELUDE_POSITION = '1234                  ' | 0
          # ^-----20-chars-----^^------22-chars------^
          # ^-- grep points here
          #
          # var_* are as described above
          # shift_by seems to be safe so long as all patchelf adjustments occur 
          # before any locations pointed to by hardcoded offsets
          var_skip=20
          var_select=22
          shift_by=$(expr $new_size - $orig_size)
          function fix_offset {
            # $1 = name of variable to adjust
            location=$(grep -obUam1 "$1" $agent | cut -d: -f1)
            location=$(expr $location + $var_skip)
            value=$(dd if=$agent iflag=count_bytes,skip_bytes skip=$location \
             bs=1 count=$var_select status=none)
            value=$(expr $shift_by + $value)
            echo -n $value | dd of=$agent bs=1 seek=$location conv=notrunc
          }
          fix_offset PAYLOAD_POSITION
          fix_offset PRELUDE_POSITION
        '';
    });
in
copilot-plugin
