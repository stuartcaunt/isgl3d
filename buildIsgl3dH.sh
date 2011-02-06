#!/bin/sh

export BASE_DIR=isgl3d

rm $BASE_DIR/isgl3d.h

echo "/*" > $BASE_DIR/isgl3d.h
echo " * iSGL3D: http://isgl3d.com" >> $BASE_DIR/isgl3d.h
echo " *" >> $BASE_DIR/isgl3d.h
echo " * Copyright (c) 2010-2011 Stuart Caunt" >> $BASE_DIR/isgl3d.h
echo " *" >> $BASE_DIR/isgl3d.h
echo " * Permission is hereby granted, free of charge, to any person obtaining a copy" >> $BASE_DIR/isgl3d.h
echo " * of this software and associated documentation files (the \"Software\"), to deal" >> $BASE_DIR/isgl3d.h
echo " * in the Software without restriction, including without limitation the rights" >> $BASE_DIR/isgl3d.h
echo " * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell" >> $BASE_DIR/isgl3d.h
echo " * copies of the Software, and to permit persons to whom the Software is" >> $BASE_DIR/isgl3d.h
echo " * furnished to do so, subject to the following conditions:" >> $BASE_DIR/isgl3d.h
echo " * " >> $BASE_DIR/isgl3d.h
echo " * The above copyright notice and this permission notice shall be included in" >> $BASE_DIR/isgl3d.h
echo " * all copies or substantial portions of the Software." >> $BASE_DIR/isgl3d.h
echo " * " >> $BASE_DIR/isgl3d.h
echo " * THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR" >> $BASE_DIR/isgl3d.h
echo " * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," >> $BASE_DIR/isgl3d.h
echo " * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE" >> $BASE_DIR/isgl3d.h
echo " * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER" >> $BASE_DIR/isgl3d.h
echo " * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM," >> $BASE_DIR/isgl3d.h
echo " * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN" >> $BASE_DIR/isgl3d.h
echo " * THE SOFTWARE." >> $BASE_DIR/isgl3d.h
echo " *" >> $BASE_DIR/isgl3d.h
echo " */" >> $BASE_DIR/isgl3d.h
echo "" >> $BASE_DIR/isgl3d.h

for file in $(find $BASE_DIR -name *.h -not -name isgl3d.h)
do

	newFile=$(echo $file | sed 's/isgl3d\///g')
	echo "#import \"$newFile\"" >> $BASE_DIR/isgl3d.h
done

