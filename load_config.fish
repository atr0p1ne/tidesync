function load_config
    set -g config_file ~/.config/tidesync/config.toml
    
    # Check if the user config exists
    if not test -f $config_file
        # If the user config doesn't exist, copy the default from /usr/share/tidesync/
        echo "User config not found. Copying config.toml to ~/.config/tidesync/config.toml"
        install -Dm644 $config_file /etc/tidesync/config.toml
    end
    
    # Function to extract key-value pairs from a TOML section
    function get_toml_value
        set key $argv[1]
        set value (rg -o '^\s*tidesync_user\s*=\s*"(.*?)"' $config_file | sed 's/^.*=\s*"\(.*\)"$/\1/')
        echo $value
    end

    # Parse the TIDESYNC section
    set -g tidesync_remote_host (get_toml_value "REMOTE_HOST")
    set -g tidesync_remote_user (get_toml_value "REMOTE_USER")
    set -g tidesync_rsync_default (get_toml_value "RSYNC-DEFAULT")

    # Loop through each section under [DIRS] and extract information
    set dirs (grep -oP "(?<=^\[DIRS\.)[A-Za-z0-9_]+" $config_file)  # Get all directory section names under [DIRS]
    
    for dir in $dirs
        # Getting local directory value and replacing ~ with the home directory
        set -g $dir_local_dir (get_toml_value "DIRS.$dir.LOCAL" | sed 's|~|'(echo $HOME)|')
        
        # Getting remote directory value and replacing ~ with the home directory
        set -g $dir_remote_dir (get_toml_value "DIRS.$dir.REMOTE" | sed 's|~|'(echo $HOME)|')
        
        # Getting exclude patterns
        set -g $dir_exclude_patterns (get_toml_value "DIRS.$dir.EXCLUDE")

    end

end
    
