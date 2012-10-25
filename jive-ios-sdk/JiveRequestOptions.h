//
//  JiveRequestOptions.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/25/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiveRequestOptions : NSObject
@property(nonatomic, strong) NSDate* beforeDate;
@property(nonatomic, strong) NSDate* afterDate;
@property(nonatomic) NSInteger count;

// Evaluates option parameters to make sure
// they can be used in whatever permutation is
// presented
- (BOOL) isValid;

@end
