//
//  ViewController.m
//  DAASLLoggerUsageDemo
//
//  Created by Doron Adler on 7/29/14.
//  Copyright (c) 2014 Doron Adler. All rights reserved.
//

#import "ViewController.h"
#import "DASandboxDirectory.h"
#import <DAASLLogger/DAASLLogger.h>

@interface ViewController ()

@property (nonatomic, strong) NSFileHandle *myLogFile;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString* filePath = [[NSString stringWithFormat:@"%@", [DASandboxDirectory applicationSupport]] stringByAppendingPathComponent:@"secondtLogFile.log"];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents: nil attributes: nil];
    self.myLogFile = [ NSFileHandle fileHandleForWritingAtPath:filePath];
    
    [DAASLLogger addFileHandle:self.myLogFile upToLevel:ASL_LEVEL_NOTICE];  //Only log message from ASL_LEVEL_NOTICE and below will be wrriten to secondLogFile.log
    
    
    DALoggerNotice(@"Oh mighty ASL, please acknolege my hubmle existence");
    NSLog(@"\nHey there, I'm NSLog and check out \"%@\"\n", filePath);
}
- (void)viewWillAppear:(BOOL)animated    // Called when the view is about to made visible. Default does nothing
{
    [super viewWillAppear:animated];
    DALoggerNotice(@"animated = %@", ((animated)?(@"Yes"):(@"No")));
}

- (void)viewDidAppear:(BOOL)animated     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
    [super viewDidAppear:animated];
    DALoggerNotice(@"animated = %@", ((animated)?(@"Yes"):(@"No")));
}

- (void)viewWillDisappear:(BOOL)animated // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
{
    [super viewWillDisappear:animated];
    DALoggerNotice(@"animated = %@", ((animated)?(@"Yes"):(@"No")));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DALoggerWarning(@"-");
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [DAASLLogger removeFileHandle:self.myLogFile];
    [self.myLogFile closeFile];
    self.myLogFile = nil;
}

@end
