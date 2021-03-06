#!/usr/bin/env sh

# Bash PHP Mess Detector
# This will prevent a commit if the tool has detected violations of the
# rulesets specified
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

# Loop through the list of paths to run php mess detector against
echo "${msg_color_yellow}Begin PHP Mess Detector ...${msg_color_none}"
phpmd_local_exec="phpmd.phar"
phpmd_command="php $phpmd_local_exec"

# Check vendor/bin/phpmd
phpmd_vendor_command="vendor/bin/phpmd"
phpmd_global_command="phpmd"
if [ -f "$phpmd_vendor_command" ]; then
    phpmd_command=$phpmd_vendor_command
else
    if hash phpcs 2>/dev/null; then
        phpmd_command=$phpmd_global_command
    else
        if [ -f "$phpcs_local_exec" ]; then
            phpmd_command=$phpmd_command
        else
            echo "No valid PHP Codesniffer executable found! Please have one available as either $phpmd_vendor_command, $phpmd_global_command or $phpmd_local_exec"
            exit 1
        fi
    fi
fi

phpmd_files_to_check="${@:2}"
phpmd_files_to_check=$(echo $phpmd_files_to_check | tr " " "\n")
phpmd_args=$1

error_message=""
php_errors_found=false
for file in $phpmd_files_to_check
do
    phpmd_command_file="${phpmd_command} ${file} text ${phpmd_args}"
    echo "Running command $phpmd_command_file"
    command_result=$(${phpmd_command_file})
    if [[ $? -ne 0 ]]
    then
        echo "${msg_color_magenta}Errors detected by PHP CodeSniffer in ${file} ... ${msg_color_none}"
        echo "${command_result}"
        php_errors_found=true
    fi
done

if [ "$php_errors_found" = true ]
then
    exit 1
fi

exit 0
