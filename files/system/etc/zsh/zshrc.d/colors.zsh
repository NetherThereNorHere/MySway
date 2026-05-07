# Source the manual color choices
[ -f ~/.config/theme/colors.sh ] && source ~/.config/theme/colors.sh

# Assign the variables to the names your apps expect
export THEME_BG=$color0
export THEME_FG=$color7
export THEME_INSERT=$color2
export THEME_NORMAL=$color3
export THEME_ACCENT=$color4

# Sync these to tmux environment immediately
if [ -n "$TMUX" ]; then
    tmux set-environment THEME_FG "$THEME_FG"
    tmux set-environment THEME_BG "$THEME_BG"
    tmux set-environment THEME_NORMAL "$THEME_NORMAL"
    tmux set-environment THEME_INSERT "$THEME_INSERT"
fi

# Command that applies colors from ~/.config/theme/colors.sh
apply-theme() {
    source ~/.config/theme/colors.sh

    if [ -n "$TMUX" ]; then
        # 1. Define the RAW strings
        local n_style="fg=${color0},bg=${color3},bold"
        local i_style="fg=${color0},bg=${color2},bold"

        # 2. Set the "Default" (Insert) style
        tmux set -g status-left "#[${i_style}] INSERT "

        # 3. Create hooks that swap the bar instantly when the mode changes
        # No logic, no commas, no escapes, no bold]
        tmux set-hook -g pane-mode-changed "if-shell -F '#{pane_in_mode}' 'set -g status-left \"#[${n_style}] NORMAL \"' 'set -g status-left \"#[${i_style}] INSERT \"'"
        
        tmux refresh-client -S
    fi
}
