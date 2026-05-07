# Load the manual color choices
[ -f ~/.config/theme/colors.sh ] && source ~/.config/theme/colors.sh

# Command to apply the theme to tmux
apply-theme() {
    source ~/.config/theme/colors.sh

    if [ -n "$TMUX" ]; then
        local n_style="fg=${color0},bg=${color3},bold"
        local i_style="fg=${color0},bg=${color2},bold"

        # Set default state
        tmux set -g status-left "#[${i_style}] INSERT "

        # Set the dynamic switcher
        tmux set-hook -g pane-mode-changed "if-shell -F '#{pane_in_mode}' \
            'set -g status-left \"#[${n_style}] NORMAL \"' \
            'set -g status-left \"#[${i_style}] INSERT \"'"
        
        tmux refresh-client -S
    fi
}
