#!/bin/bash
# WorkBuddy Sync - New Device Setup Script
# Run once on each new device

set -e

echo "=== WorkBuddy Sync Setup ==="

# 1. Ensure SSH key exists
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
  echo "Generating SSH key..."
  mkdir -p "$HOME/.ssh"
  ssh-keygen -t ed25519 -C "workbuddy-sync" -f "$HOME/.ssh/id_ed25519" -N ""
  echo ""
  echo "==================== COPY THIS KEY TO GITHUB ===================="
  cat "$HOME/.ssh/id_ed25519.pub"
  echo "===================================================================="
  echo ""
  echo "Add it at: https://github.com/settings/ssh/new"
  read -p "Press Enter after adding the key to GitHub..." _
fi

# 2. Test SSH to GitHub
echo "Testing GitHub SSH..."
ssh -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 || true

# 3. Clone or update the sync repo
if [ -d "$HOME/.workbuddy/.git" ]; then
  echo "Repo exists, pulling latest..."
  cd "$HOME/.workbuddy"
  git pull --rebase origin master
else
  echo "Cloning repo..."
  # Backup existing skills if any
  if [ -d "$HOME/.workbuddy/skills" ] && [ ! -L "$HOME/.workbuddy/skills" ]; then
    mv "$HOME/.workbuddy/skills" "$HOME/.workbuddy/skills.backup.$(date +%s)" 2>/dev/null || true
  fi
  if [ -d "$HOME/.workbuddy/memory" ] && [ ! -L "$HOME/.workbuddy/memory" ]; then
    mv "$HOME/.workbuddy/memory" "$HOME/.workbuddy/memory.backup.$(date +%s)" 2>/dev/null || true
  fi
  
  TMPDIR=$(mktemp -d)
  git clone git@github.com:vmisty77/workbuddy-sync.git "$TMPDIR"
  cp -r "$TMPDIR/skills" "$HOME/.workbuddy/"
  cp -r "$TMPDIR/memory" "$HOME/.workbuddy/"
  cp "$TMPDIR/.gitignore" "$HOME/.workbuddy/"
  cp "$TMPDIR/sync.sh" "$HOME/.workbuddy/"
  rm -rf "$TMPDIR"
  
  # Re-init git in .workbuddy
  cd "$HOME/.workbuddy"
  git init
  git remote add origin git@github.com:vmisty77/workbuddy-sync.git
  git fetch origin
  git reset --hard origin/master
fi

echo ""
echo "=== Setup complete! ==="
echo "Skills and memory are now synced."
echo "Ask WorkBuddy to create a 'WorkBuddy Sync' automation for this device."
