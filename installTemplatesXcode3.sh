# Credits and thanks for this installation script go to cocos2d-iphone (Ricardo Quesada)
#
# The original template installation script can be found in the cocos2d-iphone distribution (http://www.cocos2d-iphone.org/)
#
# Modifications have been made to install the iSGL3D sources and template files.

#!/bin/bash

echo 'iSGL3D template installer'

ISGL3D_VERSION=$(echo iSGL3D v`cat Version`)
BASE_TEMPLATE_DIR="/Library/Application Support/Developer/Shared/Xcode"
BASE_TEMPLATE_USER_DIR="$HOME/Library/Application Support/Developer/Shared/Xcode"

force=
user_dir=

usage(){
cat << EOF
usage: $0 [options]
 
Install / update templates for ${ISGL3D_VERSION}
 
OPTIONS:
   -f	force overwrite if directories exist
   -h	this help
   -u	install in user's Library directory instead of global directory
EOF
}

while getopts "fhu" OPTION; do
	case "$OPTION" in
		f)
			force=1
			;;
		h)
			usage
			exit 0
			;;
		u)
			user_dir=1
			;;
	esac
done

# Make sure only root can run our script
if [[ ! $user_dir  && "$(id -u)" != "0" ]]; then
	echo ""
	echo "Error: This script must be run as root in order to copy templates to ${BASE_TEMPLATE_DIR}" 1>&2
	echo ""
	echo "Try running it with 'sudo', or with '-u' to install it only you:" 1>&2
	echo "   sudo $0" 1>&2
	echo "or:" 1>&2
	echo "   $0 -u" 1>&2   
exit 1
fi


copy_files(){
	rsync -r --exclude=.svn "$1" "$2"
}

check_dst_dir(){
	if [[ -d $DST_DIR ]];  then
		if [[ $force ]]; then
			echo "removing old libraries: ${DST_DIR}"
			rm -rf $DST_DIR
		else
			echo "templates already installed. To force a re-install use the '-f' parameter"
			exit 1
		fi
	fi
	
	echo ...creating destination directory: $DST_DIR
	mkdir -p "$DST_DIR"
}

copy_base_files(){
	echo ...copying iSGL3D files
	copy_files isgl3d "$DST_DIR"libs
	echo ...copying external files
	copy_files external/PowerVR "$DST_DIR"external
	echo ...copying iSGL3D shaders
	copy_files Resources/Shaders "$DST_DIR"Resources

}

print_template_banner(){
	echo ''
	echo ''
	echo ''
	echo "$1"
	echo '----------------------------------------------------'
	echo ''
}

# copies project-based templates
copy_project_templates(){
		if [[ $user_dir ]]; then
		TEMPLATE_DIR="${BASE_TEMPLATE_USER_DIR}/Project Templates/${ISGL3D_VERSION}/"
	else
		TEMPLATE_DIR="${BASE_TEMPLATE_DIR}/Project Templates/${ISGL3D_VERSION}/"
	fi

	if [[ ! -d "$TEMPLATE_DIR" ]]; then
		echo '...creating iSGL3D template directory'
		echo ''
		mkdir -p "$TEMPLATE_DIR"
	fi

	print_template_banner "Installing iSGL3D templates for Xcode 3"

	DST_DIR="$TEMPLATE_DIR""iSGL3D Application/"

	check_dst_dir

	echo ...copying template files
	copy_files templates/xcode3/isgl3d_app/ "$DST_DIR"

	copy_base_files

	echo done!





}

copy_project_templates

