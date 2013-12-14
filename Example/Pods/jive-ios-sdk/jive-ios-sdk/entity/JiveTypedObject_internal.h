//
//  JiveTypedObject_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/25/13.
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

#import "JiveTypedObject.h"
#import "JiveObject_internal.h"
#import "JiveResourceEntry.h"

extern struct JiveTypedObjectAttributesHidden {
    __unsafe_unretained NSString *resources;
} const JiveTypedObjectAttributesHidden;

extern struct JiveTypedObjectResourceTags {
    __unsafe_unretained NSString *selfResourceTag;
} const JiveTypedObjectResourceTags;

@interface JiveTypedObject ()

+ (void)registerClass:(Class)clazz forType:(NSString *)type;

@property(nonatomic, readonly, strong) NSDictionary* resources;

- (JiveResourceEntry *)resourceForTag:(NSString *)tag;
- (BOOL)resourceHasPutForTag:(NSString *)tag;
- (BOOL)resourceHasPostForTag:(NSString *)tag;
- (BOOL)resourceHasGetForTag:(NSString *)tag;
- (BOOL)resourceHasDeleteForTag:(NSString *)tag;

@end
