//
//  JiveOutcomeType.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveOutcomeType : JiveObject

@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, readonly, strong) NSString *jiveId;
@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSDictionary *resources;

@end
