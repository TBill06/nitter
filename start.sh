#!/bin/sh

# This script runs as 'root' when the container starts.

# The path to the secret file mounted by Render.
SECRET_FILE_PATH="/etc/secrets/sessions.jsonl"

# The path to the temporary, writeable copy we will create.
TEMP_SESSIONS_PATH="/tmp/sessions.jsonl"

# 1. As root, copy the secret file to a writeable location.
cp "${SECRET_FILE_PATH}" "${TEMP_SESSIONS_PATH}"

# 2. As root, change the ownership of the COPY to the 'nitter' user.
chown nitter:nitter "${TEMP_SESSIONS_PATH}"

# 3. Switch to the 'nitter' user and execute the application.
#    The application will get its file path from the NITTER_SESSION_FILE env var.
exec su nitter -s /bin/sh -c './nitter'