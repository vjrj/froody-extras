#!/bin/bash
export GRP="io.github.froodyapp";export ART="api";export PAC="$GRP.$ART";
export SWGFILE="/home/$USER/aaDev/froody-extras/server/swagger.yaml"
export TAR="/tmp/SWAGGER_froody-android"

git clone https://github.com/swagger-api/swagger-codegen.git
cd swagger-codegen
git pull
[ ! -f "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar" ] && mvn clean package -DskipTests

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
sed -i "s/#target = android/target = android/" gradle.properties
rm -R "README.md" ".swagger-codegen"
