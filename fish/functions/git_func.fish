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

