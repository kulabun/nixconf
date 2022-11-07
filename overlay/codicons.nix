{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "font-vscode-codicons";
  src = fetchFromGitHub rec {
    owner = "microsoft";
    repo = "vscode-codicons";
    rev = "3270c91e2d94312863b33adffb09d37892f3b57f";
    sha256 = "0cf1xhp47gipl2zxni662vf4bgk708x4drc64z2366mwp5w0rri8";
  };

  installPhase = ''
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;
    mv $out/share/fonts/truetype/codicon.ttf $out/share/fonts/truetype/codicons.ttf
  '';

  meta = with lib; {
    description = "VSCode Codicons - TTF font";
    longDescription = ''
      VSCode Icons as a TTF font.
    '';
    homepage = "https://github.com/microsoft/vscode-codicons";
    license = licenses.cc-by-40;
    platforms = platforms.all;
    maintainers = with maintainers; [kulabun];
  };
}
