#!/bin/sh



export BASE_DIR=isgl3d
export FRAMEWORK_DIR=frameworks

echoHeader() {

	echo "/*" > $1
	echo " * iSGL3D: http://isgl3d.com" >> $1
	echo " *" >> $1
	echo " * Copyright (c) 2010-2011 Stuart Caunt" >> $1
	echo " *" >> $1
	echo " * Permission is hereby granted, free of charge, to any person obtaining a copy" >> $1
	echo " * of this software and associated documentation files (the \"Software\"), to deal" >> $1
	echo " * in the Software without restriction, including without limitation the rights" >> $1
	echo " * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell" >> $1
	echo " * copies of the Software, and to permit persons to whom the Software is" >> $1
	echo " * furnished to do so, subject to the following conditions:" >> $1
	echo " * " >> $1
	echo " * The above copyright notice and this permission notice shall be included in" >> $1
	echo " * all copies or substantial portions of the Software." >> $1
	echo " * " >> $1
	echo " * THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR" >> $1
	echo " * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," >> $1
	echo " * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE" >> $1
	echo " * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER" >> $1
	echo " * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM," >> $1
	echo " * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN" >> $1
	echo " * THE SOFTWARE." >> $1
	echo " *" >> $1
	echo " */" >> $1
	echo "" >> $1
}

rm $BASE_DIR/isgl3d.h
rm $BASE_DIR/isgl3d.m
rm $FRAMEWORK_DIR/isgl3d.h

# header 
echoHeader $BASE_DIR/isgl3d.h
for file in $(find $BASE_DIR -name *.h \
						-not -name isgl3d.h \
						-not -name Isgl3dPODImporter.h \
						)
do

	newFile=$(echo $file | sed 's/isgl3d\///g')
	echo "#import \"$newFile\"" >> $BASE_DIR/isgl3d.h
done


# isgl3d.m
echoHeader $BASE_DIR/isgl3d.m
echo "#import <Foundation/Foundation.h>" >> $BASE_DIR/isgl3d.m
echo "" >> $BASE_DIR/isgl3d.m
echo "static NSString * version = @\"iSGL3D v`cat Version`\";" >> $BASE_DIR/isgl3d.m
echo "" >> $BASE_DIR/isgl3d.m
echo "NSString * isgl3dVersion() {" >> $BASE_DIR/isgl3d.m
echo "	return version;" >> $BASE_DIR/isgl3d.m
echo "}" >> $BASE_DIR/isgl3d.m
echo "" >> $BASE_DIR/isgl3d.m

## framework isgl3d.h
#echoHeader $FRAMEWORK_DIR/isgl3d.h
#for file in $(find $BASE_DIR -name Isgl3d*.h -not -name isgl3d.h -not -name Isgl3dPODImporter.h)
#do
#
#	newFile=$(echo $file | sed 's!.*/!!')
#	echo "#import <isgl3d/$newFile>" >> $FRAMEWORK_DIR/isgl3d.h
#done

# Generate Xcode4 template library plist
./buildTemplatePlist.sh
