//
//  JiveIOS6CLIApplication.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 11/26/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveIOS6CLIApplication.h"

@implementation JiveIOS6CLIApplication

- (id)init {
    self = [super init];
    if (getenv("GHUNIT_CLI") &&
        [[[UIDevice currentDevice] systemVersion] isEqualToString:@"6.0"]) {
        __block BOOL done = NO;
        NSOperationQueue * queue = [[ NSOperationQueue alloc ] init ];
        [queue addOperationWithBlock:^{
            [GHTestRunner run];
            done = YES;
        }];
        
        while( !done ) {
            [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 5] ];
        }
    }
    return self;
}

@end
