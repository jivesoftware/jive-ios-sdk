//
//  JiveTargetList.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTargetList_internal.h"
#import "JiveResourceEntry.h"

@implementation JiveTargetList

- (NSArray *)toJSONArray:(BOOL)restricted {
    if (restricted)
        return personURIs ? [NSArray arrayWithArray:personURIs] : nil;

    if (personURIs)
        return [personURIs arrayByAddingObjectsFromArray:alternateIdentifiers];
    
    return alternateIdentifiers ? [NSArray arrayWithArray:alternateIdentifiers] : nil;
}

- (void)addPerson:(JivePerson *)person {
    JiveResourceEntry *resource = [person.resources objectForKey:@"self"];
    
    if (!personURIs)
        personURIs = [NSMutableArray arrayWithCapacity:1];

    [personURIs addObject:[resource.ref absoluteString]];
}

- (void)addEmailAddress:(NSString *)emailAddress {
    if (!alternateIdentifiers)
        alternateIdentifiers = [NSMutableArray arrayWithCapacity:1];
    
    [alternateIdentifiers addObject:emailAddress];
}

- (void)addUserName:(NSString *)userName {
    if (!alternateIdentifiers)
        alternateIdentifiers = [NSMutableArray arrayWithCapacity:1];
    
    [alternateIdentifiers addObject:userName];
}

@end
