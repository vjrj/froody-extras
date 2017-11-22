#!/bin/bash
#
# ---------------------------------------------------------------------------- *
# Gregor Santner <gsantner.net> wrote this file. You can do whatever
# you want with this stuff. If we meet some day, and you think this stuff is
# worth it, you can buy me a coke in return. Provided as is without any kind
# of warranty. No attribution required.                  - Gregor Santner
#
# License: Creative Commons Zero (CC0 1.0)
#  http://creativecommons.org/publicdomain/zero/1.0/
# ----------------------------------------------------------------------------
#
export ROOTGRP="io.github.froodyapp";export ART="api"
export ROOTDIR="$(pwd)"

# Include buildToolsVersion too, optionally comment it out
export VERSION_BUILDTOOLS="// buildToolsVersion" 
export VERSION_GRADLE="4.1"
export VERSION_GRADLE_CLASSPATH="\$version_gradle_tools" # 3.0.0"
export VERSION_TARGETSDK="version_setup_targetSdk" # number possible too, e.g. 27
export VERSION_COMPILESDK="version_setup_compileSdk" # number possible too, e.g. 27


RCol='\e[0m' ; Blu='\e[0;34m';

buildCodegen() {
	echo -e "${Blu}Download/Build/Update swagger-codegen ${RCol}"
	cd "$ROOTDIR"
	[ ! -d "swagger-codegen" ] && git clone https://github.com/swagger-api/swagger-codegen.git
	cd swagger-codegen
	git pull
	[ ! -f "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar" ] && mvn clean package -DskipTests
}

generateFor(){
	echo -e "${Blu}Generating:: $SWGFILE ${RCol}"
	export PAC="$GRP.$ART";
	echo
	cd "$ROOTDIR/swagger-codegen"
	java -jar modules/swagger-codegen-cli/target/swagger-codegen-cli.jar generate \
		--api-package "$PAC.api" \
		--invoker-package "$PAC.invoker" \
		--model-package "$PAC.model"﻿ \
		-D groupId="$GRP" \
		-D artifactId="$ART" \
		-D hideGenerationTimestamp=true \
		-D serializableModel=true \
		-i "$SWGFILE" \
		-D dateLibrary=joda \
		-l java --library=okhttp-gson \
		-o "$TAR/"

	## Change some things
	cd "$TAR"
	rm -R "README.md" ".swagger-codegen"
	sed -i "s@#target = android@target = android@" gradle.properties
	sed -i "s@output\.outputFile = new File@// output.outputFile@" build.gradle
	#sed -i "s@gradle-2\.6@gradle-$VERSION_GRADLE@" gradle/wrapper/gradle-wrapper.properties
	sed -i "s@gradle-.*-bin@gradle-${VERSION_GRADLE}-bin@" gradle/wrapper/gradle-wrapper.properties
	sed -i "s@'com\.android\.tools\.build:gradle.*@\"com.android.tools.build:gradle:$VERSION_GRADLE_CLASSPATH\"@" build.gradle
	sed -i "s@buildToolsVersion .*@$VERSION_BUILDTOOLS@" build.gradle
	sed -i "s@compileSdkVersion ..@compileSdkVersion $VERSION_COMPILESDK@" build.gradle
	sed -i "s@targetSdkVersion ..@targetSdkVersion $VERSION_TARGETSDK@" build.gradle
	sed -i "s@jcenter()@jcenter() ; google() ;@" build.gradle
}

buildCodegen
cd "$ROOTDIR" ; rm -R "gen"
export GRP="$ROOTGRP"

export TAR="$ROOTDIR/gen/froody-api"
export SWGFILE="$ROOTDIR/swagger.yaml"
export ART="api"
#export GRP="$ROOTGRP.$ART"
generateFor

