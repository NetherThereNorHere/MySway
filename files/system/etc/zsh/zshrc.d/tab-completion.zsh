# Initialize the completion system
autoload -Uz compinit && compinit

# Show a menu for completions and allow selection with arrow keys
zstyle ':completion:*' menu select

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
