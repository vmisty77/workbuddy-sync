#!/bin/bash
# WorkBuddy Sync Script - auto pull + sync all workspace memories + commit + push
# Auto-discovers all WorkBuddy workspaces under $HOME/WorkBuddy/
set -e

SHARED_DIR="$HOME/.workbuddy"
WORKBUDDY_ROOT="$HOME/WorkBuddy"
cd "$SHARED_DIR"

# 1. Pull latest from remote
git pull --rebase origin master 2>/dev/null || true

# 2. Sync ALL workspace memories -> shared repo (bidirectional)
mkdir -p memory/

# Discover all workspace memory directories
if [ -d "$WORKBUDDY_ROOT" ]; then
  for ws_memory in "$WORKBUDDY_ROOT"/*/; do
    ws_memory_dir="${ws_memory}.workbuddy/memory"
    if [ -d "$ws_memory_dir" ]; then
      # Workspace -> shared repo
      cp "$ws_memory_dir"/*.md memory/ 2>/dev/null || true
      # Shared repo -> workspace
      cp memory/*.md "$ws_memory_dir/" 2>/dev/null || true
    fi
  done
fi

# 3. Stage changes
git add memory/ skills/ .gitignore sync.sh setup-device.sh 2>/dev/null

# 4. Commit if there are changes
if ! git diff --cached --quiet; then
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  git commit -m "Auto sync: $TIMESTAMP" 2>/dev/null || true
fi

# 5. Push to remote
git push origin master 2>/dev/null || true

echo "Sync done: $(date)"
