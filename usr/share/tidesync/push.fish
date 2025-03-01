function push
    for dir in $TIDESYNC_DIRS
        set local_dir $$dir_LOCAL
        set remote_dir $$dir_REMOTE

        echo "Syncing from local: $local_dir → $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$remote_dir"
        rsync $RSYNC_OPTS $DELETE_FLAG --exclude-from=$TIDESYNC_EXCLUDE_FILE $local_dir/ $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$remote_dir

        if test $status -eq 0
            echo "[$(date)] Sync to $dir completed successfully." >> $TIDESYNC_LOG_FILE
        else
            echo "[$(date)] Sync to $dir failed!" >> $TIDESYNC_LOG_FILE
        end
    end
end
