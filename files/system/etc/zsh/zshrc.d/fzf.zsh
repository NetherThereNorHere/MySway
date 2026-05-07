source <(fzf --zsh)

# Set bat as the default previewer for fzf file searches
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range :500 {}'"

# Explicitly set the preview for history to just echo the command
export FZF_CTRL_R_OPTS="--preview 'echo {} | bat --color=always --style=plain --language=sh' --preview-window=down:3:wrap"

# Handy alias: 'fp' (file preview)
alias fp='fzf --preview "bat --color=always --style=header,grid --line-range :300 {}"'
