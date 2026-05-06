eval "$(zoxide init zsh)"

alias cd="z"

# Interactive 'zi' command with eza preview
# This uses fzf to show a colored eza tree of the folder before you jump
export _ZO_FZF_OPTS="
  --no-sort --height 40% --reverse --border
  --preview 'eza --icons=always --color=always --tree --level=2 {2}'
"
