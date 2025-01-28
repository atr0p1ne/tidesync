# Configuration for TideSync
set -g TIDESYNC_LOCAL_DIR "~/Documents"
set -g TIDESYNC_REMOTE_USER "username"
set -g TIDESYNC_REMOTE_HOST "example.com"
set -g TIDESYNC_REMOTE_DIR "~/server_documents"
set -g TIDESYNC_EXCLUDE_FILE "~/.tidesync_exclude"
set -g TIDESYNC_LOG_FILE "~/tidesync_log.txt"

# Rsync options
set -g RSYNC_OPTS "--archive --verbose --compress --human-readable --progress"
set -g DELETE_FLAG ""  # Leave blank to avoid deletion syncing

