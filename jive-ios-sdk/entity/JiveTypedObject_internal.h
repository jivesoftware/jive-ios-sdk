//
//  JiveTypedObject_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTypedObject.h"

@interface JiveTypedObject (internal)

+ (void)registerClass:(Class)clazz forType:(NSString *)type;

@end
