//
//  DAASLLogger.m
//  DAASLLogger
//
//  A simple lightweight ASL based logger which can write to a given set of file-descriptors
//  Supports Log levels (Debug, Info, Notice, Warning, Error)
//  Prints out Date, Device Name, Proccess, Proccess ID, Log Level, Method name, Line number, Formatted log message
//
//
//  Created by Doron Adler on 7/29/14.
//  Copyright (c) 2014 Doron Adler. All rights reserved.
//

#import "libDAASLLogger.h"

@implementation DAASLLogger

static DAASLLogger* sharedLogger = nil;
static aslmsg sharedAslMessageTemplate = nil;
static aslclient sharedAslClient = NULL;

+ (DAASLLogger *)sharedLogger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLogger = [[DAASLLogger alloc] initSharedLogger];
    });
    
    return sharedLogger;
}

- (instancetype)initSharedLogger
{
    if ((self = [super init]))
    {
        char facillity[] = "com.company.logger";
        uint32_t opts = ASL_OPT_NO_DELAY;   //Commit immidiatly
/*
         #ifdef DEBUG
         opts |= ASL_OPT_STDERR; //Write also to stderr
         #endif
*/
        
        sharedAslClient = asl_open(NULL, facillity, opts);
        sharedAslMessageTemplate = asl_new(ASL_TYPE_MSG);
        asl_set(sharedAslMessageTemplate, ASL_KEY_READ_UID, [[NSString stringWithFormat:@"%d", (int)getuid()] UTF8String]);
    }
    
    return self;
}

+ (int)addFileDescriptor:(int)fd upToLevel:(int)level{
    return asl_add_output_file(sharedAslClient, fd, ASL_MSG_FMT_STD, ASL_TIME_FMT_LCL, ASL_FILTER_MASK_UPTO(level), ASL_ENCODE_SAFE);
}

+ (int)addFileHandle:(NSFileHandle *)fh upToLevel:(int)level{
    return [self addFileDescriptor:[fh fileDescriptor] upToLevel:level];
}

+ (int)removeFileDescriptor:(int)fd {
    return asl_remove_log_file(sharedAslClient, fd);
}

+ (int)removeFileHandle:(NSFileHandle *)fh {
    return [self removeFileDescriptor:[fh fileDescriptor]];
}

- (void)emit:(int)level format:(NSString *)format arguments:(va_list)args {
    NSString *s = [[NSString alloc] initWithFormat:format arguments:args];
    const char *pch = [s UTF8String];
    
    asl_log(sharedAslClient, sharedAslMessageTemplate, level, "%s", pch);
#if !(__has_feature(objc_arc))
    [s release];
#endif
}


#define L(level, LEVEL)\
- (void)level:(NSString *)format, ... {\
va_list args;\
va_start(args, format);\
[self emit: ASL_LEVEL_##LEVEL format:format arguments:args];\
va_end(args);\
}
L(error,    ERR)
L(warning,  WARNING)
L(notice,   NOTICE)
L(info,     INFO)
L(debug,    DEBUG)
#undef L


- (void)dealloc
{
    if (sharedAslClient)
    {
        asl_close(sharedAslClient);
        sharedAslClient = NULL;
    }
    
    if (sharedAslMessageTemplate)
    {
        asl_free(sharedAslMessageTemplate);
        sharedAslMessageTemplate = nil;
    }
    
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif    
}


@end
