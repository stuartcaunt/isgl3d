/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * This file makes the GLKit math functions available for iSGL3D and iOS 4.x.
 * Some of the code is based on the Apple GLKit implementations.
 *
 */
 
 #import "Isgl3dMathUtils.h"
 
#if !(defined(__STRICT_ANSI__)) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0)


#else

#import "Isgl3dVector3.h"
#import "Isgl3dVector4.h"
#import "Isgl3dMatrix3.h"
#import "Isgl3dMatrix4.h"


Isgl3dVector3 Isgl3dMathProject(Isgl3dVector3 object, Isgl3dMatrix4 model, Isgl3dMatrix4 projection, int *viewport)
{
    Isgl3dVector4 vector = Isgl3dVector4MakeWithVector3(object, 1.0f);
    
    vector = Isgl3dMatrix4MultiplyVector4(model, vector);
    vector = Isgl3dMatrix4MultiplyVector4(projection, vector);
    
    if (vector.w == 0.0f)
        return Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
    
    vector = Isgl3dVector4DivideScalar(vector, vector.w);
    
    vector.x = (vector.x + 1.0f) * (float)viewport[2];
    vector.y = (vector.y + 1.0f) * (float)viewport[3];
    vector.z = (vector.z + 1.0f);
    vector = Isgl3dVector4MultiplyScalar(vector, 0.5f);
    
    vector.x += (float)viewport[0];
    vector.y += (float)viewport[1];
    
    return Isgl3dVector3MakeWithArray(vector.v);
}

Isgl3dVector3 Isgl3dMathUnproject(Isgl3dVector3 window, Isgl3dMatrix4 model, Isgl3dMatrix4 projection, int *viewport, bool *success)
{
    bool _success;
    Isgl3dVector4 vector;
    Isgl3dMatrix4 matrix = Isgl3dMatrix4Invert(Isgl3dMatrix4Multiply(projection, model), &_success);
    
    if (_success == false) {
        if (success)
            *success = _success;
        return Isgl3dVector3MakeWithArray(vector.v);
    }
    
    vector.x = ((window.x - (float)viewport[0]) / (float)viewport[2]);
    vector.y = ((window.y - (float)viewport[1]) / (float)viewport[3]);
    vector.z = window.z;
    vector.w = 1.0f;
    
    vector = Isgl3dVector4MultiplyScalar(vector, 2.0f);
    vector = Isgl3dVector4SubtractScalar(vector, 1.0f);
    
    vector = Isgl3dMatrix4MultiplyVector4(matrix, vector);
    if (vector.z == 0.0f) {
        if (success)
            *success = false;
        return Isgl3dVector3MakeWithArray(vector.v);
    }
    
    vector = Isgl3dVector4DivideScalar(vector, vector.w);
    
    return Isgl3dVector3MakeWithArray(vector.v);
}

#ifdef __OBJC__
NSString * NSStringFromIsgl3dMatrix2(Isgl3dMatrix2 matrix)
{
    return [NSString stringWithFormat:@"{%g, %g}, {%g, %g}",
            matrix.m00, matrix.m01, matrix.m10, matrix.m11];
}

NSString * NSStringFromIsgl3dMatrix3(Isgl3dMatrix3 matrix)
{
    return [NSString stringWithFormat:@"{%g, %g, %g}, {%g, %g, %g}, {%g, %g, %g}",
            matrix.m00, matrix.m01, matrix.m02,
            matrix.m10, matrix.m11, matrix.m12,
            matrix.m20, matrix.m21, matrix.m22];
}

NSString * NSStringFromIsgl3dMatrix4(Isgl3dMatrix4 matrix)
{
    return [NSString stringWithFormat:@"{%g, %g, %g, %g}, {%g, %g, %g, %g}, {%g, %g, %g, %g}, {%g, %g, %g, %g}",
            matrix.m00, matrix.m01, matrix.m02, matrix.m03,
            matrix.m10, matrix.m11, matrix.m12, matrix.m13,
            matrix.m20, matrix.m21, matrix.m22, matrix.m23,
            matrix.m30, matrix.m31, matrix.m32, matrix.m33];
}

NSString * NSStringFromIsgl3dVector2(Isgl3dVector2 vector)
{
    return [NSString stringWithFormat:@"{%g, %g}",
            vector.x, vector.y];
}

NSString * NSStringFromIsgl3dVector3(Isgl3dVector3 vector)
{
    return [NSString stringWithFormat:@"{%g, %g, %g}",
            vector.x, vector.y, vector.z];
}

NSString * NSStringFromIsgl3dVector4(Isgl3dVector4 vector)
{
    return [NSString stringWithFormat:@"{%g, %g, %g, %g}",
            vector.x, vector.y, vector.z, vector.w];
}

//NSString * NSStringFromIsgl3dQuaternion(Isgl3dQuaternion quaternion)
//{
//    return @"";
//}
#endif


#endif
