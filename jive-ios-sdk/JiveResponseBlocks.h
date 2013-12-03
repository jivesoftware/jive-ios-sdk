//
//  JiveResponseBlocks.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 6/5/13.
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

#import <Foundation/Foundation.h>

#ifndef jive_ios_sdk_JiveResponseBlocks_h
#define jive_ios_sdk_JiveResponseBlocks_h

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
@class UIImage;
@compatibility_alias JiveNativeImage UIImage;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
@class NSImage;
@compatibility_alias JiveNativeImage NSImage;
#endif

@class JiveObject;
@class JivePersonJive;
@class JiveName;
@class AFJSONRequestOperation;
@class AFImageRequestOperation;
@class JiveBlog;
@class JivePerson;
@class JiveWelcomeRequestOptions;
@class JivePagedRequestOptions;
@class JiveReturnFieldsRequestOptions;
@class JiveDateLimitedRequestOptions;
@class JiveSortedRequestOptions;
@class JiveTask;

typedef void (^JiveErrorBlock)(NSError *error);
typedef void (^JiveArrayCompleteBlock)(NSArray *objects);
typedef void (^JiveObjectCompleteBlock)(JiveObject *object);
typedef void (^JivePersonCompleteBlock)(JivePerson *person);
typedef void (^JiveBlogCompleteBlock)(JiveBlog *blogPlace);
typedef void (^JiveImageCompleteBlock)(JiveNativeImage *avatarImage);
typedef void (^JiveTaskCompleteBlock)(JiveTask *task);
typedef void (^JiveCompletedBlock)(void);
typedef void (^JiveDateLimitedObjectsCompleteBlock)(NSArray *objects, NSDate *earliestDate, NSDate *latestDate);


#endif
