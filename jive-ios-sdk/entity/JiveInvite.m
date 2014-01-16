//
//  JiveInvite.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/11/13.
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

#import "JiveInvite.h"

@interface JiveInvite (internal)

+ (NSString *) jsonForState:(enum JiveInviteState)state;

@end

@implementation JiveInvite

@synthesize body, email, jiveId, invitee, inviter, place, published, revokeDate, revoker;
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

@end
