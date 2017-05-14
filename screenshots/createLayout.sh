#!/bin/sh

if [ ! -d "$1" ] ; then
	mkdir -p "$1/de/phoneScreenshots"
	mkdir -p "$1/de/sevenInchScreenshots"
	mkdir -p "$1/de/tenInchScreenshots"
	mkdir -p "$1/en/phoneScreenshots"
	mkdir -p "$1/en/sevenInchScreenshots"
	mkdir -p "$1/en/tenInchScreenshots"
else
	[ ! -f "$1/de/icon.png" ] && ln -s "../../../graphics/app_icon/app_icon_512.png" "$1/de/icon.png"
	[ ! -f "$1/en/icon.png" ] && ln -s "../../../graphics/app_icon/app_icon_512.png" "$1/en/icon.png"
	[ ! -f "$1/de/featureGraphic.png" ] && ln -s "../../../graphics/app_icon/featureGraphic.png" "$1/de/featureGraphic.png"
	[ ! -f "$1/en/featureGraphic.png" ] && ln -s "../../../graphics/app_icon/featureGraphic.png" "$1/en/featureGraphic.png"
	[ ! -f "$1/de/promoGraphic.png" ] && ln -s "../../../graphics/app_icon/promoGraphic.png" "$1/de/promoGraphic.png"
	[ ! -f "$1/en/promoGraphic.png" ] && ln -s "../../../graphics/app_icon/promoGraphic.png" "$1/en/promoGraphic.png"

	#[ -f "$1/en/promoGraphic.png" -a ! -f "$1/de/promoGraphic.png" ] && ln -s "../en/promoGraphic.png" "$1/de/promoGraphic.png"
fi

echo "notes:"
echo "  featureGraphic.png   --> 1024x500"
echo "  promoGraphic.png     --> 180x120"
echo "  icon                 --> 512x512"

echo ""
echo "Convert symlinks to normal files"
echo "cp -Lr $1 /tmp/$1"
echo "cd /tmp/$1"
echo "git init"
echo "git remote add origin git@github.com:froodyapp/froody-screens-latest.git"
echo "git add ."
echo "git commit -am 'update screens'"
echo "git push --force --set-upstream origin master"



# F-Droid: https://eighthave.gitlab.io/fdroid-website/docs/All_About_Descriptions_Graphics_and_Screenshots/
