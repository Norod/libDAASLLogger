//
//  DAASLLogger.h
//  DAASLLogger
//
//  Created by Doron Adler on 7/29/14.
//  Copyright (c) 2014 Doron Adler. All rights reserved.
//
// I got a lot of knowlege and used some tricks I saw in Rasmus Andersson's asl-logging
// You can find his project here: https://github.com/rsms/asl-logging

/*
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
*/

#import <Foundation/Foundation.h>
#import <asl.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Log Message Priority Levels
//  Log levels of the message.
//
//#define ASL_LEVEL_EMERG   0
//#define ASL_LEVEL_ALERT   1
//#define ASL_LEVEL_CRIT    2
//#define ASL_LEVEL_ERR     3
//#define ASL_LEVEL_WARNING 4
//#define ASL_LEVEL_NOTICE  5
//#define ASL_LEVEL_INFO    6
//#define ASL_LEVEL_DEBUG   7
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@interface DAASLLogger : NSObject


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (DAASLLogger *)sharedLogger;

//Use the following methods to add and remove the file descriptors of your log files
//upToLevel gets one of ASL_LEVEL_XXX values copied above from <asl.h>
//To write to your file(s), use the following macros: DALoggerDebug(...),   DALoggerInfo(...),  DALoggerNotice(...)
//                                                    DALoggerWarning(...), DALoggerError(...)
// Note that you can add DA_NO_LOGGING to the pre-proccesor macros of a target to compile out all Logger macro calls
+ (int)addFileDescriptor:(int)fd upToLevel:(int)level;
+ (int)addFileHandle:(NSFileHandle *)fh upToLevel:(int)level;;
+ (int)removeFileDescriptor:(int)fd;
+ (int)removeFileHandle:(NSFileHandle *)fh;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//For internal use
- (void)error:(NSString *)format, ...;
- (void)warning:(NSString *)format, ...;
- (void)notice:(NSString *)format, ...;
- (void)info:(NSString *)format, ...;
- (void)debug:(NSString *)format, ...;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Macros

#if (DA_NO_LOGGING)

#define DALoggerDebug(...)          {}
#define DALoggerInfo(...)           {}
#define DALoggerNotice(...)         {}
#define DALoggerWarning(...)        {}
#define DALoggerError(...)          {}

#define DALoggerAslRef()            (NULL)
#deinfe DA_LOG_PREFIX_FORMAT_STR    @""

#else //DA_NO_LOGGING

#define DA_LOG_PREFIX_FORMAT_STR @"%s (%d) "

#define DALoggerDebug(_fmt, ...)  \
[[DAASLLogger sharedLogger] debug:[NSString stringWithFormat:(DA_LOG_PREFIX_FORMAT_STR _fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]

#define DALoggerInfo(_fmt, ...)  \
[[DAASLLogger sharedLogger] info:[NSString stringWithFormat:(DA_LOG_PREFIX_FORMAT_STR _fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]

#define DALoggerNotice(_fmt, ...)   \
[[DAASLLogger sharedLogger] notice:[NSString stringWithFormat:(DA_LOG_PREFIX_FORMAT_STR _fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]

#define DALoggerWarning(_fmt, ...)  \
[[DAASLLogger sharedLogger] warning:[NSString stringWithFormat:(DA_LOG_PREFIX_FORMAT_STR _fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]

#define DALoggerError(_fmt, ...)  \
[[DAASLLogger sharedLogger] error:[NSString stringWithFormat:(DA_LOG_PREFIX_FORMAT_STR _fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]

#define DALoggerAslRef() [DAASLLogger sharedClient]

#endif //!DA_NO_LOGGING


