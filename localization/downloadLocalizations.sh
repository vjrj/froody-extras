#!/bin/bash
#########################################################
#
#   Title
#
#   Created by Gregor Santer (gsantner), 2016
#   http://gsantner.net/
#
#########################################################


#Pfade
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTFILE=$(readlink -f $0)
SCRIPTPATH=$(dirname $SCRIPTFILE)
argc=$#

#########################################################
cd "$SCRIPTDIR"
APPFOLDER="../../froody-android"
[ -n "$1" ] && APPFOLDER="$1"
if [ ! -f "crowdin.yaml" ] ; then
	echo "project_identifier: froodyapp" > 'crowdin.yaml'
	echo "base_path: $(realpath '../../froody-android')" >>'crowdin.yaml'
	echo "api_key: DONT_PUSH_API_KEY" >>'crowdin.yaml'
	cat  "$APPFOLDER/crowdin.yaml" >> "crowdin.yaml"
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

# Delete empty translation files
cd "$APPFOLDER/app/src/main/res"
find . -name 'strings*.xml' | while read line; do
	if ! grep -q "<string" "$line" ; then
		echo -e "\e[0;31m[Empty] \e[0m Deleting $(echo $line | cut -d/ -f2-)"
		rm "$line"
	fi
done

# Fix some export errors..
dir="values-kab-rKAB" && [ -d "$dir" ] && mv "$dir" "values-kab"


# Show git diff
(
	printf "\nPress any key to show git diff (q to exit):"
	read -n 1
	[ "$REPLY" == "q" ] && printf "\n" && exit
	cd "$APPFOLDER"
	git diff
)
