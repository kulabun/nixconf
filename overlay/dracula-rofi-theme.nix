{ stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "dracula-rofi-theme";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "rofi";
    rev = "090a990c8dc306e100e73cece82dc761f3f0130c";
    sha256 = "1p12wr2316g0j5d3jmzazbaag4mp9j5kgwnxn0lr3djafzg0kamd";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    mv theme $out/
    runHook postInstall
  '';
}
