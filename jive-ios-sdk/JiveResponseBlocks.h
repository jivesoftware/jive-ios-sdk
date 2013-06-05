//
//  JiveResponseBlocks.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 6/5/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#ifndef jive_ios_sdk_JiveResponseBlocks_h
#define jive_ios_sdk_JiveResponseBlocks_h

@class JivePersonJive;
@class JiveName;
@class AFJSONRequestOperation;
@class JiveBlog;
@class JivePerson;
@class JiveWelcomeRequestOptions;
@class JivePagedRequestOptions;
@class JiveReturnFieldsRequestOptions;
@class JiveDateLimitedRequestOptions;
@class JiveSortedRequestOptions;

typedef void (^JiveErrorBlock)(NSError *error);
typedef void (^JiveArrayCompleteBlock)(NSArray *objects);
typedef void (^JivePersonCompleteBlock)(JivePerson *person);
typedef void (^JiveBlogCompleteBlock)(JiveBlog *blogPlace);
typedef void (^JiveImageCompleteBlock)(UIImage *avatarImage);
typedef void (^JiveCompletedBlock)(void);
typedef void (^JiveDateLimitedObjectsCompleteBlock)(NSArray *objects, NSDate *earliestDate, NSDate *latestDate);


#endif
