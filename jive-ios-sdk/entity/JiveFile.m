//
//  JiveFile.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveFile.h"
#import "JivePerson.h"

@implementation JiveFile

@synthesize authors, authorship, binaryURL, categories, tags, users, visibility;
@synthesize visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"file";
    }
    
    return self;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if (propertyName == @"authors" || propertyName == @"users") {
        return [JivePerson class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:authorship forKey:@"authorship"];
    [dictionary setValue:[binaryURL absoluteString] forKey:@"binaryURL"];
    [dictionary setValue:visibility forKey:@"visibility"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
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
