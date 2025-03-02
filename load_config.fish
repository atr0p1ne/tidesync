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
    

    end

end
    
