let
  # public keys
  konstantin_age_04_2023 = "age13fjgxvdn5hhcvl8jwz9ysvc2hr66k6x63uf7z98pm906tpgg4qtq9n559p";
in
{
  "ssh/github.age".publicKeys = [ konstantin_age_04_2023 ];
}
