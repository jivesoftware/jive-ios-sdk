//
//  JiveTargetList.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JivePerson.h"

@interface JiveTargetList : NSObject {
    NSMutableArray *personURIs;
    NSMutableArray *alternateIdentifiers;
}

- (void)addPerson:(JivePerson *)person;
- (void)addEmailAddress:(NSString *)emailAddress;
- (void)addUserName:(NSString *)userName;

@end
