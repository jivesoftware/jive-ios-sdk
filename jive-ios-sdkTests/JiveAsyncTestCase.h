//
//  JiveAsyncTestCase.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface JiveAsyncTestCase : SenTestCase

- (void)waitForTimeout:(void (^)(void(^finishedBlock)(void)))asynchBlock;
- (void)runOperation:(NSOperation *)operation untilComplete:(BOOL (^)(void))operationComplete;

@end
