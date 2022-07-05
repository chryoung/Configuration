function __git_prompt_git
  GIT_OPTIONAL_LOCKS=0 command git $argv
end

function git_current_branch
  set -l ref (__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
  set -l ret $status
  if test $ret -ne 0
    test $ret -eq 128; and return # not a git repo.
    set -l ref (__git_prompt_git rev-parse --short HEAD 2> /dev/null); or return
  end
  echo (string replace "refs/heads/" "" $ref)
end

alias gst "git status"
alias ga "git add"
alias gaa "git add -A"
alias gau "git add -u"
alias gb "git branch"
alias gco "git checkout"
alias gsw "git switch"
alias gre "git restore"
alias glg "git log --stat"
alias glgg "git log --graph"
alias glog "git log --oneline --decorate --graph"
alias gcmsg "git commit -m"
alias gp "git push"
alias gl "git pull --prune"
alias gf "git fetch"
alias gfa "git fetch --all --prune"
alias gpsup "git push -u origin (git_current_branch)"
