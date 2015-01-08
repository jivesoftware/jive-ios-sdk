//
//  JiveComment.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

#import "JiveComment.h"
#import "JiveTypedObject_internal.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"


struct JiveCommentAttributes const JiveCommentAttributes = {
    .externalID = @"externalID",
    .publishedCalendarDate = @"publishedCalendarDate",
    .publishedTime = @"publishedTime",
    .rootExternalID = @"rootExternalID",
    .rootType = @"rootType",
    .rootURI = @"rootURI",
};


@implementation JiveComment

@synthesize rootType, rootURI, externalID, publishedTime, publishedCalendarDate, rootExternalID;

NSString * const JiveCommentType = @"comment";

+ (void)load {
    if (self == [JiveComment class])
        [super registerClass:self forType:JiveCommentType];
}

- (NSString *)type {
    return JiveCommentType;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:externalID forKey:JiveCommentAttributes.externalID];
    [dictionary setValue:rootExternalID forKey:JiveCommentAttributes.rootExternalID];
    [dictionary setValue:rootType forKey:JiveCommentAttributes.rootType];
    [dictionary setValue:rootURI forKey:JiveCommentAttributes.rootURI];
    
    if (publishedCalendarDate != nil)
        [dictionary setValue:[dateFormatter stringFromDate:publishedCalendarDate]
                      forKey:JiveCommentAttributes.publishedCalendarDate];
    
    if (publishedTime != nil)
        [dictionary setValue:[dateFormatter stringFromDate:publishedTime]
                      forKey:JiveCommentAttributes.publishedTime];
    
    return dictionary;
}

@end
