//
//  JivePeopleRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveFilterTagsRequestOptions.h"

@interface JivePeopleRequestOptions : JiveFilterTagsRequestOptions

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *office;
@property (nonatomic, readonly) NSDate *hiredAfter;
@property (nonatomic, readonly) NSDate *hiredBefore;
@property (nonatomic, strong) NSArray *ids;
@property (nonatomic, strong) NSString *query;

- (void)addID:(NSString *)personID;
- (void)setHireDateBetween:(NSDate *)after and:(NSDate *)before;

@end
