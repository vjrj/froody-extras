#!/bin/bash
# Created by Gregor Santner <https://gsantner.github.io> 
# License of this script: CC0 1.0 Universal 
# 
# Create structure for the application-extras
#

mkdir -p metadata metadata-archive graphics/app_icon localization
touch {localization,metadata,metadata-archive}/.gitkeep
touch graphics/app_icon/app_icon_512.png
touch metadata/{promoGraphic.png,featureGraphic.png}
ln -s ../graphics/app_icon/app_icon_512.png metadata/icon.png
