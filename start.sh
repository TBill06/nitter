#!/bin/sh

# This is our smart startup script.
# It runs inside the container right before the main application starts.

# --- Step 1: Create the nitter.conf file from environment variables ---

# We use 'echo' to write the configuration line by line into the file.
# This allows us to use the dynamic REDIS_HOST and REDIS_PORT provided by Render.
echo "[Server]
address = \"0.0.0.0\"
port = 8080
https = false
title = \"Echo Chamber Intel\"
hostname = \"$RENDER_EXTERNAL_URL\" # Use Render's magic env var for correct links

[Cache]
listMinutes = 10
rssMinutes = 5
redisHost = \"$REDIS_HOST\" # Inject the Redis host from Render
redisPort = $REDIS_PORT     # Inject the Redis port from Render

[Config]
hmacKey = \"a-very-secret-and-random-key-you-should-change-akfljshdflkjasd-asdfdsfsd-fasdfdsa-fdsaf-wqer-weqr-wer-ws\"
enableRSS = false
enableDebug = false" > /src/nitter.conf

echo "--- Dynamically generated nitter.conf ---"
cat /src/nitter.conf # Print the generated config to the logs for debugging
echo "---------------------------------------"


# --- Step 3: Run the main Nitter application ---

# 'exec' replaces the script process with the nitter process.
# This is the standard way to end a startup script.
exec ./nitter