#!/usr/bin/env bash
set -e

# Ensure PATH and HOME
export PATH=$HOME/bin:/usr/local/bin:$PATH
VAULT_ROOT="$HOME/vaults"

# List vault directories
vaults=("$VAULT_ROOT"/*/)

if (( ${#vaults[@]} == 0 )); then
    echo "No vaults found in $VAULT_ROOT"
    read -p "Press Enter to exit..."
    exit 1
elif (( ${#vaults[@]} == 1 )); then
    vault_dir="${vaults[1]}"
else
    vault_dir=$(printf "%s\n" "${vaults[@]}" | fzf) || exit 0
fi

# Change to the selected vault
cd "$vault_dir" || exit 1

# Open Neovim
nvim

# Stage all changes
git add -A

# Commit: force interactive Vim for commit message
if ! git commit; then
    echo "Nothing to commit"
fi

# Push changes
git push || echo "Push failed"

# Keep the pane/window open so you can see output
echo "Finished. Press Enter to close..."
read -r

