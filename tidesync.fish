#!/usr/bin/env fish

# 1. Define the path to the system-wide default config and the user's config
set system_config_file /usr/share/tidesync/config.toml
set user_config_file ~/.config/tidesync/config.toml

# 2. Check if the user config exists. If not, copy the default one
if not test -f $user_config_file
    echo "No user config found, copying the default configuration..."
    cp $system_config_file $user_config_file
end

# 3. Load the user configuration (now it will always exist)
source ~/.config/fish/functions/tidesync_load_config.fish

# 4. Check if the user provided a command argument (pull or push)
set sync_action $argv[1]

# If no argument is provided, ask the user to choose either "pull" or "push"
if test -z $sync_action
    echo "No sync action specified."
    set sync_action (choose "Choose action:" "pull" "push")
end

# 5. Perform the sync operation based on the argument (pull or push)
switch $sync_action
    case "pull"
        # Pull data from remote to local
        source ~/.config/fish/functions/tidesync_pull.fish
    case "push"
        # Push data from local to remote
        source ~/.config/fish/functions/tidesync_push.fish
    case "*"
        echo "Error: Invalid action '$sync_action'. Use 'pull' or 'push'."
        return 1
end

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

function tidesync_push --description "Push synced directories from local to remote"
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

function tidesync_help
    echo "
TideSync Commands:
  tidesync_push   Sync local files to the server
  tidesync_pull   Sync server files to the local directory

Configuration:
  Edit the config file: config.fish
"
end

function tidesync_load_config --description "Load TideSync configuration from TOML file"
    # Define user config path
    set config_file ~/.config/tidesync.toml

    # Check if the user config exists
    if not test -f $user_config_file
        # If the user config doesn't exist, copy the default from /usr/share/tidesync/
        echo "First run! Copying default config.toml to ~/.config/tidesync.toml"
        cp /usr/share/tidesync/config.toml $config_file
    end
    
    # Array to store sync sections (dirs)
    set -g TIDESYNC_DIRS

    # Parsing variables
    set -l current_table ""

    # Parse the selected TOML configuration file
    if test -f $config_file
        for line in (grep -v '^\s*#' $config_file)  # Ignore comments
            # Detect [DIRS.SOMETHING] tables
            if echo $line | grep -q '^\[DIRS\.'
                set current_table (string trim (string replace -r '\[DIRS\.|\]' '' $line))
                set current_table (string upper "$current_table")  # Convert to uppercase
                set -a TIDESYNC_DIRS $current_table               # Store the table name
            # Parse key=value pairs inside tables
            else if test -n "$current_table" && echo $line | grep -q '='
                set -l key (string trim (echo $line | cut -d'=' -f1))
                set -l value (string trim (echo $line | cut -d'=' -f2-))

                # Trim quotes around values
                set value (string replace -r '^"(.*)"$' '$1' $value)
                if string match -r '^"(.*)"$' $value
                    set value (string match -r '^"(.*)"$' $value)
                end
                # Store the parsed values using table-based namespace
                set -g {$current_table}_$key $value
            end
        end
    end
end
