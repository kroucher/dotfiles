{
  enable = true;
  enableCompletion = true;
  autosuggestion =
    {
      enable = true;
    };
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
    update = "sudo nixos-rebuild switch --flake ~/.config/nixos#default";
    # nix develop with zsh
    nix-develop = "nix develop --command zsh";
  };
  history.size = 10000;
  history.path = "/home/daniel/.config/zsh/history";
  dotDir = ".config/";
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "rust" ];
    theme = "robbyrussell";
  };
  initExtra = ''
    # Save the original prompt setup
    ORIGINAL_PROMPT="$PROMPT"

    # Function to update the prompt
    update_prompt() {
      if [[ -n $IN_NIX_SHELL ]]; then
        # If inside a Nix shell, modify the prompt
        PROMPT="[] $ORIGINAL_PROMPT"
      else
        # If not in a Nix shell, use the original prompt
        PROMPT="$ORIGINAL_PROMPT"
      fi
    }

    # Call update_prompt before each command
    precmd_functions+=(update_prompt)
  '';
}

