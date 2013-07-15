//
//  JiveKVOTracker.h
//  jive-ipad
//
//  Created by Heath Borders on 4/15/13.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
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
