#!/bin/sh

# This script runs as ROOT. It has full permissions.

# Step 1: Handle the sessions.jsonl file
SESSIONS_SECRET_PATH=/etc/secrets/sessions.jsonl
SESSIONS_DEST_PATH=/src/sessions.jsonl

# As root, this copy command WILL succeed.
cp $SESSIONS_SECRET_PATH $SESSIONS_DEST_PATH

# Step 2: Create the nitter.conf file
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
enableDebug = true" > /src/nitter.conf

echo "--- Config and secrets prepared as ROOT ---"

# Step 3: Run the main Nitter application
exec ./nitter