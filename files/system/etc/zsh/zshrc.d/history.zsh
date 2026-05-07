HISTFILE="$HOME/.zsh_history"

HISTSIZE=1000
SAVEHIST=100

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# Ignores adding commands to the history file, but keeps them in the current terminal's history
zshaddhistory() {
    # Add app names here separated by |
    # Example: don't save history for 'python' or 'nmap'
    local ignore_apps='(aria2c|b|cd|fd|find|la|lg|ll|ls|l.|mkdir|mpv|rm|touch|ytd)'
    
    if [[ "$1" =~ ^$ignore_apps ]]; then
        return 1 # Tells Zsh: "Keep it in memory for this session, but don't write to disk"
    fi
}
