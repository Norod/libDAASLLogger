//
//  DASandboxDirectory.h
//
//  Created by Doron Adler on 7/14/14.
//
//

#import <Foundation/Foundation.h>

@interface DASandboxDirectory : NSObject

+ (NSString*) applicationSupport;
+ (NSString*) caches;
+ (NSString*) documents;
+ (NSString*) temporary;

+ (void) veryfiyAllFoldersExist;
+ (BOOL) createFolderIfNeededAtPath:(NSString*)path;

@end
