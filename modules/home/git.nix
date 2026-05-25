{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "F";
      user.email = "vladislavtkachuk@yahoo.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
