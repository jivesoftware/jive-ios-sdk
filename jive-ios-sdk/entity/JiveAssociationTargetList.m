//
//  JiveAssociationTargetList.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveAssociationTargetList_internal.h"
#import "JiveResourceEntry.h"

@implementation JiveAssociationTargetList

- (void) addAssociationTarget:(JiveTypedObject *)target {
    JiveResourceEntry *resource = [target.resources objectForKey:@"self"];
    
    if (!targetURIs)
        targetURIs = [NSMutableArray arrayWithCapacity:1];
    
    [targetURIs addObject:[resource.ref absoluteString]];
}

- (NSArray *) toJSONArray {
    return targetURIs ? [NSArray arrayWithArray:targetURIs] : nil;
}

@end
