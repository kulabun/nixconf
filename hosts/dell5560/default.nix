{ ... }: {
  imports = [ ./home ];

  settings = {
    user = "klabun";
    machine = "dell5560";
    secretsRootPath = "/home/klabun/secrets";
  };
}
