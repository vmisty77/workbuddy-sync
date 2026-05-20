#!/bin/bash
# WorkBuddy Sync Script - auto pull + sync workspace memory + commit + push
set -e

SHARED_DIR="$HOME/.workbuddy"
WORKSPACE_MEMORY="$HOME/WorkBuddy/Claw/.workbuddy/memory"
cd "$SHARED_DIR"

# 1. Pull latest from remote
git pull --rebase origin master 2>/dev/null || true

# 2. Sync workspace memory -> shared repo (both directions)
mkdir -p memory/
if [ -d "$WORKSPACE_MEMORY" ]; then
  cp "$WORKSPACE_MEMORY"/*.md memory/ 2>/dev/null || true
fi
# Also push shared memory back to workspace
if [ -d "$WORKSPACE_MEMORY" ]; then
  cp memory/*.md "$WORKSPACE_MEMORY/" 2>/dev/null || true
fi

# 3. Stage changes
git add memory/ skills/ .gitignore setup-device.sh 2>/dev/null

# 4. Commit if there are changes
if ! git diff --cached --quiet; then
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  git commit -m "Auto sync: $TIMESTAMP" 2>/dev/null || true
fi

# 5. Push to remote
git push origin master 2>/dev/null || true

echo "Sync done: $(date)"
