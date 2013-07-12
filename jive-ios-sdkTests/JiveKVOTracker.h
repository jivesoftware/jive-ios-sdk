//
//  JiveKVOTracker.h
//  jive-ipad
//
//  Created by Heath Borders on 4/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JiveKVOTracker;

typedef void (^JiveKVOTrackerChangeBlock)(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker);

@interface JiveKVOTracker : NSObject

- (id)initWithObservationTarget:(id)observationTarget
                    keySelector:(SEL)keySelector
                        options:(NSKeyValueObservingOptions)options
                    changeBlock:(JiveKVOTrackerChangeBlock)changeBlock
                      inContext:(id __weak)changeBlockContext;

- (void)stopObserving;

@end
