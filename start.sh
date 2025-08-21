#!/bin/sh

# This script runs as the 'nitter' user, who now has permissions to read secrets.

# --- Step 1: Handle the sessions.jsonl file ---
SESSIONS_SECRET_PATH=/etc/secrets/sessions.jsonl
SESSIONS_DEST_PATH=/src/sessions.jsonl

echo "Attempting to copy sessions file..."
if [ -f "$SESSIONS_SECRET_PATH" ]; then
    cp $SESSIONS_SECRET_PATH $SESSIONS_DEST_PATH
    echo "Successfully copied sessions file to destination."
else
    echo "FATAL: Secret file not found at $SESSIONS_SECRET_PATH. Ensure it is attached in the Render UI."
    exit 1 # Exit with an error code
fi

# --- Step 2: Create the nitter.conf file ---
echo "[Server]
address = \"0.0.0.0\"
port = 8080
https = false
title = \"Echo Chamber Intel\"
hostname = \"$RENDER_EXTERNAL_URL\"

[Cache]
listMinutes = 10
rssMinutes = 5
redisHost = \"$REDIS_HOST\"
redisPort = $REDIS_PORT

[Config]
hmacKey = \"a-very-secret-and-random-key-you-should-change\"
enableRSS = false
enableDebug = true" > /src/nitter.conf # Enable debug for now

echo "--- Dynamically generated nitter.conf ---"
cat /src/nitter.conf
echo "---------------------------------------"


# --- Step 3: Run the main Nitter application ---
exec ./nitter