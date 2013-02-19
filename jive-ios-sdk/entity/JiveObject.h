//
//  JiveObject.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
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

//! \class JiveObject
@interface JiveObject : NSObject

//! Internal method
+ (id) instanceFromJSON:(NSDictionary*) JSON;
//! Internal method
+ (NSArray*) instancesFromJSONList:(NSArray*) JSON;

//! Internal property
@property (readonly) BOOL extraFieldsDetected;

//! Internal method
- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON;

//! Internal method
- (NSDictionary *)toJSONDictionary;
//! Internal method
- (void)addArrayElements:(NSArray *)array toJSONDictionary:(NSMutableDictionary *)dictionary forTag:(NSString *)tag;

//! Internal method
- (void)handlePrimitiveProperty:(NSString *)property fromJSON:(id)value;
//! Internal method
+ (Class) entityClass:(NSDictionary*) obj;

@end
