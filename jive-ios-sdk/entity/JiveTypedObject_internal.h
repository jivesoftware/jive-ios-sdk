//
//  JiveTypedObject_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTypedObject.h"
#import "JiveObject_internal.h"
#import "JiveResourceEntry.h"

@interface JiveTypedObject ()

+ (void)registerClass:(Class)clazz forType:(NSString *)type;

//! Resource links (and related permissions for the requesting object) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

- (JiveResourceEntry *)resourceForTag:(NSString *)tag;
- (BOOL)resourceHasPutForTag:(NSString *)tag;
- (BOOL)resourceHasPostForTag:(NSString *)tag;
- (BOOL)resourceHasGetForTag:(NSString *)tag;
- (BOOL)resourceHasDeleteForTag:(NSString *)tag;

@end
