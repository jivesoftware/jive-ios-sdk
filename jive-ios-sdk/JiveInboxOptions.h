//
//  JiveInboxOptions.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/25/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveRequestOptions.h"

@interface JiveInboxOptions : NSObject<JiveRequestOptions>
@property(nonatomic, strong) NSDate* beforeDate;
@property(nonatomic, strong) NSDate* afterDate;
@property(nonatomic) NSInteger count;
@property(nonatomic) NSInteger startIndex;
@property(nonatomic, strong) NSArray *fields;

// Evaluates option parameters to make sure
// they can be used in whatever permutation is
// presented
- (BOOL) isValid;

@end
