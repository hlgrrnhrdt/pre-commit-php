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

# Loop through the list of paths to run php codesniffer against
echo "${msg_color_yellow}Begin PHP Mess Detector ...${msg_color_none}"
phpmd_local_exec="phpmd.phar"
phpmd_command="php $phpmd_local_exec"

# Check vendor/bin/phpunit
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

echo "${phpmd_command}"
exit 1

phpmd_files_to_check="${@:2}"
phpmd_args=$1
phpmd_command="$phpmd_command $phpmd_args $phpmd_files_to_check"

echo "Running command $phpmd_command"
command_result=`eval $phpmd_command`
if [[ $command_result =~ ERROR ]]
then
    echo "${msg_color_magenta}Errors detected by PHP CodeSniffer ... ${msg_color_none}"
    echo "$command_result"
    exit 1
fi

exit 0






# echo -e "${@:2}"
# exit 1

# # Plugin title
# title="PHP Mess Detector"

# # Possible command names of this tool
# local_command="phpmd.phar"
# vendor_command="vendor/bin/phpmd"
# global_command="phpmd"

# # Print a welcome and locate the exec for this tool
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# source $DIR/helpers/colors.sh
# source $DIR/helpers/formatters.sh
# source $DIR/helpers/welcome.sh
# source $DIR/helpers/locate.sh

# # Build our list of files, and our list of args by testing if the argument is
# # a valid path
# args=""
# files=()
# for arg in ${*}
# do
#     if [ -e $arg ]; then
#         files+=("$arg")
#     else
#         args+=" $arg"
#     fi
# done;

# # Run the command on each file
# echo -e "${txtgrn}  $exec_command${args}${txtrst}"
# php_errors_found=false
# error_message=""
# for path in "${files[@]}"
# do
#     OUTPUT="$(${exec_command} ${path} text ${args})"
#     RETURN=$?
#     if [ $RETURN -eq 1 ]; then
#         # Return 1 means that PHPMD crashed
#         error_message+="  - ${bldred}PHPMD failed to evaluate ${path}${txtrst}"
#         error_message+="${OUTPUT}\n\n"
#         php_errors_found=true
#     elif [ $RETURN -eq 2 ]; then
#         # Return 2 means it ran successfully, but found issues.
#         # Using perl regex to clean up PHPMD output, trimming out full file
#         # paths that are included in each line
#         error_message+="  - ${txtylw}${path}${txtrst}"
#         error_message+="$(echo $OUTPUT | perl -pe "s/(\/.*?${path}:)/\n    line /gm")"
#         error_message+="\n\n"
#         php_errors_found=true
#     fi
# done;

# if [ "$php_errors_found" = true ]; then
#     echo -e "\n${txtylw}${title} found issues in the following files:${txtrst}\n\n"
#     echo -e "${error_message}"
#     echo -e "${bldred}Please review and commit.${txtrst}\n"
#     exit 1
# fi

# exit 0
