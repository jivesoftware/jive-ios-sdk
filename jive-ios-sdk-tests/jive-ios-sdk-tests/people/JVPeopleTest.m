//
//  JVPeopleTest.m
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

#import "JiveTestCase.h"

@interface JVPeopleTest : JiveTestCase

@end

@implementation JVPeopleTest

- (void)test_people_with_title_Software_Engineer {
    JivePeopleRequestOptions *peopleRequestOptions = [JivePeopleRequestOptions new];
    peopleRequestOptions.title = @"Software Engineer";
    
    __block NSArray *returnedPersons = nil;
    [self waitForTimeout:^(dispatch_block_t finishBlock) {
       [jive1 people:peopleRequestOptions
         onComplete:^(NSArray *persons) {
             returnedPersons = persons;
             finishBlock();
         }
            onError:^(NSError *error) {
                [self unexpectedErrorInWaitForTimeOut:error
                                          finishBlock:finishBlock];
            }];
    }];
    
}



@end
