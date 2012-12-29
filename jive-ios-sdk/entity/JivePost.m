//
//  JivePost.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePost.h"
#import "NSThread+JiveISO8601DateFormatter.h"
#import "JiveAttachment.h"

@implementation JivePost

@synthesize attachments, categories, permalink, publishDate, restrictComments, tags;
@synthesize visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"post";
    }
    
    return self;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if (propertyName == @"attachments") {
        return [JiveAttachment class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    
    [dictionary setValue:permalink forKey:@"permalink"];
    [dictionary setValue:restrictComments forKey:@"restrictComments"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    [self addArrayElements:attachments toJSONDictionary:dictionary forTag:@"attachments"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (categories)
        [dictionary setValue:categories forKey:@"categories"];
    
    if (publishDate)
        [dictionary setValue:[dateFormatter stringFromDate:publishDate] forKey:@"publishDate"];
    
    return dictionary;
}

@end
