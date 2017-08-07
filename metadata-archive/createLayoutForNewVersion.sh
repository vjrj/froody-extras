#!/bin/sh
# Created by Gregor Santner <https://gsantner.github.io>
# License of this script: CC0 1.0 Universal
#
# Arguments:
#   $1: Create a metadata folder for this version (example:  v1.0.13)
#   $2: Symlink metadata from this folder if not existing
#   $3: Pass "true" if empty metadata textfiles should be created (description, name, summary)
#   $4: Comma seperated list of languages the process should happen for

[ -z "$1" ] && echo "Exit: Bad arguments" && exit

# Default config
DEFAULT_LANG="en"
TARGET_LANGS="de"
PUSH_TO_URL="git@github.com:froodyapp/froody-metadata-latest.git"
CREATE_EMPTY_FILES="false"

# Parse args
VNEW="${1%/}"
VOLD="${2%/}"
[ "$3" == "true" ] && CREATE_EMPTY_FILES="true"
[ -n "$4" ] && TARGET_LANGS="$DEFAULT_LANG,$4" || TARGET_LANGS="$DEFAULT_LANG,$TARGET_LANGS"

# Application vars
RCol='\e[0m' ; Pur='\e[0;35m'; Gre='\e[0;32m'; Red='\e[0;31m'; Mark="\xE2\x9C\x94"

# Run
for targetlang in $(echo $TARGET_LANGS | sed "s/,/ /g") ; do
	# Create file & folder structure
	if [ ! -d "$VNEW/$targetlang" ] ; then
        mkdir -p "$VNEW/$targetlang/phoneScreenshots"
        mkdir -p "$VNEW/$targetlang/sevenInchScreenshots"
        mkdir -p "$VNEW/$targetlang/tenInchScreenshots"
        echo -e "$Gre$Mark Created structure of $VNEW/$targetlang $RCol"
    fi

	# Link existing files
    if [ -d "$VNEW" ] ; then
		# Link default
        [ ! -f "$VNEW/$targetlang/icon.png" ]           && ln -s "../../../metadata/icon.png"           "$VNEW/$targetlang/icon.png" >/dev/null 2>&1
        [ ! -f "$VNEW/$targetlang/featureGraphic.png" ] && ln -s "../../../metadata/featureGraphic.png" "$VNEW/$targetlang/featureGraphic.png" >/dev/null 2>&1
        [ ! -f "$VNEW/$targetlang/promoGraphic.png" ]   && ln -s "../../../metadata/promoGraphic.png"   "$VNEW/$targetlang/promoGraphic.png" >/dev/null 2>&1
		echo -e "$Gre$Mark Linked general files to $VNEW/$targetlang $RCol"

        if [ -d "$VOLD" ] ; then
            UP="\.\.\/"
            for i in "$VOLD/$targetlang/phoneScreenshots/"* ; do [ -f "$i" ] && ln -s "$(echo $i | sed "s/$VOLD/$UP$UP$UP$VOLD/")" "$(echo $i | sed "s/$VOLD/$VNEW/")" >/dev/null 2>&1 ;  done;
            for i in "$VOLD/$targetlang/sevenInchScreenshots/"* ; do [ -f "$i" ] && ln -s "$(echo $i | sed "s/$VOLD/$UP$UP$UP$VOLD/")" "$(echo $i | sed "s/$VOLD/$VNEW/")" >/dev/null 2>&1 ;  done;
            for i in "$VOLD/$targetlang/tenInchScreenshots/"* ; do [ -f "$i" ] && ln -s "$(echo $i | sed "s/$VOLD/$UP$UP$UP$VOLD/")" "$(echo $i | sed "s/$VOLD/$VNEW/")"  >/dev/null 2>&1 ;  done;
            for i in "$VOLD/$targetlang/"*.txt ; do [ -f "$i" ] && ln -s "$(echo $i | sed "s/$VOLD/$UP$UP$VOLD/")" "$(echo $i | sed "s/$VOLD/$VNEW/")"  >/dev/null 2>&1 ;  done;
            echo -e "$Gre$Mark Linked files from $VOLD to $VNEW/$targetlang $RCol"
        fi
		if [ "$CREATE_EMPTY_FILES" == "true" ] ; then
	        [ ! -f "$VNEW/$targetlang/summary.txt" ] && touch "$VNEW/$targetlang/summary.txt"
	        [ ! -f "$VNEW/$targetlang/description.txt" ] && touch "$VNEW/$targetlang/description.txt"
	        [ ! -f "$VNEW/$targetlang/name.txt" ] && touch "$VNEW/$targetlang/name.txt"
		fi
         #[ -f "$VNEW/$DEFAULT_LANG/promoGraphic.png" -a ! -f "$VNEW/$targetlang/promoGraphic.png" ] && ln -s "../$DEFAULT_LANG/promoGraphic.png" "$VNEW/$targetlang/promoGraphic.png"
    fi
    firstrun="nope"
done

echo "Notes:"
echo "  featureGraphic.png   --> 1024 x  500"
echo "  promoGraphic.png     --> 180  x  120"
echo "  icon                 --> 512  x  512"
echo ""

echo "F-Droid: "
echo "  https://eighthave.gitlab.io/fdroid-website/docs/All_About_Descriptions_Graphics_and_Screenshots/"
echo "  https://gitlab.com/fdroid/fdroidclient/blob/master/app/src/main/java/org/fdroid/fdroid/data/App.java#L398"
echo "  https://gitlab.com/fdroid/fdroidserver/blob/master/fdroidserver/update.py#L776"
echo ""

echo "Convert symlinks to normal files"
echo "cp -Lr $VNEW /tmp/$VNEW"
echo "cd /tmp/$VNEW"
echo "git init"
echo "git remote add origin $PUSH_TO_URL"
echo "git add ."
echo "git commit -am 'update screens'"
echo "git push --force --set-upstream origin master"
