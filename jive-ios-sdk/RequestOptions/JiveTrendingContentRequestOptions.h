//
//  JiveTrendingContentRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveTrendingPeopleRequestOptions.h"

@interface JiveTrendingContentRequestOptions : JiveTrendingPeopleRequestOptions

@property (nonatomic, strong) NSArray *types;

- (void)addType:(NSString *)newType;

@end
