//
//  JiveKVOTracker.m
//  jive-ipad
//
//  Created by Heath Borders on 4/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveKVOTracker.h"

static void * const JiveKVOTrackerContext = @"JiveKVOTrackerContext";

@interface JiveKVOTracker ()

@property (nonatomic) id observationTarget;
@property (nonatomic) NSString *keyPath;
@property (nonatomic, copy) JiveKVOTrackerChangeBlock changeBlock;
@property (nonatomic, weak) id changeBlockContext;

@property (nonatomic) NSRecursiveLock *lock;
@property (nonatomic) BOOL observing;

@end

@implementation JiveKVOTracker

- (id)initWithObservationTarget:(id)observationTarget
                    keySelector:(SEL)keySelector
                        options:(NSKeyValueObservingOptions)options
                    changeBlock:(JiveKVOTrackerChangeBlock)changeBlock
                      inContext:(id)changeBlockContext {
    if (observationTarget) {
        self = [super init];
        if (self) {
            self.observationTarget = observationTarget;
            self.keyPath = NSStringFromSelector(keySelector);
            self.changeBlock = changeBlock;
            self.changeBlockContext = changeBlockContext;
            
            [observationTarget addObserver:self
                                forKeyPath:self.keyPath
                                   options:options
                                   context:JiveKVOTrackerContext];
            self.lock = [NSRecursiveLock new];
            [self.lock lock];
            self.observing = YES;
            [self.lock unlock];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
    [self stopObserving];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ((context == JiveKVOTrackerContext)
        && ([keyPath isEqualToString:self.keyPath])) {
        __typeof(self) __weak weakSelf = self;
        self.changeBlock(self.changeBlockContext, keyPath, object, change, weakSelf);
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark - public API

- (void)stopObserving {
    // pull strongly reference self to prevent being dealloced in the middle of this method.
    __typeof(self) strongSelf = self;
    BOOL stopObserving;
    
    [strongSelf.lock lock];
    if (strongSelf.observing) {
        strongSelf.observing = NO;
        stopObserving = YES;
    } else {
        stopObserving = NO;
    }
    [strongSelf.lock unlock];
    
    // separate this step so that we have locked lock again before self.changeBlock=nil, which is a side-effecting change.
    if (stopObserving) {
        [strongSelf.observationTarget removeObserver:strongSelf
                                    forKeyPath:strongSelf.keyPath
                                       context:JiveKVOTrackerContext];
        strongSelf.changeBlock = nil;
    }
}

@end
