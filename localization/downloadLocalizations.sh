#!/bin/bash
#########################################################
#
#   Title
#
#   Created by Gregor Santer (gsantner), 2016
#   https://gsantner.github.io/
#
#########################################################


#Pfade
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTFILE=$(readlink -f $0)
SCRIPTPATH=$(dirname $SCRIPTFILE)
argc=$#

#########################################################
cd "$SCRIPTDIR"
DEFAULT_PATH_TO_FROODYANDROID="../../froody-android"
[ -z $1 ] && DEFAULT_PATH_TO_FROODYANDROID="$1"

if [ ! -f "crowdin.yaml" ] ; then
	echo "project_identifier: froodyapp" > 'crowdin.yaml'
	echo "base_path: $(realpath '../../froody-android')" >>'crowdin.yaml'
	echo "api_key: DONT_PUSH_API_KEY" >>'crowdin.yaml'
	cat  "$DEFAULT_PATH_TO_FROODYANDROID/crowdin.yaml" >> "crowdin.yaml"
	echo "# Add all non locality languages here" >> "crowdin.yaml"
	echo "# (e.g. enUS, enUK, deCH, deAT will automatically go into the right folder)" >> "crowdin.yaml"
	echo "# Otherwise e.g.  en would get added into the folder enEN (which is wrong)." >> "crowdin.yaml"
	echo "# https://crowdin.com/page/api/language-codes contains supported language codes" >> "crowdin.yaml"
	echo "# The first listed ones here are diffently managed by crowdin than on android" >> "crowdin.yaml"
fi

if grep -q "DONT_PUSH" "crowdin.yaml" ; then
	echo "Insert API key to crowdin.yaml"
	echo "and update folder to the root folder of the repository"
	exit
fi

# Check if Crowdin CLI is installed
type crowdin-cli  > /dev/null 2>&1 || bash -c 'echo "Crowdin CLI is not installed. Running gem install crowdin-cli:" ; gem install crowdin-cli'

# Load latest translations
crowdin-cli download -b master

# Show git diff
(
	printf "\nPress any key to show git diff (q to exit):"
	read -n 1
	[ "$REPLY" == "q" ] && printf "\n" && exit
	cd "$DEFAULT_PATH_TO_FROODYANDROID"
	git diff
)
