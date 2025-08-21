#!/bin/sh

# This script now runs as the 'nitter' user.
# Its only job is to generate the config and run the app.

# --- Step 1: Create the nitter.conf file from environment variables ---
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
hmacKey = \"a-very-secret-and-random-key-you-should-change-akfljshdflkjasd-asdfdsfsd-fasdfdsa-fdsaf-wqer-weqr-wer-ws\"
enableRSS = false
enableDebug = false" > /src/nitter.conf

echo "--- Dynamically generated nitter.conf (as user: $(whoami)) ---"
cat /src/nitter.conf
echo "------------------------------------------------------------"


# --- Step 2: Run the main Nitter application ---
echo "Starting Nitter application..."
exec ./nitter