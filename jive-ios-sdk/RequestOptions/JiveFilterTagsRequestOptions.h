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

// Internal method referenced by derived classes.
- (NSMutableArray *)buildFilter;

@end
