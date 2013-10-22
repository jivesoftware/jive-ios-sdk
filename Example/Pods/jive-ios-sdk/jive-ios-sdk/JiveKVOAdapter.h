//
//  JiveKVOAdapter.h
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

/**
 * Instances of this class observe the keyPaths given in keyPathsToObserve on the given sourceObject. Observations are then
 * converted to the appropriate willChangeValueForKey: and didChangeValueForKey: messages on the given targetObject.
 * Neither the sourceObject or the targetObject are retained by instances of this class.
 */
@interface JiveKVOAdapter : NSObject

- (id)initWithSourceObject:(id)sourceObject targetObject:(id)targetObject keyPathsToObserve:(NSArray *)keyPathsToObserve;

@end
