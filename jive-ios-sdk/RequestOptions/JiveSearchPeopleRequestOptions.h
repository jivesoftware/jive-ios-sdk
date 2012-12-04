//
//  JiveSearchPeopleRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSortedRequestOptions.h"

@interface JiveSearchPeopleRequestOptions : JiveSortedRequestOptions

@property (nonatomic, strong) NSArray *search; // One or more search terms, separated by commas. You must escape any of the following special characters embedded in the search terms: comma (","), backslash ("\"), left parenthesis ("("), and right parenthesis (")") by preceding them with a backslash. Wildcards can be used, e.g. to search by substring use "*someSubstring*".
@property (nonatomic) BOOL nameonly; // Optional boolean value indicating whether or not to limit search results to only people that match by name.

- (void)addSearchTerm:(NSString *)term; // Will escape ,\() for you.

@end
