//
//  JiveOutcome.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"
#import "JivePerson.h"
#import "JiveOutcomeType.h"

@interface JiveOutcome : JiveObject

@property (nonatomic, readonly, strong) NSDate *creationDate;
@property (nonatomic, readonly, strong) NSString *jiveId;
@property (nonatomic, strong) JiveOutcomeType *outcomeType;
@property (nonatomic, readonly, strong) NSString *parent;
@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, readonly, strong) NSDictionary *resources;
@property (nonatomic, readonly, strong) NSDate *updated;
@property (nonatomic, readonly, strong) JivePerson *user;

@end
