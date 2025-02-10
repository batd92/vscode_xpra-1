#!/bin/bash

set -e

USERNAME=${USERNAME:-user}
USER_HOME="/home/$USERNAME"
USER_WORKSPACE="/workspace/users/$USERNAME"
SESSION_ID=$((RANDOM % 900 + 100))
USER_DISPLAY=":${SESSION_ID}"
XPRA_PORT=$((10000 + SESSION_ID))
CODE_SERVER_PORT=$((8080 + SESSION_ID))

# Check port
check_port() {
    local PORT=$1
    if ss -tuln | grep -q ":$PORT "; then
        echo "⚠️  Port $PORT already in use! Looking for new port..."
        for i in {1..20}; do
            PORT=$((PORT + 1))
            if ! ss -tuln | grep -q ":$PORT "; then
                echo "✅  Use new port: $PORT"
                echo "$PORT"
                return
            fi
        done
        echo "❌ No available port found!" >&2
        exit 1
    else
        echo "$PORT"
    fi
}

XPRA_PORT=$(check_port $XPRA_PORT)
CODE_SERVER_PORT=$(check_port $CODE_SERVER_PORT)

# create user
if ! id "$USERNAME" &>/dev/null; then
    useradd -m -s /bin/bash "$USERNAME"
fi

mkdir -p "$USER_WORKSPACE"
chown -R "$USERNAME:$USERNAME" "$USER_WORKSPACE"

# 📌 Copy template into workspace
if [ -z "$(ls -A "$USER_WORKSPACE")" ]; then
    echo "📂 Workspace is empty, copy template..."
    cp -r /python-template/* "$USER_WORKSPACE/"
    chown -R "$USERNAME:$USERNAME" "$USER_WORKSPACE"
else
    echo "✅ Workspace already has data, no need to copy template."
fi

# config Xpra
XPRA_LOG="/tmp/xpra-${SESSION_ID}.log"

if ! xpra list | grep -q "$USER_DISPLAY"; then
    xpra start "$USER_DISPLAY" \
        --bind-tcp=0.0.0.0:$XPRA_PORT \
        --html=on \
        --daemon=yes \
        --auth=allow \
        --exit-with-children \
        --log-file="$XPRA_LOG"
fi

# waiting `xpra` start
sleep 2

# config access X
export DISPLAY="$USER_DISPLAY"
xhost +local: || echo "⚠️ Unable to open xhost permission, may cause error!"

# Run `code-server`
exec runuser -u "$USERNAME" -- code-server \
    --bind-addr 0.0.0.0:$CODE_SERVER_PORT \
    --user-data-dir "$USER_WORKSPACE/.vscode" \
    --auth none \
    "$USER_WORKSPACE"
