//
//  JiveDocument.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDocument.h"
#import "JiveAttachment.h"
#import "JivePerson.h"

@implementation JiveDocument

@synthesize approvers, attachments, authors, authorship, categories, fromQuest, restrictComments;
@synthesize tags, users, visibility, visibleToExternalContributors;

- (id)init {
    self = [super init];
    if (self) {
        self.type = @"document";
    }
    
    return self;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:@"attachments"]) {
        return [JiveAttachment class];
    }
    
    if ([propertyName isEqualToString:@"approvers"] ||
        [propertyName isEqualToString:@"authors"] ||
        [propertyName isEqualToString:@"users"]) {
        return [JivePerson class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:authorship forKey:@"authorship"];
    [dictionary setValue:fromQuest forKey:@"fromQuest"];
    [dictionary setValue:restrictComments forKey:@"restrictComments"];
    [dictionary setValue:visibility forKey:@"visibility"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    [self addArrayElements:attachments toJSONDictionary:dictionary forTag:@"attachments"];
    [self addArrayElements:approvers toJSONDictionary:dictionary forTag:@"approvers"];
    [self addArrayElements:authors toJSONDictionary:dictionary forTag:@"authors"];
    if (users.count > 0 && [[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]])
        [dictionary setValue:users forKey:@"users"];
    else
        [self addArrayElements:users toJSONDictionary:dictionary forTag:@"users"];
    
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (categories)
        [dictionary setValue:categories forKey:@"categories"];
    
    return dictionary;
}

@end
