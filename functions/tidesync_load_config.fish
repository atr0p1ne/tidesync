function tidesync_load_config --description "Load TideSync configuration from TOML file"
    # Define the default config path inside the module
    set default_config_file (dirname (status --current-filename))/config.toml

    # Define the user-specific config path
    set user_config_file ~/.config/tidesync/config.toml

    # Use the default config file first
    set config_file $default_config_file

    # If the user config file exists, use it to override defaults
    if test -f $user_config_file
        set config_file $user_config_file
    end

    # Parse the selected TOML configuration file
    if test -f $config_file
        for line in (grep -v '^\s*#' $config_file)  # Ignore comments
            # Handle [section] header (e.g., [Tidesync] or [rsync])
            if echo $line | grep -q '^\['
                set -l section (string trim (string replace -r '\[|\]' '' $line))
            # Extract key=value pairs
            else if echo $line | grep -q '='
                set -l key (string trim (echo $line | cut -d'=' -f1))
                set -l value (string trim (echo $line | cut -d'=' -f2-))

                # Trim quotes around values if any
                set value (string replace -r '^"(.*)"$' '$1' $value)
                set value (string replace -r "^\x22(.*)\x22$" '$1' $value)  # In case of extra quotes

                # Set Fish variables from parsed TOML keys
                set -g $key $value
            end
        end
    end
end

