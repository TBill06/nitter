#!/bin/sh

# This script runs as 'root' when the container starts.

# 1. DEFINE FILE PATHS
CONFIG_PATH="/tmp/nitter.conf"
SECRET_FILE_PATH="/etc/secrets/sessions.jsonl"
TEMP_SESSIONS_PATH="/tmp/sessions.jsonl"

# 2. GENERATE THE ENTIRE, PERFECT CONFIG FILE FROM SCRATCH
#    We are not modifying the old file. We are creating a new one.
#    'cat <<EOF >' is a standard shell technique for writing a multi-line string to a file.
cat <<EOF > "${CONFIG_PATH}"
[Server]
address = "0.0.0.0"
port = 8080
https = false
title = "Echo Chamber Intel"

[Cache]
listMinutes = 10
rssMinutes = 5
redisHost = "${REDIS_HOST}"
redisPort = ${REDIS_PORT}
redisDb = 0

[Config]
hmacKey = "a-very-secret-and-random-key-you-should-change-akfljshdflkjasd-asdfdsfsd-fasdfdsa-fdsaf-wqer-weqr-wer-ws"
enableRSS = false
enableDebug = false
EOF

# 3. FIX THE SESSIONS FILE PERMISSIONS
cp "${SECRET_FILE_PATH}" "${TEMP_SESSIONS_PATH}"
chown nitter:nitter "${TEMP_SESSIONS_PATH}"
chown nitter:nitter "${CONFIG_PATH}" # Also set ownership on our new config file

# 4. START THE APPLICATION AS THE 'nitter' USER
#    Tell Nitter to use our newly generated config file (-c flag).
exec su nitter -s /bin/sh -c 'NITTER_SESSION_FILE="/tmp/sessions.jsonl" ./nitter -c "/tmp/nitter.conf"'