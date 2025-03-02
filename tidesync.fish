#!/usr/bin/env fish
function tidesync
    argparse --name=tidesync 'd/debug' 's/sync' -- $argv

    if set -q _flag_d
        set -g _flag_d  # Make it global so it's available in other functions
    end
    if set -q _flag_s
        set -g _flag_s  # Make it global so it's available in other functions
    end

    function echo_debug
        if set -q _flag_d
            echo "$argv[1]"
        else
        end
    end

    # Load all necessary inernal functions inside this main function,
    # so it does not clutter up fish shell
    echo_debug "Loading functions from /usr/share/tidesync/*.fish..."
    for f in /usr/share/tidesync/*.fish
        source $f
    end

    #Load configuration (user, server and specified directories)
    echo_debug "Loading configuration file..."
    load_config
	
	if set -q _flag_d
	    echo_debug "Start syncing directories..."
        for dir in $TIDESYNC_DIRS
            echo_debug "Syncing $dir..."
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
end
