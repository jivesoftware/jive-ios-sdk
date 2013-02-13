//
//  JivePeopleRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
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
