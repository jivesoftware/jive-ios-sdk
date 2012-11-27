//
//  JiveDateLimitedRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveCountRequestOptions.h"

@interface JiveDateLimitedRequestOptions : JiveCountRequestOptions

@property (nonatomic, strong) NSDate *after; // Date and time representing the minimum "last activity in a collection" timestamp for selecting activities (cannot specify both after and before)
@property (nonatomic, strong) NSDate *before; // Date and time representing the maxium "last activity in a collection" timestamp for selecting activities (cannot specify both after and before)

@end
