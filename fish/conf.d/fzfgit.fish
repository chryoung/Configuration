function fgsw
    command git switch (command git branch | fzf | sed 's/^\*\?[[:space:]]\+//')
end

function fgco
    command git checkout (command git branch | fzf | sed 's/^\*\?[[:space:]]\+//')
end

function fglog
    command git log --oneline --decorate --graph (command git branch | fzf | sed 's/^\*\?[[:space:]]\+//')
end

function fglg
    command git log --stat (command git branch | fzf | sed 's/^\*\?[[:space:]]\+//')
end
