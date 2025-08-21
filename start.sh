#!/bin/sh

# This script runs as 'root' when the container starts.

# 1. DEFINE FILE PATHS
# The original config file copied by the Dockerfile
DEFAULT_CONFIG_PATH="/src/nitter.conf"
# The new, temporary config file we will generate
TEMP_CONFIG_PATH="/tmp/nitter.conf"
# The path to the secret file mounted by Render
SECRET_FILE_PATH="/etc/secrets/sessions.jsonl"
# The path to the temporary, writeable copy of the secret file
TEMP_SESSIONS_PATH="/tmp/sessions.jsonl"

# 2. GENERATE THE CORRECT CONFIG FILE
# Use 'sed' (a standard text replacement tool) to create a new config file.
# It takes the default config, replaces the 'localhost' line with the real Redis host,
# and saves the result to our temporary path.
sed "s/redisHost = \"localhost\"/redisHost = \"$REDIS_HOST\"/" "${DEFAULT_CONFIG_PATH}" > "${TEMP_CONFIG_PATH}"

# 3. FIX THE SESSIONS FILE PERMISSIONS (We know this part works)
cp "${SECRET_FILE_PATH}" "${TEMP_SESSIONS_PATH}"
chown nitter:nitter "${TEMP_SESSIONS_PATH}"

# 4. START THE APPLICATION AS THE 'nitter' USER
# Tell Nitter to use our newly generated config file (-c flag)
# And tell it where to find the sessions file (NITTER_SESSION_FILE env var)
exec su nitter -s /bin/sh -c 'NITTER_SESSION_FILE="/tmp/sessions.jsonl" ./nitter -c "/tmp/nitter.conf"'