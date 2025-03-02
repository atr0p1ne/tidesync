#!/usr/bin/env fish
function tidesync
    argparse --name=tidesync 'd/debug' 's/sync' -- $argv

    function echo_debug
        if set -q _flag_debug
            echo "$argv[1]"
        else
        end
    end

    # Load all necessary inernal functions inside this main function,
    # so it does not clutter up fish shell
    echo_debug "Starting to load functions from /usr/share/tidesync/*.fish"
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
