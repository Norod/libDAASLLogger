//
//  DASandboxDirectory.m
//
//  Created by Doron Adler on 7/14/14.
//
//

#import "DASandboxDirectory.h"

@implementation DASandboxDirectory

#pragma mark - Class functions for getting the path for the various sandbox directories

+ (NSString*) directoryForSearchPath:(NSSearchPathDirectory)searchPathDirectory{
    NSURL* directoryForSearchPath = [[[NSFileManager defaultManager] URLsForDirectory:searchPathDirectory inDomains:NSUserDomainMask] firstObject];
    return [directoryForSearchPath path];
}

+ (NSString*) applicationSupport{
    return [self directoryForSearchPath:NSApplicationSupportDirectory];
}

+ (NSString*) caches{
    return [self directoryForSearchPath:NSCachesDirectory];
}

+ (NSString*) documents{
    return [self directoryForSearchPath:NSDocumentDirectory];
}

+ (NSString*) temporary{
    return NSTemporaryDirectory();
}

#pragma mark - Helper methods

+ (void) veryfiyAllFoldersExist
{
    [[self class] createFolderIfNeededAtPath:self.applicationSupport];
    [[self class] createFolderIfNeededAtPath:self.caches];
    [[self class] createFolderIfNeededAtPath:self.documents];
}

+ (BOOL) createFolderIfNeededAtPath:(NSString*)path
{
    BOOL shouldCreateDirectory = YES;
    BOOL isPathOfExistingDirectory = NO;
    BOOL directoryCreated = NO;
    NSError* error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isPathOfExistingDirectory] == YES)
    {
        if (isPathOfExistingDirectory)
        {
            shouldCreateDirectory = NO;
        }
        else
        {
            NSLog(@"ERROR: A file with name:\"%@\" already exists and it is not a directory",path);
        }
    }
    
    if (shouldCreateDirectory)
    {
        directoryCreated = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (directoryCreated)
        {
#ifdef DEBUG
            NSLog(@"Folder created at: \"%@\"",path);
#endif
        }
        else
        {
            NSLog(@"ERROR: Failed to create folder: \"%@\" with error: \"%@\" ",path, error);
        }
    }
    else
    {
#ifdef DEBUG
        NSLog(@"Folder already exist at: \"%@\"",path);
#endif
    }
    
    if ((shouldCreateDirectory == YES) && (directoryCreated == NO))
    {
        return NO;
    }
    
    return YES;
}


@end
