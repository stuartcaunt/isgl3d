/*
VFP math library for the iPhone / iPod touch

Copyright (c) 2007-2008 Wolfgang Engel and Matthias Grundmann
http://code.google.com/p/vfpmathlibrary/

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising
from the use of this software.
Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it freely,
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must
not claim that you wrote the original software. If you use this
software in a product, an acknowledgment in the product documentation
would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must
not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
*/

#ifdef __APPLE__
#import <TargetConditionals.h>
#if (TARGET_IPHONE_SIMULATOR == 0) && (TARGET_OS_IPHONE == 1)


#import "utility_impl.h"
#import "common_macros.h"


// not tested ... probably not working
void memcpy_64byte_aligned_float(float *dst_ptr, const float *scr_ptr, int n) {
  __asm__ volatile (VFP_SWITCH_TO_ARM
                VFP_VECTOR_LENGTH(3)

				// Load 16 float == 64 byte = 256-bit
				// load and store can only handle 64-bit per cycle == 2 float per cycle
                "fldmias  %1!, {s8-s23}    \n\t"
				"fstmias %0!, {s8-s23}   \n\t" 
				
                VFP_VECTOR_LENGTH_ZERO
                VFP_SWITCH_TO_THUMB
                : "=r" (dst_ptr), "=r" (scr_ptr)
                : "0" (dst_ptr), "1" (scr_ptr)
                : "r0"
                );

}

#endif
#endif
