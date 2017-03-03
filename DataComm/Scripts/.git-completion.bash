#!/bin/bash
# Helper: http://www.linuxjournal.com/content/more-using-bash-complete-command
_build()
{
	local cmd="${1##*/}"
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local line="${COMP_LINE}"
	local xpat=""

	# Check to see what command is being executed.
	case "$cmd" in 
	build2)	
		case "$line" in
			*-l*)
				xpat="${BUILD_FILE_OPTIONS_LIB[*]} -all"
			;;
			*-s*)
				xpat="${BUILD_FILE_OPTIONS_SHARED[*]} -all"
			;;
			*-w*)
				xpat="${BUILD_FILE_OPTIONS_WEB[*]} -all"
			;;
			*-a*)
				xpat=""
			;;
			*)
				xpat="${BUILD_FOLDER_OPTIONS[*]}"
			;;
		esac
		;;
	esac

	COMPREPLY=( $(compgen -W "${xpat}" -- $cur) )
}

_apkhelper()
{
	local cmd="${1##*/}"
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local line="${COMP_LINE}"
	local xpat=""

	case "$cmd" in 
	apk)	
		case "$line" in
			*install*)
				xpat="${APK_FILE_OPTIONS[*]} "
			;;
			*)
				xpat="${APK_OPTIONS[*]}"
			;;
		esac
		;;
	esac

	COMPREPLY=( $(compgen -W "${xpat}" -- $cur) )
}

_test()
{
	local -r cmd="${1##*/}"
	local -r cur="${COMP_WORDS[COMP_CWORD]}"
	local -r line="${COMP_LINE}"
	local xpat=""

	# Check to see what command is being executed.
	case "$cmd" in 
	build)	
		case "$line" in
			*)
				xpat="${TESTER_BUILD_OPTIONS[*]}"
			;;
		esac
		;;
	esac

	COMPREPLY=( $(compgen -W "${xpat}" -- $cur) )
}


complete -F _build build2
complete -F _apkhelper apk
complete -F _test build