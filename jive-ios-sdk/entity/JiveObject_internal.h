//
//  JiveObject_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
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

#import "JiveObject.h"

@interface JiveObject ()

+ (Class) entityClass:(NSDictionary*) obj;

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property
                                     fromJSON:(id)JSON
                                 fromInstance:(Jive *)jiveInstance;

- (void)handlePrimitiveProperty:(NSString *)property fromJSON:(id)value;

- (BOOL)deserializeKey:(NSString *)key fromJSON:(id)JSON fromInstance:(Jive *)jiveInstance;

- (void)addArrayElements:(NSArray *)array toJSONDictionary:(NSMutableDictionary *)dictionary forTag:(NSString *)tag;
- (void)addArrayElements:(NSArray *)array
  toPersistentDictionary:(NSMutableDictionary *)dictionary
                  forTag:(NSString *)tag;

- (BOOL) deserialize:(id)JSON fromInstance:(Jive *)jiveInstance;
- (id)parseArrayNamed:(NSString *)propertyName fromJSON:(id)JSON jiveInstance:(Jive *)jiveInstance;

@end
