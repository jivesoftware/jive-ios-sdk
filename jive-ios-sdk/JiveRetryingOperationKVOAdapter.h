//
//  JiveRetryingOperationKVOAdapter.h
//  jive-ios-sdk
//
//  Created by Chris Gummer on 6/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveKVOAdapter.h"

@interface JiveRetryingOperationKVOAdapter : JiveKVOAdapter

- (id)initWithSourceObject:(id)sourceObject targetObject:(id)targetObject;

@end
