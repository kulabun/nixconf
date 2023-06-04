let
  fileNames = with builtins;
    map (n: ./${n}) (filter (n: n != "default.nix" && n != "README.md") (attrNames (readDir ./.)));
in
{ imports = fileNames; }
