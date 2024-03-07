{
  enable = true;
  enableCompletion = true;
  enableAutosuggestions = true;
  syntaxHighlighting.enable = true;


  shellAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
  };
  history.size = 10000;
  history.path = ".config/zsh/history";
  dotDir = ".config/";
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "robbyrussell";
  };
}

