function tidesync_push
    echo "Syncing $TIDESYNC_LOCAL_DIR to $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$TIDESYNC_REMOTE_DIR"
    rsync $RSYNC_OPTS $DELETE_FLAG --exclude-from=$TIDESYNC_EXCLUDE_FILE $TIDESYNC_LOCAL_DIR/ $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$TIDESYNC_REMOTE_DIR
    if test $status -eq 0
        echo "[$(date)] Sync to server completed successfully." >> $TIDESYNC_LOG_FILE
    else
        echo "[$(date)] Sync to server failed!" >> $TIDESYNC_LOG_FILE
    end
end

