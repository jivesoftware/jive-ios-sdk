//
//  JiveInboxOptions.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/25/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDateLimitedRequestOptions.h"

@interface JiveInboxOptions : JiveDateLimitedRequestOptions

@property (nonatomic) BOOL unread; // Indicates if only unread entries should be returned.
@property (nonatomic, strong) NSString *authorID; // Select entries authored by the specified person, identified by authorID. Mutually exclusive with authorURL.
@property (nonatomic, strong) NSURL *authorURL; // Select entries authored by the specified person, identified by URL. Mutually exclusive with authorID.
@property (nonatomic, strong) NSArray *types; // Select entries of the specified type. One or more types can be specified.

- (void)addType:(NSString *)type;

@end
