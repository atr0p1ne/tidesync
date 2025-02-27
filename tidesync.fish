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

