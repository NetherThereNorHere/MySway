# Initialize completion system
autoload -Uz compinit && compinit

# Use a menu for completions and allow selection with arrow keys
zstyle ':completion:*' menu select

# Group results by category (Files, Directories, Commands, etc.)
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Use LS_COLORS for the completion menu (requires the 'eza' or 'ls' colors)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Smart Case Matching: match 'desc' to 'Desktop', 'DOC' to 'Documents'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'

# Only show the menu if there are at least 2 options
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Auto-complete options for 'cd' more intelligently
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
