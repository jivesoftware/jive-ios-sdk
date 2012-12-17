//
//  JiveName.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveName.h"

@implementation JiveName

@synthesize familyName, formatted, givenName;

- (id)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.familyName forKey:@"familyName"];
    [dictionary setValue:self.givenName forKey:@"givenName"];
    [dictionary setValue:self.formatted forKey:@"formatted"];
    
    return dictionary;
}

@end
