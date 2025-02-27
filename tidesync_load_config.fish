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
