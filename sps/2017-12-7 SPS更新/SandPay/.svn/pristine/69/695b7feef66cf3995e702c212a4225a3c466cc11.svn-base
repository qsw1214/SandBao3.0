/*
**  xhead.h -- auxiliary compilation for Visual C++
**  Copyright (C) 2013 Rick Xing. All rights reserved.
**  AUTHOR
**      Rick Xing <xingziwen@yahoo.com>
**  HISTORY
**      2013-06-19 # Created by Rick Xing
*/

#pragma once

/*
 *  xhead.h: precompiled header
 *  xhead.cc: /Yc
 */

#define STDCALL __stdcall

#ifndef NULL
#define NULL	0
#endif

#ifndef TRUE
#define TRUE	1
#endif

#ifndef FALSE
#define FALSE	0
#endif


#if !defined(OBJC_HIDE_64) && TARGET_OS_IPHONE && __LP64__
typedef bool BOOL;
#else
typedef signed char BOOL;
// BOOL is explicitly signed so @encode(BOOL) == "c" rather than "C"
// even if -funsigned-char is used.
#endif

//typedef signed char			BOOL;
typedef unsigned char		BYTE;
typedef unsigned short		WORD;
typedef unsigned long		DWORD;
typedef int                 INT;
typedef unsigned int        UINT;

#include <string.h>



