/******************************************************************************

 @File         PVRTContext.h

 @Title        OGLES2/PVRTContext

 @Version      

 @Copyright    Copyright (C)  Imagination Technologies Limited.

 @Platform     ANSI compatible

 @Description  Context specific stuff - i.e. 3D API-related.

******************************************************************************/
#ifndef _PVRTCONTEXT_H_
#define _PVRTCONTEXT_H_

#define TARGET_OS_IPHONE
#define BUILD_OGLES2

#include <stdio.h>
#if defined(__APPLE__)
#ifdef TARGET_OS_IPHONE
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#else	//MacOS 
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#include <GLES2/gl2extimg.h>
#endif
#else
#if defined(__BADA__)
#include <FGraphicsOpengl2.h>
using namespace Osp::Graphics::Opengl;
#else
#if defined(__PALMPDK__)
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#else
#if !defined(EGL_NOT_PRESENT)
#include <EGL/egl.h>
#endif
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#endif
#endif
#include <GLES2/gl2extimg.h>
#endif

/****************************************************************************
** Macros
****************************************************************************/
#define PVRTRGBA(r, g, b, a)   ((GLuint) (((a) << 24) | ((b) << 16) | ((g) << 8) | (r)))

/****************************************************************************
** Defines
****************************************************************************/

/****************************************************************************
** Enumerations
****************************************************************************/

/****************************************************************************
** Structures
****************************************************************************/
/*!**************************************************************************
@Struct SPVRTContext
@Brief A structure for storing API specific variables
****************************************************************************/
struct SPVRTContext
{
	int reserved;	// No context info for OGLES2.
};

/****************************************************************************
** Functions
****************************************************************************/


#endif /* _PVRTCONTEXT_H_ */

/*****************************************************************************
 End of file (PVRTContext.h)
*****************************************************************************/

