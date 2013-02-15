//
//  JiveMessage.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveMessage.h"
#import "JiveAttachment.h"

@implementation JiveMessage

@synthesize answer, attachments, discussion, helpful, tags, visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"message";
    }
    
    return self;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:@"attachments"]) {
        return [JiveAttachment class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:answer forKey:@"answer"];
    [dictionary setValue:helpful forKey:@"helpful"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    [dictionary setValue:discussion forKey:@"discussion"];
    [self addArrayElements:attachments toJSONDictionary:dictionary forTag:@"attachments"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    return dictionary;
}

@end
