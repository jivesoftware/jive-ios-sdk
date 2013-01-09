//
//  JiveTrendingPeopleRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveCountRequestOptions.h"

@interface JiveTrendingPeopleRequestOptions : JiveCountRequestOptions

@property (nonatomic, strong) NSURL *url; // users that are trending in this place URI

// Internal method referenced by derived classes.
- (NSMutableArray *)buildFilter;

@end
