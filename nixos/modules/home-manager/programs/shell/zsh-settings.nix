{
  enable = true;
  enableCompletion = true;
  enableAutosuggestions = true;
  syntaxHighlighting.enable = true;

  plugins = [
    {
      name = "zsh-autosuggestions";
      file = "zsh-autosuggestions.plugin.zsh";
      src = builtins.fetchGit {
        url = "https://github.com/zsh-users/zsh-autosuggestions";
        rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
      };
    }
  ];
  shellAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
  };
  history.size = 10000;
  history.path = ".config/zsh/history";
  dotDir = ".config/";
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "rust" "zsh-autosuggestions" ];
    theme = "robbyrussell";
  };
}

