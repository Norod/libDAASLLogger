//
//  AppDelegate.m
//  DAASLLoggerUsageDemo
//
//  Created by Doron Adler on 7/29/14.
//  Copyright (c) 2014 Doron Adler. All rights reserved.
//

#import "AppDelegate.h"
#import "DASandboxDirectory.h"
#import <DAASLLogger/DAASLLogger.h>

@implementation AppDelegate

- (void)runDAASLLoggerUsageDemo
{
    NSFileHandle* standardError = [NSFileHandle fileHandleWithStandardError];
    BOOL stderrIsAvailableForWriting = NO;
    
    @try
    {
        [standardError writeData:[[NSString stringWithFormat:@"Standard Error logging available (says \"%@\")\n\n", self] dataUsingEncoding:NSUTF8StringEncoding]];
        stderrIsAvailableForWriting = YES;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Standard Error logging not available (says \"%@\") due to \"%@\"\n\n", self, exception);
        stderrIsAvailableForWriting = NO;
    }
    @finally
    {
        DAASLLogger* aslLogger = [DAASLLogger sharedLogger];    //Initialize the shared logger
        if (aslLogger == nil) {
            NSLog(@"Internal error");
        }else
        {
            NSLog(@"Logger has been initialized");
        }
    }
    
    if (stderrIsAvailableForWriting) {
        [DAASLLogger addFileHandle:standardError upToLevel:ASL_LEVEL_DEBUG];
    }
    
    [DASandboxDirectory veryfiyAllFoldersExist];
    
    NSString* filePath = [[NSString stringWithFormat:@"%@", [DASandboxDirectory applicationSupport]] stringByAppendingPathComponent:@"firstLogFile.log"];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents: nil attributes: nil];
    NSFileHandle * tmpLogFile = [ NSFileHandle fileHandleForWritingAtPath:filePath];
    
    [DAASLLogger addFileHandle:tmpLogFile upToLevel:ASL_LEVEL_NOTICE];  //Only log message from ASL_LEVEL_NOTICE and below will be wrriten to firstLogFile.log
    
    DALoggerDebug(@"Hello this is a sample %@ message", @"DEBUG");
    DALoggerInfo(@"Hello this is a sample %@ message", @"INFO");
    DALoggerNotice(@"Hello this is a sample %@ message", @"NOTICE");
    DALoggerWarning(@"Hello this is a sample %@ message", @"WARNING");
    DALoggerError(@"Hello this is a sample %@ message", @"ERROR");
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        DALoggerNotice(@"Hello this is a sample %@ message called from a global queue", @"NOTICE");
        DALoggerWarning(@"Hello this is a sample %@ message called from a global queue", @"WARNING");
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Main thread  (E.G. for UI Updates)
            DALoggerWarning(@"Hello this is a sample %@ message called from the main queue", @"WARNING");
            DALoggerError(@"Hello this is a sample %@ message called from the main queue", @"ERROR");
            
            [DAASLLogger removeFileHandle:tmpLogFile];
            [tmpLogFile closeFile];
        });
    });
    
    
    NSLog(@"\nHello, I'm NSLog and I'm different than the other log messages. Oh by the way, check out \"%@\"\n", filePath);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self runDAASLLoggerUsageDemo];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
