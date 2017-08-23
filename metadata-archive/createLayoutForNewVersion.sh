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

# Create and load default config
DEFAULT_CONFIG_FILE=".createLayoutForNewVersion.conf.sh"
if [ ! -f "$DEFAULT_CONFIG_FILE" ] ; then
	echo '#!/bin/sh' > "$DEFAULT_CONFIG_FILE"
	echo 'DEFAULT_LANG="en-US"' >> "$DEFAULT_CONFIG_FILE"
	echo 'TARGET_LANGS="de-DE"' >> "$DEFAULT_CONFIG_FILE"
	echo 'LINK_LANGS="de-DE:de-AT;de-DE:de;en-US:en;"' >> "$DEFAULT_CONFIG_FILE"
	echo 'PUSH_TO_URL="git@github.com:user/repo.git"' >> "$DEFAULT_CONFIG_FILE"
	echo 'CREATE_EMPTY_FILES="false"' >> "$DEFAULT_CONFIG_FILE"
	echo "Default configuration created: $DEFAULT_CONFIG_FILE"
	exit
fi
source "$DEFAULT_CONFIG_FILE"

# Parse args
VNEW="${1%/}"
VOLD="${2%/}"
[ "$3" == "true" ] && CREATE_EMPTY_FILES="true"
[ -n "$4" ] && TARGET_LANGS="$DEFAULT_LANG,$4" || TARGET_LANGS="$DEFAULT_LANG,$TARGET_LANGS"

# Application vars
RCol='\e[0m' ; Pur='\e[0;35m'; Gre='\e[0;32m'; Red='\e[0;31m'; Mark="\xE2\x9C\x94"
firstrun="true"

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
		if [ "$firstrun" == "true" ] ; then
			[ ! -f "$VNEW/$targetlang/icon.png" ]           && ln -s "../../../metadata/icon.png"           "$VNEW/$targetlang/icon.png" >/dev/null 2>&1
        	[ ! -f "$VNEW/$targetlang/featureGraphic.png" ] && ln -s "../../../metadata/featureGraphic.png" "$VNEW/$targetlang/featureGraphic.png" >/dev/null 2>&1
        	[ ! -f "$VNEW/$targetlang/promoGraphic.png" ]   && ln -s "../../../metadata/promoGraphic.png"   "$VNEW/$targetlang/promoGraphic.png" >/dev/null 2>&1
			echo -e "$Gre$Mark Linked general files to $VNEW/$targetlang $RCol"
		fi

        if [ -d "$VOLD" ] ; then
            UP="\.\.\/"
            for i in "$VOLD/$targetlang/phoneScreenshots/"* ; do [ -f "$i" ] && ln -s "$(echo $i | sed "s/$VOLD/$UP$UP$UP$VOLD/")" "$(echo $i | sed "s/$VOLD/$VNEW/")" >/dev/null 2>&1 ;  done;
            for i in "$VOLD/$targetlang/sevenInchScreenshots/"* ; do [ -f "$i" ] && ln -s "$(echo $i | sed "s/$VOLD/$UP$UP$UP$VOLD/")" "$(echo $i | sed "s/$VOLD/$VNEW/")" >/dev/null 2>&1 ;  done;
            for i in "$VOLD/$targetlang/tenInchScreenshots/"* ; do [ -f "$i" ] && ln -s "$(echo $i | sed "s/$VOLD/$UP$UP$UP$VOLD/")" "$(echo $i | sed "s/$VOLD/$VNEW/")"  >/dev/null 2>&1 ;  done;
            for i in "$VOLD/$targetlang/"*.txt ; do [ -f "$i" ] && ln -s "$(echo $i | sed "s/$VOLD/$UP$UP$VOLD/")" "$(echo $i | sed "s/$VOLD/$VNEW/")"  >/dev/null 2>&1 ;  done;
            echo -e "$Gre$Mark Linked files from $VOLD to $VNEW/$targetlang $RCol"
        fi
		if [ "$CREATE_EMPTY_FILES" == "true" ] ; then
	        [ ! -f "$VNEW/$targetlang/short_description.txt" ] && touch "$VNEW/$targetlang/short_description.txt"
	        [ ! -f "$VNEW/$targetlang/full_description.txt" ] && touch "$VNEW/$targetlang/full_description.txt"
	        [ ! -f "$VNEW/$targetlang/title.txt" ] && touch "$VNEW/$targetlang/title.txt"
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

echo "# Convert symlinks to normal files"
echo "tmpdir=\`mktemp -d\`"
echo "cp -Lr $VNEW \$tmpdir/$VNEW"
echo "cd \$tmpdir/$VNEW"
echo 'echo "Contains a copy of the applications latest metadata" > README'
echo 'echo "This repositories data will always be replaced with the latest data" >> README'
echo 'echo "from the archive to save space and clone time." >> README'
for linkLang in $(echo $LINK_LANGS | tr ";" "\n") ; do
	src=`echo $linkLang | cut -d: -f1`
	tar=`echo $linkLang | cut -d: -f2`
	if [ -n "$src" -a -n "$tar" ] ; then
		echo ln -s "$src" "$tar"
	fi
done
echo "git init"
echo "git remote add origin $PUSH_TO_URL"
echo "git add ."
echo "git commit -am \"update to latest metadata - $VNEW\""
echo "git push --force --set-upstream origin master"
