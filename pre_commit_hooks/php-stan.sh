#!/bin/bash

# Bash PHP Codesniffer Hook
# This script fails if the PHP Codesniffer output has the word "ERROR" in it.
# Does not support failing on WARNING AND ERROR at the same time.
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
# Arguments
# - None

# Echo Colors
msg_color_magenta='\033[1;35m'
msg_color_yellow='\033[0;33m'
msg_color_none='\033[0m' # No Color

# Loop through the list of paths to run php codesniffer against
echo -en "${msg_color_yellow}Begin PHPStan ...${msg_color_none} \n"
phpstan_local_exec="phpstan.phar"
phpstan_command="php $phpstan_local_exec"

# Check vendor/bin/phpunit
phpstan_vendor_command="vendor/bin/phpstan"
phpstan_global_command="phpstan"
if [ -f "$phpstan_vendor_command" ]; then
	phpstan_command=$phpstan_vendor_command
else
    if hash phpstan 2>/dev/null; then
        phpstan_command=$phpstan_global_command
    else
        if [ -f "$phpstan_local_exec" ]; then
            phpstan_command=$phpstan_command
        else
            echo "No valid PHP stan executable found! Please have one available as either $phpstan_vendor_command, $phpstan_global_command or $phpstan_local_exec"
            exit 1
        fi
    fi
fi

phpstan_files_to_check="${@:2}"
phpstan_args=$1
phpstan_command="$phpstan_command analyse $phpstan_args $phpstan_files_to_check"

echo "Running command $phpstan_command"
command_result=`eval $phpstan_command`
if [[ $command_result =~ ERROR ]]
then
    echo -en "${msg_color_magenta}Errors detected by PHPStan ... ${msg_color_none} \n"
    echo "$command_result"
    exit 1
fi

exit 0