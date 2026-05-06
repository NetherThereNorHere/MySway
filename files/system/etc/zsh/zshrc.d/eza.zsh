# Replace standard ls with eza for a modern look
alias ls='eza --icons=always --color=always --group-directories-first'

# Common list view: Long format with headers and human-readable sizes
alias ll='eza -l --icons=always --header --group-directories-first'

# All files: includes hidden files (dotfiles)
alias la='eza -la --icons=always --header --group-directories-first'

# Git-aware view: shows file status (modified, new, etc.) in the long list
alias lg='eza -l --icons=always --git --header'

# Tree view: replaces the 'tree' command
alias tree='eza --tree --icons=always'

# Sync the Zsh completion menu colors with system defaults
export LS_COLORS="$(dircolors -b)"
