#!/bin/sh

# This script will run as the root user when the container starts.

# 1. Read the content of the secret file into an environment variable.
#    'export' makes the variable available to child processes.
export NITTER_SESSIONS=$(cat /etc/secrets/sessions.jsonl)

# 2. Use 'su-exec' (a safe way to switch users) to run the final command
#    as the 'nitter' user.
#    'su-exec' is like 'sudo' but safer for containers.
#    Alpine linux (which this image uses) has it built-in.
exec su-exec nitter ./nitter