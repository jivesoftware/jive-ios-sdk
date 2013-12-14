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

@class Jive;

extern struct JiveObjectAttributes {
    __unsafe_unretained NSString *extraFieldsDetected;
    __unsafe_unretained NSString *refreshDate;
} const JiveObjectAttributes;

//! \class JiveObject
@interface JiveObject : NSObject

+ (id) instanceFromJSON:(NSDictionary*) JSON DEPRECATED_ATTRIBUTE;
+ (id) instanceFromJSON:(NSDictionary*) JSON withJive:(Jive *)jive DEPRECATED_ATTRIBUTE;
+ (NSArray*) instancesFromJSONList:(NSArray*) JSON DEPRECATED_ATTRIBUTE;
+ (NSArray*) instancesFromJSONList:(NSArray*) JSON withJive:(Jive *)jive DEPRECATED_ATTRIBUTE;
+ (id) objectFromJSON:(NSDictionary *)JSON withInstance:(Jive *)instance;
+ (NSArray*) objectsFromJSONList:(NSArray *)JSON withInstance:(Jive *)instance;

//! Debug property used to indicate that a JSON server response contained more data than was expected.
@property (readonly) BOOL extraFieldsDetected;

//! The date when the object was last parsed from a JSON response.
@property (readonly) NSDate *refreshDate;

- (NSDictionary *)toJSONDictionary;
- (id)persistentJSON;

@end
