{ config, lib, pkgs', user, inputs, ... }:
with lib;
let
  cfg = config.programs'.vscode;

  extensions = [
    "christian-kohler.path-intellisense"
    "eamodio.gitlens"
    "esbenp.prettier-vscode"
    # "GitHub.copilot"
    "GitHub.github-vscode-theme"
    "golang.go"
    "hashicorp.terraform"
    "haskell.haskell"
    "jnoortheen.nix-ide"
    "ms-azuretools.vscode-docker"
    "ms-python.python"
    "ms-vscode-remote.remote-containers"
    "redhat.vscode-yaml"
    "rust-lang.rust-analyzer"
    "VisualStudioExptTeam.intellicode-api-usage-examples"
    "VisualStudioExptTeam.vscodeintellicode"
    "vscjava.vscode-gradle"
    "vscjava.vscode-java-pack"
    "vscjava.vscode-spring-initializr"
    "vscodevim.vim"
    "sourcegraph.cody-ai"
    "sourcegraph.sourcegraph"
  ];
  installExtensionCmd = extension: "${pkgs'.vscode}/bin/code --install-extension '${extension}' || true";
  installExtensionsScript = builtins.concatStringsSep "\n" (map installExtensionCmd extensions);
in
{
  options.programs'.vscode.enable = mkEnableOption "Visual Studio Code";

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    home-manager.users.${user} = {
      programs.vscode = {
        enable = true;
        package = pkgs'.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
      };

      home.activation.vscode-configure = inputs.home-manager.lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        _() {
          ${installExtensionsScript}

          SETTINGS_PATH="''$HOME/.config/Code/User/settings.json"
          NIX_SETTINGS_PATH=${builtins.toString ./config/settings.json}
          if [ -e "''$SETTINGS_PATH" ]; then
            cat ''$NIX_SETTINGS_PATH ''$SETTINGS_PATH | grep -v "//" | ${pkgs'.jq}/bin/jq -s add
          else
            mkdir -p ''${SETTINGS_PATH%/*}
            cat ''$NIX_SETTINGS_PATH | grep -v "//" > ''$SETTINGS_PATH 
          fi
        } && _
        unset -f _
      '';
    };
  };
}
