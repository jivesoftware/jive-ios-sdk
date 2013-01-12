//
//  JiveInvite.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/11/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveInvite.h"
#import "JiveResourceEntry.h"

@interface JiveInvite (internal)

+ (NSString *) jsonForState:(enum JiveInviteState)state;

@end

@implementation JiveInvite

@synthesize body, email, jiveId, invitee, inviter, place, published, resources, revokeDate, revoker;
@synthesize sentDate, state, updated;

- (NSString *) type {
    return @"invite";
}

+ (NSArray *)stateNames {
    static NSArray *names = nil;
    
    if (!names)
        names = @[@"", @"deleted", @"fulfilled", @"processing", @"revoked", @"sent"];
    
    return names;
}

+ (NSString *) jsonForState:(enum JiveInviteState)state {
    return [[JiveInvite stateNames] objectAtIndex:state];
}

- (void)handlePrimitiveProperty:(NSString *)property fromJSON:(id)value {
    NSUInteger index = [[JiveInvite stateNames] indexOfObject:value];
    
    if (index <= JiveInviteSent)
        state = (enum JiveInviteState)index;
}

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
    
    for (NSString *key in JSON) {
        JiveResourceEntry *entry = [JiveResourceEntry instanceFromJSON:[JSON objectForKey:key]];
        
        [dictionary setValue:entry forKey:key];
    }
    
    return dictionary.count > 0 ? [NSDictionary dictionaryWithDictionary:dictionary] : nil;
}

@end
