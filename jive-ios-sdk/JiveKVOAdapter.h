//
//  JiveKVOAdapter.h
//  jive-ios-sdk
//
//  Created by Chris Gummer on 6/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

/**
 * Instances of this class observe the keyPaths given in keyPathsToObserve on the given sourceObject. Observations are then
 * converted to the appropriate willChangeValueForKey: and didChangeValueForKey: messages on the given targetObject.
 * Neither the sourceObject or the targetObject are retained by instances of this class.
 */
@interface JiveKVOAdapter : NSObject

- (id)initWithSourceObject:(id)sourceObject targetObject:(id)targetObject keyPathsToObserve:(NSArray *)keyPathsToObserve;

@end
