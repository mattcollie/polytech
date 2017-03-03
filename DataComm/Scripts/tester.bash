#!/bin/bash
# Tester is a script which will build any projects passed into it
# for testing to commence.
# Conventions https://github.com/danfruehauf/Scripts/tree/master/bash_scripting_conventions
# Written by Matt Collecutt <mattcollie@live.com>

# globals
declare -r TESTER_BUILD_OPTIONS=("rti" "callflow" "eziTracker" "web" "lib" "shared" "services")
declare -i TESTER_SKIP_FAILURES=0

# $1 - project to prepare to tests
tester() {
    local -r input=$1; shift
    local -i skip_failures=$1; shift
    let TESTER_SKIP_FAILURES=$skip_failures
    case "$input" in
        rti)
            source ~/.gitcustom/buildscripts/rti.bash
        ;;
        callflow)
            source ~/.gitcustom/buildscripts/callflow.bash
        ;;
        eziTracker)
            source ~/.gitcustom/buildscripts/eziTracker.bash
        ;;
        web)
            source ~/.gitcustom/buildscripts/web.bash
        ;;
        lib)
            source ~/.gitcustom/buildscripts/lib.bash
        ;;
        shared)
            source ~/.gitcustom/buildscripts/shared.bash
        ;;
        services)
            source ~/.gitcustom/buildscripts/services.bash
        ;;
        raglan)
            source ~/.gitcustom/buildscripts/raglan.bash
        ;;
    esac
}


# $@ - input directory for the build file
# <<returns the build file name and extention>>
_get_full_build_file_name_from_source() {
    local build_file="$@"
    echo "${build_file##*/}"
}

# $@ - input directory for the build file
# <<returns the build path>>
_get_source_path() {
    local build_file="$@"
    local build_file_name=${build_file%/*}
    echo "${build_file_name}"
}

# $1 - string to repeat
# $2 - number of times to repeat
# <<repeats the input string by the number of times inputed>>
_printf_repeat() {
 str=$1; shift
 num=$1; shift
 printf "%0.s${str}" $(seq 1 $num)
}

# $@ - piped data from the nant build script
# <<validates the build output and stops process if failure occurred>>
_build_validation() {
    export IFS=
    local -i build_failed=0
    while read -r data; do
        if [[ "$data" == *"BUILD FAILED"* ]]; then
            let build_failed=1
        fi
        
        echo "$data"
        
        if [[ $build_failed == 1 && "$data" == *"Total time"* ]]; then
            local -r children_pid_regex=`ps | grep -P "[0-9] {3,4}$$ {3,4}[0-9]" | grep -P -o "^ {1,6}[0-9]{1,5}" | grep -P -o "[0-9]{1,5}"`
                
            for pid in $children_pid_regex; do
                #kill -SIGKILL $pid > /dev/null
                exit 1
            done
        fi
    done
}

# $@ - projects to build
# <<builds all projects>>
tester_build_projects() {
    for project in ${@}; do
        local build_scripts=`find $project -type f -name "*.build"`
        local awkscript='{ '"${COLOUR_CONFIG_SETUP[*]}"' print }'
        
        for script in $build_scripts; do
            local build_script_name="$(_get_full_build_file_name_from_source $script)"
            local build_script_path="$(_get_source_path $script)"
            local -i length=${#build_script_path}-${#build_script_name}
            echo "╔═══════════$(_printf_repeat "═" ${#build_script_path})═╗" | awk "${awkscript}"
            echo "║ Building: ${build_script_name}$(_printf_repeat " " ${length}) ║" | awk "${awkscript}"
            echo "║ Location: ${build_script_path} ║" | awk "${awkscript}"
            echo "╚═══════════$(_printf_repeat "═" ${#build_script_path})═╝" | awk "${awkscript}"
            nant -buildfile:"${script}" | _build_validation | awk "${awkscript}"
            if [[ ${PIPESTATUS[0]} == 1 ]]; then
                local custawk='{ '"${CUSTOM_COLOUR_SETUP[*]}"' print }'
                if [[ $TESTER_SKIP_FAILURES == 1 ]]; then
                    echo "╔══════════════════════════════════╗" | awk "${custawk}"
                    echo "║ WARNING BUILD FAILED SKIPPING... ║" | awk "${custawk}"
                    echo "╚══════════════════════════════════╝" | awk "${custawk}"
                    break
                else
                    echo "╔══════════════════════╗" | awk "${custawk}"
                    echo "║ WARNING BUILD FAILED ║" | awk "${custawk}"
                    echo "╚══════════════════════╝" | awk "${custawk}"
                    return 0
                fi
            fi
        done
    done
}
