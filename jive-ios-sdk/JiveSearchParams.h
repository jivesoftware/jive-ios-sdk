//
//  JiveSearchParams.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/13/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiveSearchParams : NSObject

// content, people, places
- (NSString *) facet;

// convert params to query string to be used in search URL
- (NSString *) toQueryString;

@end
