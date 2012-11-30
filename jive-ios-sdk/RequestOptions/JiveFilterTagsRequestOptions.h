//
//  JiveFilterTagsRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSortedRequestOptions.h"

@interface JiveFilterTagsRequestOptions : JiveSortedRequestOptions

@property (nonatomic, strong) NSArray *tags; // one or more tags, matching any tag will select a place.

- (void)addTag:(NSString *)tag;

- (NSString *)buildFilter;
- (NSString *)addFilterGroup:(NSString *)tag withValue:(NSString *)value toFilter:(NSString *)filter;

@end
