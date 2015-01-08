//
//  JivePost.m
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

#import "JivePost.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveAttachment.h"
#import "JiveTypedObject_internal.h"


struct JivePostAttributes const JivePostAttributes = {
	.attachments = @"attachments",
	.categories = @"categories",
	.permalink = @"permalink",
    .publishDate = @"publishDate",
	.restrictComments = @"restrictComments",
};


struct JivePostStatusValues const JivePostStatusValues = {
        .incomplete = @"incomplete",
        .pendingApproval = @"pending_approval",
        .rejected = @"rejected",
        .scheduled = @"scheduled",
        .published = @"published"
};


@implementation JivePost

@synthesize attachments, categories, permalink, publishDate, restrictComments;

NSString * const JivePostType = @"post";

+ (void)load {
    if (self == [JivePost class])
        [super registerClass:self forType:JivePostType];
}

- (NSString *)type {
    return JivePostType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([JivePostAttributes.attachments isEqualToString:propertyName]) {
        return [JiveAttachment class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:permalink forKey:JivePostAttributes.permalink];
    [dictionary setValue:restrictComments forKey:JivePostAttributes.restrictComments];
    [self addArrayElements:attachments toJSONDictionary:dictionary
                    forTag:JivePostAttributes.attachments];
    if (categories)
        [dictionary setValue:categories forKey:JivePostAttributes.categories];
    
    if (publishDate)
        [dictionary setValue:[dateFormatter stringFromDate:publishDate]
                      forKey:JivePostAttributes.publishDate];
    
    return dictionary;
}

@end
