//
//  JiveRetryingOperationKVOAdapter.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 6/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveRetryingOperationKVOAdapter.h"

@implementation JiveRetryingOperationKVOAdapter

- (id)initWithSourceObject:(id)sourceObject targetObject:(id)targetObject {
    NSArray *keyPathsToObserve = @[
                                   NSStringFromSelector(@selector(isCancelled)),
                                   NSStringFromSelector(@selector(isExecuting)),
                                   NSStringFromSelector(@selector(isFinished)),
                                   ];
    self = [super initWithSourceObject:sourceObject targetObject:targetObject keyPathsToObserve:keyPathsToObserve];
    if (self) {
        
    }
    return self;
}

@end
