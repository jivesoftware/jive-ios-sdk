//
//  JiveKVOAdapter.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 6/26/13.
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

#import "JiveKVOAdapter.h"

static void * const JiveKVOAdapterContext = @"JiveKVOAdapterContext";

@interface JiveKVOAdapter ()
@property (weak, nonatomic) id sourceObject;
@property (weak, nonatomic) id targetObject;
@property (strong, nonatomic) NSArray *keyPathsToObserve;
@end

@implementation JiveKVOAdapter

- (void)dealloc {
    [self removeObservers];
}

- (id)initWithSourceObject:(id)sourceObject targetObject:(id)targetObject keyPathsToObserve:(NSArray *)keyPathsToObserve {
    self = [super init];
    if (self) {
        _sourceObject = sourceObject;
        _targetObject = targetObject;
        _keyPathsToObserve = keyPathsToObserve;
        [self addObservers];
    }
    return self;
}

- (void)addObservers {
    for (NSString *keyPath in self.keyPathsToObserve) {
    [self.sourceObject addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:JiveKVOAdapterContext];
    }
}

- (void)removeObservers {
    for (NSString *keyPath in self.keyPathsToObserve) {
        [self.sourceObject removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == JiveKVOAdapterContext) {
        if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) {
            [self.targetObject willChangeValueForKey:keyPath];
        } else if (change[NSKeyValueChangeNewKey]) {
            [self.targetObject didChangeValueForKey:keyPath];
        }
    }
}

@end
