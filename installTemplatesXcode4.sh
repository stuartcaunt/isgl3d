#!/bin/sh

ISGL3D_VERSION="iSGL3D v`cat Version`"

BASE_DIR=isgl3d
POWERVR_DIR=external/PowerVR
LIBS_DIR=libs

TEMPLATES_DIR_SRC=templates/xcode4
TEMPLATES_DIR_DEST=~/Library/Developer/Xcode/Templates

BASE_TEMPLATE_DIR=iSGL3D\ Base.xctemplate
APPLICATION_TEMPLATE_DIR=iSGL3D\ Application.xctemplate
LIBRARY_TEMPLATE_DIR=iSGL3D\ Library.xctemplate

force=

usage(){
cat << EOF
usage: $0 [options]
 
Install / update templates for ${ISGL3D_VERSION}
 
OPTIONS:
   -f	force overwrite if directories exist
   -h	this help
EOF
}

while getopts "fh" OPTION; do
	case "$OPTION" in
		f)
			force=1
			;;
		h)
			usage
			exit 0
			;;
	esac
done


copy_files() {
	rsync -r --exclude=.svn "$1" "$2"
}


check_rm_dir() {
	if [[ -d "$1" ]];  then
		if [[ $force ]]; then
			echo "deleting existing templates: $1" | sed "s|$HOME|~|"
			rm -rf "$1"
		else
			echo "templates already installed. To force a re-install use the '-f' parameter"
			exit 1
		fi
	fi
}

echo ""
echo ""
echo "Installing ${ISGL3D_VERSION} templates for Xcode 4" 
echo "----------------------------------------------"
echo ""

# Delete all previous iSGL3D templates
check_rm_dir "$TEMPLATES_DIR_DEST/$BASE_TEMPLATE_DIR"
check_rm_dir "$TEMPLATES_DIR_DEST/$APPLICATION_TEMPLATE_DIR"
check_rm_dir "$TEMPLATES_DIR_DEST/$LIBRARY_TEMPLATE_DIR"

# copy templates
echo ...copying template files
copy_files "$TEMPLATES_DIR_SRC/$BASE_TEMPLATE_DIR" "$TEMPLATES_DIR_DEST"
copy_files "$TEMPLATES_DIR_SRC/$APPLICATION_TEMPLATE_DIR" "$TEMPLATES_DIR_DEST"
copy_files "$TEMPLATES_DIR_SRC/$LIBRARY_TEMPLATE_DIR" "$TEMPLATES_DIR_DEST"

# copy shader files
echo ...copying shader files
copy_files Resources/Shaders "$TEMPLATES_DIR_DEST/$BASE_TEMPLATE_DIR/Resources"

# copy library files
echo ...copying library files
copy_files $BASE_DIR "$TEMPLATES_DIR_DEST/$LIBRARY_TEMPLATE_DIR/$LIBS_DIR"

# copy library files
echo ...copying external files
copy_files $POWERVR_DIR "$TEMPLATES_DIR_DEST/$LIBRARY_TEMPLATE_DIR"/external

echo done!