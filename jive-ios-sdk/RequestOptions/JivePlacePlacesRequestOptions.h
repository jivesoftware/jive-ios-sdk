//
//  JivePlacePlacesRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveFilterTagsRequestOptions.h"

@interface JivePlacePlacesRequestOptions : JiveFilterTagsRequestOptions

@property (nonatomic, strong) NSArray *types; // Select entries of the specified type. One or more types can be specified.
@property (nonatomic, strong) NSArray *search; // One or more search terms, separated by commas. You must escape any of the following special characters embedded in the search terms: comma (","), backslash ("\"), left parenthesis ("("), and right parenthesis (")") by preceding them with a backslash. Wildcards can be used, e.g. to search by substring use "*someSubstring*".

- (void)addType:(NSString *)type;
- (void)addSearchTerm:(NSString *)term; // Will escape ,\() for you.

@end
