# Only start tmux if we are in an interactive shell and not already inside tmux
if [[ -z "$TMUX" && $- == *i* ]]; then
    # Try to attach to a session named 'main', or create it if it doesn't exist
    exec tmux attach-session -t main || tmux new-session -s main
fi
