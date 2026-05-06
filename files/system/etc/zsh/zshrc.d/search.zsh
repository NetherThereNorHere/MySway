# 'fif' = Find In File
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  
  rg --files-with-matches --no-messages "$1" | fzf \
    --preview "rg --ignore-case --pretty --context 10 '$1' {} | bat --color=always --style=header,grid" \
    --bind "enter:execute(vim {} +/\$1)"
}
