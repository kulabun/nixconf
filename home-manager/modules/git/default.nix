{ config, pkgs, lib, ... }: {
  programs.scmpuff = {
    enable = true;
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Konstantin Labun";
    userEmail = "konstantin.labun@gmail.com";
    ignores = [ ".zsh_history" ];
    includes = [{ path = "~/.gitconfig.local"; }];
    delta = {
      enable = true;
      options = {
        syntax-theme = "Dracula";
        side-by-side = true;
        line-numbers = true;
        navigate = true;
      };
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull = {
        rebase = true;
        ff = "only";
      };
      core.editor = "nvim";
      color.ui = "auto";
    };
    aliases = {
      "a" = "add";
      "aa" = "add --all";
      "s" = "status -sb";
      "c" = "commit";
      "ca" = "commit --all";
      "cr" = "!git add -u && git dc && read && git commit -m";
      "l" =
        "log --color --graph --pretty=format:'%C(bold green)%h%Creset [%G?]-%C(yellow)%d%Creset %C(bold)%s%Creset | %C(green)%an%Creset, %C(blue)%ar%Creset'";
      "ll" =
        "log --color --graph --pretty=format:'%C(bold green)%h%Creset [%G?]-%C(yellow)%d%Creset %C(bold)%s%Creset | %C(green)%an%Creset, %C(blue)%ar%Creset' --numstat";
      "b" = "branch"; # Local branches
      "br" = "branch -r"; # Remote branches
      "cp" = "cherry-pick";
      "o" = "checkout";
      "ob" = "checkout -b"; # Create branch if required
      "d" = "diff";
      "dc" = "diff --cached"; # Review staged files
      "f" = "fetch";
      "r" = "remote";
      "w" = "whatchanged";
      # Find branches containing commit
      "fb" = "!f() { git branch -a --contains $1; }; f";
      # Find tags containing commit
      "ft" = "!f() { git describe --always --contains $1; }; f";
      # Find commit by message
      "fcm" = ''
        !f() { git log --oneline --pretty=format:'%C(bold green)%h%Creset [%G?]-%C(yellow)%d%Creset %C(bold)%s%Creset | %C(green)%an%Creset, %C(blue)%ar%Creset' | fzf -q "$1" | cut -d" " -f1; };f'';
      # Undo last commit
      "undo" = "reset HEAD^ --soft";
      "u" = "undo";

      "snapshot" =
        ''!git stash push "snapshot: $(date)" && git stash apply "stash@{0}"'';
      "save" = "stash push";
      "pop" = "stash pop";
      "apply" = "stash apply";
      "list" = "stash list";

      # Append changes to last commit
      "append" = "commit -a --amend --no-edit";
      "amend" = "commit -a --amend";
      # Get the current branch name (not so useful in itself, but used in other aliases)
      "branch-name" = "!git rev-parse --abbrev-ref HEAD";

      # Remove files from stage
      "unstage" = "reset HEAD --";
      # Reset files
      "discard" = "checkout --";
      # Fire up your difftool with all the changes that
      # are on the current branch.
      "review" = "difftool origin/master...";

      # Grep over current state
      "g" = "grep --break --heading --line-number";
      # Greap over all files ever commited (grep history)
      "gh" = ''
        !f() { git rev-list --all | xargs git grep --break --heading --line-number "$1"; };f'';

      # Push the current branch to the remote "origin", and set it to track
      # the upstream branch
      "publish" = "!git push -u origin $(git branch-name)";
      "unpublish" = "!git push origin :$(git branch-name)";

      # The extra '&& :' is needed: https://stackoverflow.com/a/25915221
      "sync" =
        "!git fetch --all --prune && git rebase --rebase-merges --autostash $1 && :";
      "sync-recursive" =
        "!git fetch --all --prune && git submodule update --init --recursive && git rebase --rebase-merges --autostash $1 && :";

      # Mark a file as "assume unchanged", which means that Git will treat it
      # as though there are no changes to it even if there are. Useful for
      # temporary changes to tracked files
      "assume" = "update-index --assume-unchanged";
      "unassume" = "update-index --no-assume-unchanged";
      "assumed" = "!git ls-files -v | grep ^h | cut -c 3-";

      # Checkout our version of a file and add it
      "ours" = "!f() { git checkout --ours $@ && git add $@; }; f";
      # Checkout their version of a file and add it
      "theirs" = "!f() { git checkout --theirs $@ && git add $@; }; f";

      # Delete any branches that have been merged into master
      # See also: https://gist.github.com/robmiller/5133264
      "delete-merged-branches" = ''
        !f() { git checkout ''${1-master} && git branch --merged ''${1-master} | grep -v "''${1-master}$" | xargs git branch -d; };f'';
      "ignore" = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi";
      "contributors" = "shortlog --summary --numbered";
    };
  };
}
