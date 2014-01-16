//
//  TestObjectFactory.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/15/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "TestObjectFactory.h"
#import "JiveResourceEntry.h"

@implementation TestObjectFactory

+ (JiveResourceEntry *)createSelfResourceEntryForPerson:(NSString *)personID
                                               atServer:(NSURL *)serverURL {
    JiveResourceEntry *selfResource = [JiveResourceEntry new];
    
    [selfResource setValue:[NSURL URLWithString:[@"api/core/v3/person/" stringByAppendingString:personID]
                                  relativeToURL:serverURL]
                    forKey:JiveResourceEntryAttributes.ref];
    [selfResource setValue:@[@"GET"]
                    forKey:JiveResourceEntryAttributes.allowed];
    return selfResource;
}

@end
