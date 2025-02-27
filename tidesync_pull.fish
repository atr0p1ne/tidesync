function tidesync_pull --description "Pull synced directories from remote to local"
    for dir in $TIDESYNC_DIRS
        set local_dir $$dir_LOCAL
        set remote_dir $$dir_REMOTE

        echo "Syncing from remote: $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$remote_dir → $local_dir"
        rsync $RSYNC_OPTS $DELETE_FLAG --exclude-from=$TIDESYNC_EXCLUDE_FILE $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$remote_dir/ $local_dir

        if test $status -eq 0
            echo "[$(date)] Sync from $dir completed successfully." >> $TIDESYNC_LOG_FILE
        else
            echo "[$(date)] Sync from $dir failed!" >> $TIDESYNC_LOG_FILE
        end
    end
end

