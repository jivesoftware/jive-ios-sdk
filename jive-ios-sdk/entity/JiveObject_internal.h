//
//  JiveObject_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveObject ()

+ (Class) entityClass:(NSDictionary*) obj;

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON;

- (void)handlePrimitiveProperty:(NSString *)property fromJSON:(id)value;

- (BOOL)deserializeKey:(NSString *)key fromJSON:(id)JSON;

- (void)addArrayElements:(NSArray *)array toJSONDictionary:(NSMutableDictionary *)dictionary forTag:(NSString *)tag;

- (BOOL) deserialize:(id) JSON;

@end
