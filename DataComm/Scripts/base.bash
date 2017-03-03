#!/bin/bash
# Matt Collecutt
# Hub for loading of all custom items for git
# Conventions https://github.com/danfruehauf/Scripts/tree/master/bash_scripting_conventions

declare HOME_PATH=`pwd`
declare CUSTOM_COLOUR_SETUP=()
declare CUSTOM_RECOLOUR=()

build_colours() {

	# Regular Colors
	declare -r Black='\033[0;30m'        # Black
	declare -r Red='\033[0;31m'          # Red
	declare -r Green='\033[0;32m'        # Green
	declare -r Yellow='\033[0;33m'       # Yellow
	declare -r Blue='\033[0;34m'         # Blue
	declare -r Purple='\033[0;35m'       # Purple
	declare -r Cyan='\033[0;36m'         # Cyan
	declare -r White='\033[0;37m'        # White
    
	# Bold
	declare -r BBlack='\033[1;30m'       # Black
	declare -r BRed='\033[1;31m'         # Red
	declare -r BGreen='\033[1;32m'       # Green
	declare -r BYellow='\033[1;33m'      # Yellow
	declare -r BBlue='\033[1;34m'        # Blue
	declare -r BPurple='\033[1;35m'      # Purple
	declare -r BCyan='\033[1;36m'        # Cyan
	declare -r BWhite='\033[1;37m'       # White

	# Underline
	declare -r UBlack='\033[4;30m'       # Black
	declare -r URed='\033[4;31m'         # Red
	declare -r UGreen='\033[4;32m'       # Green
	declare -r UYellow='\033[4;33m'      # Yellow
	declare -r UBlue='\033[4;34m'        # Blue
	declare -r UPurple='\033[4;35m'      # Purple
	declare -r UCyan='\033[4;36m'        # Cyan
	declare -r UWhite='\033[4;37m'       # White
    
	# Background
	declare -r On_Black='\033[1;40m'     # Black
	declare -r On_Red='\033[1;41m'       # Red
	declare -r On_Green='\033[1;42m'     # Green
	declare -r On_Yellow='\033[1;43m'    # Yellow
	declare -r On_Blue='\033[1;44m'      # Blue
	declare -r On_Purple='\033[1;45m'    # Purple
	declare -r On_Cyan='\033[1;46m'      # Cyan
	declare -r On_White='\033[1;47m'     # White
    
	# High Intensity
	declare -r IBlack='\033[0;90m'       # Black
	declare -r IRed='\033[0;91m'         # Red
	declare -r IGreen='\033[0;92m'       # Green
	declare -r IYellow='\033[0;93m'      # Yellow
	declare -r IBlue='\033[0;94m'        # Blue
	declare -r IPurple='\033[0;95m'      # Purple
	declare -r ICyan='\033[0;96m'        # Cyan
	declare -r IWhite='\033[0;97m'       # White
    
	# Bold High Intensity
	declare -r BIBlack='\033[1;90m'      # Black
	declare -r BIRed='\033[1;91m'        # Red
	declare -r BIGreen='\033[1;92m'      # Green
	declare -r BIYellow='\033[1;93m'     # Yellow
	declare -r BIBlue='\033[1;94m'       # Blue
	declare -r BIPurple='\033[1;95m'     # Purple
	declare -r BICyan='\033[1;96m'       # Cyan
	declare -r BIWhite='\033[1;97m'      # White
    
	# High Intensity backgrounds
	declare -r On_IBlack='\033[0;100m'   # Black
	declare -r On_IRed='\033[0;101m'     # Red
	declare -r On_IGreen='\033[0;102m'   # Green
	declare -r On_IYellow='\033[0;103m'  # Yellow
	declare -r On_IBlue='\033[0;104m'    # Blue
	declare -r On_IPurple='\033[0;105m'  # Purple
	declare -r On_ICyan='\033[0;106m'    # Cyan
	declare -r On_IWhite='\033[0;107m'   # White
		
	# load config
	source ~/buildconfig.cfg
	
	local -i i=0
	while [ $i -lt ${#CUSTOM_RECOLOUR[@]} ]; do
		CUSTOM_COLOUR_SETUP+=('gsub("'"${CUSTOM_RECOLOUR[$i]}"'", "'"${CUSTOM_RECOLOUR[$((i+=1))]}"'&\033[0m");')
		let i=i+=1
	done
	
	# build array for colours
	let i=0
	while [ $i -lt ${#TEXT_TO_RECOLOUR[@]} ]; do
		COLOUR_CONFIG_SETUP+=('gsub("'"${TEXT_TO_RECOLOUR[$i]}"'", "'"${TEXT_TO_RECOLOUR[$((i+=1))]}"'&\033[0m");')
		let i=i+=1
	done
	
}

build_colours

if [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

cd $HOME_PATH

__6837475409_rebuild() {
	build_colours
}

rebuild() {
	echo "Rebuilding..."
	__6837475409_rebuild
	echo "Rebuilt..."

	return
}