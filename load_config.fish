function load_config
    set -g config_template /usr/share/tidesync/config_template.toml
    set -g config_user ~/.config/tidesync/config.toml
    
    # Check if the user config exists
    if not test -f $config_user
        # If the user config doesn't exist, copy the default from /usr/share/tidesync/
        echo "User config not found. Copying config_default.toml to ~/.config/tidesync/config.toml"
        install -Dm644 $config_template $config_user 
    end
    
    # Function to extract key-value pairs from a TOML section
    function get_toml_value
        set key $argv[1]
        set value (rg -o "^\s*$key\s*=\s*\"(.*?)\"" $config_user | sed 's/^.*=\s*"\(.*\)"$/\1/')
        echo $value
    end

    # Parse the TIDESYNC section
    set -g remote_host (get_toml_value "REMOTE_HOST")
    set -g remote_user (get_toml_value "REMOTE_USER")
    set -g rsync_options (get_toml_value "OPTIONS")
    echo_debug "Remote Host - $remote_host, Remote User - $remote_user"
    echo_debug "Rsync default - $rsync_options"
    
   # Read the config file and extract the directory sections
    # Extract the part after [DIRS.PHOTOS], etc.
    for line in (cat $config_user)
        # Trim whitespace and ignore empty lines or comments
        set line (string trim $line)
        if test -z "$line" -o "$line" = "#"* # Skip empty or comment lines
            continue
        end
        
        # Match the section header like [DIRS.PHOTOS] using ripgrep
        if echo $line | rg -q '^\[DIRS\.' 
            # Extract the directory name using ripgrep and sed
            set dir_name (echo $line | sed 's/^\[DIRS\.\(.*\)\]$/\1/')
            
            # Initialize the local, remote, and exclude variables for this directory
            set local_path ""
            set remote_path ""
            set exclude_pattern ""
            
            # Now extract LOCAL, REMOTE, EXCLUDE values for the current directory
            while read line
                set line (string trim $line) # Trim whitespace
                if test -z "$line" -o "$line" = "#"* # Skip empty or comment lines
                    continue
                end

                # If we reach the next section, stop reading
                if echo $line | rg -q '^\[DIRS\.' 
                    break
                end
                
                # Check for the LOCAL, REMOTE, EXCLUDE keys using ripgrep
                if echo $line | rg -q '^LOCAL'
                    set local_path (echo $line | sed 's/^LOCAL\s*=\s*"\(.*\)"/\1/')
                end
                if echo $line | rg -q '^REMOTE'
                    set remote_path (echo $line | sed 's/^REMOTE\s*=\s*"\(.*\)"/\1/')
                end
                if echo $line | rg -q '^EXCLUDE'
                    set exclude_pattern (echo $line | sed 's/^EXCLUDE\s*=\s*"\(.*\)"/\1/')
                end
            end
            
            # Assign variables dynamically for each directory section (without brackets)
            set DIRS_$dir_name_LOCAL $local_path
            set DIRS_$dir_name_REMOTE $remote_path
            set DIRS_$dir_name_EXCLUDE $exclude_pattern

            # Optionally, print the variables for testing
            echo "Local path for $dir_name: " $DIRS_$dir_name_LOCAL
            echo "Remote path for $dir_name: " $DIRS_$dir_name_REMOTE
            echo "Excludes for $dir_name: " $DIRS_$dir_name_EXCLUDE
        end
    end
    

end
    
