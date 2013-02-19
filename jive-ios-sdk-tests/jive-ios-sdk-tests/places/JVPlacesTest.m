//
//  JVPlacesTest.m
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

@interface JVPlacesTest : JiveTestCase

@end

@implementation JVPlacesTest

- (void)test_search_places_with_term_ios {
    JivePlacesRequestOptions *placesRequestOptions = [JivePlacesRequestOptions new];
    [placesRequestOptions addSearchTerm:@"ios"];
    
    __block NSArray *returnedPlaces = nil;
    [self waitForTimeout:^(JiveTestCaseAsyncFinishBlock finishBlock) {
        [jive places:placesRequestOptions
          onComplete:^(NSArray *places) {
              returnedPlaces = places;
              finishBlock();
          }
             onError:^(NSError *error) {
                 [self unexpectedErrorInWaitForTimeOut:error
                                           finishBlock:finishBlock];
             }];
    }];
    
    NSMutableArray *returnedPlacesNames = [NSMutableArray new];
    for (JivePlace *place in returnedPlaces) {
        [returnedPlacesNames addObject:place.name];
    }
    
    STAssertEqualObjects((@[
                          @"iOS-SDK-TestSpace1",
                          @"iOS-SDK-TestSpace1-TestProject1",
                          @"iOS-SDK-TestSubSpace1",
                          @"iOS-SDK-TestUser1_TestSocialGroup1",
                          @"iOS-SDK-TestUser1_TestSocialGroup2_Open",
                          @"iOS-SDK-TestUser1_TestSocialGroup3_Private",
                          @"iOS-SDK-TestUser1_TestSocialGroup4_Secret",
                          @"ios-spacetest",
                          ]), returnedPlacesNames, @"Unexpected places: %@", [returnedPlaces arrayOfJiveObjectJSONDictionaries]);
}

@end
