source <(fzf --zsh)

# Set bat as the default previewer for fzf file searches
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range :500 {}'"

# Handy alias: 'fp' (file preview)
alias fp='fzf --preview "bat --color=always --style=header,grid --line-range :300 {}"'
