//
//  JiveTypedObject_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTypedObject.h"
#import "JiveObject_internal.h"

@interface JiveTypedObject ()

+ (void)registerClass:(Class)clazz forType:(NSString *)type;

@end
