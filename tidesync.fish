#!/usr/bin/env fish
function tidesync
    # Load all necessary inernal functions inside this main function, so it does not clutter up fish shell
    for f in /usr/share/tidesync/*.fish
        source $f
    end

    #Load configuration (user, server and specified directories)
    load_config
	
     for dir in $TIDESYNC_DIRS
            set local_dir $$dir_LOCAL
            set remote_dir $$dir_REMOTE

            echo "Syncing: $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$remote_dir = $local_dir"
            rsync $TIDESYNC_REMOTE_USER@$TIDESYNC_REMOTE_HOST:$remote_dir/ $local_dir

            if test $status -eq 0
                echo "[$(date)] Sync from $dir completed successfully." >> $TIDESYNC_LOG_FILE
            else
                echo "[$(date)] Sync from $dir failed!" >> $TIDESYNC_LOG_FILE
            end
     end
end
