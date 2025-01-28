function tidesync_pull
    echo "Syncing $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$TIDESYNC_REMOTE_DIR to $TIDESYNC_LOCAL_DIR"
    rsync $RSYNC_OPTS $DELETE_FLAG --exclude-from=$TIDESYNC_EXCLUDE_FILE $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$TIDESYNC_REMOTE_DIR/ $TIDESYNC_LOCAL_DIR
    if test $status -eq 0
        echo "[$(date)] Sync from server completed successfully." >> $TIDESYNC_LOG_FILE
    else
        echo "[$(date)] Sync from server failed!" >> $TIDESYNC_LOG_FILE
    end
end

