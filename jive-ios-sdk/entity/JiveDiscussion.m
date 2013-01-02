//
//  JiveDiscusson.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDiscussion.h"

@implementation JiveDiscussion

@synthesize categories, question, tags, users, visibility, visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"discussion";
    }
    
    return self;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if (propertyName == @"users") {
        return [JivePerson class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:question forKey:@"question"];
    [dictionary setValue:visibility forKey:@"visibility"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
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
