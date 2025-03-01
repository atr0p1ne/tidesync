#!/usr/bin/env fish
function tidesync
    # Load all necessary inernal functions inside this main function, so it does not clutter up fish shell
    for f in /usr/share/tidesync/*.fish
        source $f
    end

    #Load configuration (user, server and specified directories)
    load_config
	
	
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
		pull
	    case "push"
		push
	    case "*"
		echo "Error: Invalid action '$sync_action'. Use 'pull' or 'push'."
		return 1
	end
end
