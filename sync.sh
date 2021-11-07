#!/bin/bash
# Script used to synchronize sources

export LOCAL_REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default configuration
config="${LOCAL_REPO_DIR}/tools/layers-mngt/lastreleased.yml"

# Return value
return_value=-1

function print_usage
{
    echo "Usage: sync.sh [-h] [-l] <config>"
    echo ""
    echo "Options:"
    echo "  -h     - Display help"
    echo "  -l     - List available configurations"
    echo "  config - The configuration to build (ex: warrior)"
    echo ""
}

function print_configurations
{
    echo "Available configurations:"
    echo ""
    ls -1 ${LOCAL_REPO_DIR}/tools/layers-mngt/ | grep -e yml
    echo ""
}

if [ $# -gt 0 ]; then

    if [ "$1" == "-h" ]; then
	print_usage
	return_value=1
    elif [ "$1" == "-l" ]; then
	print_configurations
	return_value=2
    else
	# Check that configuration is valid
	print_configurations | grep -e "$1" > /dev/null

	if [ $? -gt 0 ]; then
	    echo "$config configuration is invalid."
	    echo ""
	    print_configurations

	    return_value=3
	else
	    # The configuration is valid
	    config="${LOCAL_REPO_DIR}/tools/layers-mngt/${1}.yml"

	    # Execute playbook
	    ansible-playbook ${config} --extra-vars "TOP_SRCDIR=${LOCAL_REPO_DIR}/layers/"

	    return_value=0
	fi
    fi
else
    print_usage
    return_value=4
fi

exit $return_value
