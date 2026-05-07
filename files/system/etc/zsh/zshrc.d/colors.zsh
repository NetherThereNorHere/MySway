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
    tmux set-environment THEME_BG "$THEME_BG"
    tmux set-environment THEME_NORMAL "$THEME_NORMAL"
    tmux set-environment THEME_INSERT "$THEME_INSERT"
fi

# Command that applies colors from ~/.config/theme/colors.sh
apply-theme() {
    source /etc/zsh/zshrc.d/colors.zsh
    tmux source-file /etc/tmux.conf
    echo "Theme applied!"
}
