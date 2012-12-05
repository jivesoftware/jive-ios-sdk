//
//  JiveSearchContentsRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchTypesRequestOptions.h"

@interface JiveSearchContentsRequestOptions : JiveSearchTypesRequestOptions

@property (nonatomic) BOOL subjectOnly; // Optional boolean value indicating whether or not to limit search results to only content objects whose subject matches the search keywords.
@property (nonatomic, strong) NSDate *after; //Select content objects last modified after the specified date/time.
@property (nonatomic, strong) NSDate *before; // Select content objects last modified before the specified date/time.
@property (nonatomic, strong) NSURL *authorURL; // Select content objects authored by the specified person. Only one of authorURL and authorID can be specified.
@property (nonatomic, strong) NSString *authorID; // Select content objects authored by the specified person. Only one of authorID and authorURL can be specified.
@property (nonatomic, strong) NSString *moreLikeContentID; // Select content objects that are similar to the specified content object.
@property (nonatomic, strong) NSArray *places; // Select content objects that are contained in the specified place or places. The parameter value(s) must be full or partial (starting with "/places/") URI for the desired place(s), see the add methods.

- (void)addPlaceID:(NSString *)place; // Add a place id as a partial URI
- (void)addPlaceURL:(NSURL *)place; // Add a full place url

@end
