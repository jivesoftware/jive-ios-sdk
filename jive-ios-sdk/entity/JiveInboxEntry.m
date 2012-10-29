//
//  JiveInboxEntry.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveInboxEntry.h"
#import "JiveActivityObject.h"
@implementation JiveInboxEntry
@synthesize actor, content, generator, icon, jiveId, jive, object, openSocial, provider, published, target, title, updated, url, verb;

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@ -'%@'", self.object.url, self.verb, self.object.displayName];
}

@end
