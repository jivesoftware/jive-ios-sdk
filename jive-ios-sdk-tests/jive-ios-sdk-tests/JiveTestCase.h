//
//  jive_ios_sdk_tests.h
//  jive-ios-sdk-tests
//
//  Created by Heath Borders on 1/17/13.
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

#import <SenTestingKit/SenTestingKit.h>
#import <Jive/Jive.h>

typedef void (^JiveTestCaseAsyncFinishBlock)(void);
typedef void (^JiveTestCaseAsyncBlock)(JiveTestCaseAsyncFinishBlock finishBlock);

extern NSString * const JiveTestCaseNotAJiveObjectKey;

@interface NSArray (JiveTestCase)

- (NSArray *) arrayOfJiveObjectJSONDictionaries;

@end

@interface JiveTestCase : SenTestCase {
    Jive *jive1;
    Jive *jive2;
    Jive *jive3;
    Jive *jive4;
    
    NSString* server;
    NSString* userid1;
    NSString* pw1;
    NSString* userid2;
    NSString* pw2;
    NSString* userid3;
    NSString* pw3;
}

- (void)waitForTimeout:(JiveTestCaseAsyncBlock)asynchBlock;
- (void)unexpectedErrorInWaitForTimeOut:(NSError *)error
                            finishBlock:(JiveTestCaseAsyncFinishBlock)finishBlock;
- (void)runOperation:(NSOperation *)operation;

@end
