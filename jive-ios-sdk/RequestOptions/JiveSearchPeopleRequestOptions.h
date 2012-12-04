//
//  JiveSearchPeopleRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchRequestOptions.h"

@interface JiveSearchPeopleRequestOptions : JiveSearchRequestOptions

@property (nonatomic) BOOL nameonly; // Optional boolean value indicating whether or not to limit search results to only people that match by name.

@end
