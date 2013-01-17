//
//  JiveSearchRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSortedRequestOptions.h"

@interface JiveSearchRequestOptions : JiveSortedRequestOptions

@property (nonatomic, strong) NSArray *search; // One or more search terms. Wildcards can be used, e.g. to search by substring use "*someSubstring*".

- (void)addSearchTerm:(NSString *)term;

// Internal method referenced by derived classes.
- (NSMutableArray *)buildFilter;

@end
