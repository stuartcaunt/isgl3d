#!/bin/sh



export BASE_DIR=isgl3d

generate_file_for_plist() {
	echo "		<key>$1/$2</key>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "		<dict>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "			<key>Group</key>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "			<array>" >> "$LIBRARY_TEMPLATE_PLIST"
	
	path=`dirname $1/$2`
	directory=${path%%/*}
	while [ $directory != $path ]
	do
		echo "				<string>$directory</string>" >> "$LIBRARY_TEMPLATE_PLIST"
		path=${path#*/}
		directory=${path%%/*}
	done
	
	echo "				<string>$path</string>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "			</array>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "			<key>Path</key>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "			<string>$1/$2</string>" >> "$LIBRARY_TEMPLATE_PLIST"
	
	extension=${2##*.}
	hExt="h"	
	if [ $extension == $hExt ];
	then
		echo "			<key>TargetIndices</key>" >> "$LIBRARY_TEMPLATE_PLIST"
		echo "			<array/>" >> "$LIBRARY_TEMPLATE_PLIST"
	fi
	
	echo "		</dict>" >> "$LIBRARY_TEMPLATE_PLIST"
}


generate_library_plist() {
	TEMPLATES_DIR_SRC=templates/xcode4
	LIBRARY_TEMPLATE_DIR=iSGL3D\ Library.xctemplate
	LIBRARY_TEMPLATE_PLIST=$TEMPLATES_DIR_SRC/$LIBRARY_TEMPLATE_DIR/TemplateInfo.plist
	LIBS_DIR=libs
	EXTERNAL_DIR=external
	POWERVR_DIR=external/PowerVR

	echo "<?xml version="1.0" encoding="UTF-8"?>" > "$LIBRARY_TEMPLATE_PLIST"
	echo "<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "<plist version="1.0">" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "<dict>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "	<key>Identifier</key>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "	<string>com.isgl3d.library</string>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "	<key>Kind</key>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "	<string>Xcode.Xcode3.ProjectTemplateUnitKind</string>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "	<key>Definitions</key>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "	<dict>" >> "$LIBRARY_TEMPLATE_PLIST"
	
	
	for file in $(find $BASE_DIR -name *.h -or -name *.m -or -name *.c -or -name *.mm)
	do
		generate_file_for_plist $LIBS_DIR $file
	done
	
	for file in $(find $POWERVR_DIR -name *.h -or -name *.m -or -name *.c -or -name *.mm -or -name *.cpp)
	do
		file2=$(echo $file | sed "s|$POWERVR_DIR/||")
		generate_file_for_plist $POWERVR_DIR $file2 
	done
	
	echo "	</dict>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "	<key>Nodes</key>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "	<array>" >> "$LIBRARY_TEMPLATE_PLIST"
	
	for file in $(find $BASE_DIR -name *.h -or -name *.m -or -name *.c -or -name *.mm)
	do
		echo "		<string>$LIBS_DIR/$file</string>" >> "$LIBRARY_TEMPLATE_PLIST"
	done

	for file in $(find $POWERVR_DIR -name *.h -or -name *.m -or -name *.c -or -name *.mm -or -name *.cpp)
	do
		echo "		<string>$file</string>" >> "$LIBRARY_TEMPLATE_PLIST"
	done
	
	
	echo "	</array>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "</dict>" >> "$LIBRARY_TEMPLATE_PLIST"
	echo "</plist>" >> "$LIBRARY_TEMPLATE_PLIST"
}


# Generate Xcode4 template library plist
generate_library_plist
