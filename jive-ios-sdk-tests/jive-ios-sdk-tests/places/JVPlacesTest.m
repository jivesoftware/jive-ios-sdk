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
#import "JVUtilities.h"

@interface JVPlacesTest : JiveTestCase
@property (strong,nonatomic)  JivePlace *testPlace;
@property (strong,nonatomic)  NSString *testPlaceID;
@property (strong,nonatomic)  NSURL *testPlaceURL;
@property (strong,nonatomic)  NSString *groupName;
@end


@implementation JVPlacesTest

- (void)setUp {
    
    [super setUp];
    
    _groupName=@"iosAutoGroup1";
    JiveSearchPlacesRequestOptions* options = [[JiveSearchPlacesRequestOptions alloc]init];
    [options addSearchTerm:_groupName];
    
    __block NSArray *returnedPlaces = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 searchPlaces:options onComplete:^(NSArray *results) {
            returnedPlaces = results;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });
        
    for (JivePlace *place in returnedPlaces) {
        if ( [place.name isEqualToString: _groupName]) {
            _testPlace = place;
            _testPlaceID = place.placeID;
            _testPlaceURL = place.selfRef;
        }
    }
    STAssertTrue([[_testPlace class] isSubclassOfClass:[JivePlace class]], @"Test failed at setup. Wrong class");
    STAssertTrue(_testPlaceID != nil,  @"Test failed at setup. Place %@ not found", _groupName);
    STAssertTrue(_testPlaceURL != nil,  @"Test failed at setup. URL for place %@ not found", _groupName);
    
}

- (void)test_search_places_with_term_ios {
    JivePlacesRequestOptions *placesRequestOptions = [JivePlacesRequestOptions new];
    [placesRequestOptions addSearchTerm:@"ios"];
    
    __block NSArray *returnedPlaces = nil;
    waitForTimeout(^(JiveTestCaseAsyncFinishBlock finishBlock) {
        [jive1 places:placesRequestOptions
          onComplete:^(NSArray *places) {
              returnedPlaces = places;
              finishBlock();
          }
             onError:^(NSError *error) {
                 unexpectedErrorInWaitForTimeout(error, finishBlock);
             }];
    });

    NSMutableArray *returnedPlacesNames = [NSMutableArray new];
    for (JivePlace *place in returnedPlaces) {
        [returnedPlacesNames addObject:place.name];
    }


    /*
    NSString* recentPlacesAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/places?filter=search(ios)";
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentPlacesAPIURL];
    */

    NSString* recentPlacesAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/places?filter=search(ios)"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentPlacesAPIURL];

    NSArray* returnedtPlacesListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];


    //verify the number returned rows between API and SDK
    STAssertEquals([returnedPlaces count], [returnedtPlacesListFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedPlaces count], [returnedtPlacesListFromAPI count]);

    NSUInteger i = 0;

    for (JivePlace* jivePlaceFromSDK in returnedPlaces) {

        id jivePlaceFromAPI = [returnedtPlacesListFromAPI objectAtIndex:i];

        NSString* aPlaceNameFromAPI = [JVUtilities get_Place_description:jivePlaceFromAPI];

        STAssertEqualObjects( jivePlaceFromSDK.jiveDescription, aPlaceNameFromAPI , @"Expecting same results from SDK and v3 API for recent places for this user, sdk = '%@' , api = '%@' !",  jivePlaceFromSDK.jiveDescription, aPlaceNameFromAPI);

        i++;

    }
}

- (void)test_search_places_contained_porjects {
    JivePlacesRequestOptions *placesRequestOptions = [JivePlacesRequestOptions new];
    [placesRequestOptions addType:@"project"];
    
    __block NSArray *returnedPlaces = nil;
    waitForTimeout(^(JiveTestCaseAsyncFinishBlock finishBlock) {
        [jive1 places:placesRequestOptions
           onComplete:^(NSArray *places) {
               returnedPlaces = places;
               finishBlock();
           }
              onError:^(NSError *error) {
                  unexpectedErrorInWaitForTimeout(error, finishBlock);
              }];
    });
    
    NSMutableArray *returnedPlacesNames = [NSMutableArray new];
    for (JivePlace *place in returnedPlaces) {
        [returnedPlacesNames addObject:place.name];
    }
    
    
    /*
     NSString* recentPlacesAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/places?filter=type(project)";
     id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentPlacesAPIURL];
     */
    
    NSString* recentPlacesAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/places?filter=type(project)"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentPlacesAPIURL];
    
    NSArray* returnedtPlacesListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedPlaces count], [returnedtPlacesListFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedPlaces count], [returnedtPlacesListFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JivePlace* jivePlaceFromSDK in returnedPlaces) {
        
        id jivePlaceFromAPI = [returnedtPlacesListFromAPI objectAtIndex:i];
        
        NSString* aPlaceNameFromAPI = [JVUtilities get_Place_description:jivePlaceFromAPI];
        
        STAssertEqualObjects( jivePlaceFromSDK.jiveDescription, aPlaceNameFromAPI , @"Expecting same results from SDK and v3 API for recent places for this user, sdk = '%@' , api = '%@' !",  jivePlaceFromSDK.jiveDescription, aPlaceNameFromAPI);
        
        i++;
        
    }
    
}

- (void) testPlacePlacesAll {
    JivePlacePlacesRequestOptions *options = [[JivePlacePlacesRequestOptions alloc] init];
    options=nil;
    
    __block NSArray *returnedPlacePlacesFromSDK = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1){
        [jive1 placePlaces:_testPlace withOptions:options onComplete:^(NSArray *places) {
            returnedPlacePlacesFromSDK = places;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    NSLog(@"testPlacePlacesAll: places count = %@", @([returnedPlacePlacesFromSDK count]));
    
    NSString* placePlacesAPIURL =[ NSString stringWithFormat:@"%@%@%@%@", server, @"/api/core/v3/places/", _testPlaceID, @"/places"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:placePlacesAPIURL];
    
    NSArray* returnedPlacePlacesFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedPlacePlacesFromSDK count], [returnedPlacePlacesFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedPlacePlacesFromSDK count], [returnedPlacePlacesFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JivePlace* placeFromSDK in returnedPlacePlacesFromSDK) {
        id placeFromAPI = [returnedPlacePlacesFromAPI objectAtIndex:i];
        
        NSString* placeNameFromAPI = [JVUtilities get_Place_name:placeFromAPI];
        NSString* placeDisplayNameFromAPI = [JVUtilities get_Place_displayName:placeFromAPI];
        
        STAssertEqualObjects(placeFromSDK.name, placeNameFromAPI, @"Expecting same place name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !",   placeFromSDK.name, placeNameFromAPI);
        STAssertEqualObjects(placeFromSDK.displayName, placeDisplayNameFromAPI , @"Expecting same place display nme from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !", placeFromSDK.displayName, placeDisplayNameFromAPI );
        i++;
    }
}

- (void) testPlacePlacesBySearchTerm {
    JivePlacePlacesRequestOptions *options = [[JivePlacePlacesRequestOptions alloc] init];
    [options addSearchTerm:@"project1"];
    [options addSearchTerm:@"iosautogroup*"];
    
    __block NSArray *returnedPlacePlacesFromSDK = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1){
        [jive1 placePlaces:_testPlace withOptions:options onComplete:^(NSArray *places) {
            returnedPlacePlacesFromSDK = places;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
   
    NSLog(@"testPlacePlacesBySearchTerm: places count = %@", @([returnedPlacePlacesFromSDK count]));

    NSString* placePlacesAPIURL =[ NSString stringWithFormat:@"%@%@%@%@", server, @"/api/core/v3/places/", _testPlaceID, @"/places?filter=search(project1,iosautogroup*)"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:placePlacesAPIURL];
    
    NSArray* returnedPlacePlacesFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedPlacePlacesFromSDK count], [returnedPlacePlacesFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedPlacePlacesFromSDK count], [returnedPlacePlacesFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JivePlace* placeFromSDK in returnedPlacePlacesFromSDK) {
        id placeFromAPI = [returnedPlacePlacesFromAPI objectAtIndex:i];
        
        NSString* placeNameFromAPI = [JVUtilities get_Place_name:placeFromAPI];
        NSString* placeDisplayNameFromAPI = [JVUtilities get_Place_displayName:placeFromAPI];
        
        STAssertEqualObjects(placeFromSDK.name, placeNameFromAPI, @"Expecting same place name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !",   placeFromSDK.name, placeNameFromAPI);
        STAssertEqualObjects(placeFromSDK.displayName, placeDisplayNameFromAPI , @"Expecting same place display name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !", placeFromSDK.displayName, placeDisplayNameFromAPI );
        i++;
    }
}

- (void) testPlacePlacesByType {
    JivePlacePlacesRequestOptions *options = [[JivePlacePlacesRequestOptions alloc] init];
    [options addType:@"project"];
    
    __block NSArray *returnedPlacePlacesFromSDK = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1){
        [jive1 placePlaces:_testPlace withOptions:options onComplete:^(NSArray *places) {
            returnedPlacePlacesFromSDK = places;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    NSLog(@"testPlacePlacesByType: places count = %@", @([returnedPlacePlacesFromSDK count]));
    NSString* placePlacesAPIURL =[ NSString stringWithFormat:@"%@%@%@%@", server, @"/api/core/v3/places/", _testPlaceID, @"/places?filter=type(project)"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:placePlacesAPIURL];
    
    NSArray* returnedPlacePlacesFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedPlacePlacesFromSDK count], [returnedPlacePlacesFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedPlacePlacesFromSDK count], [returnedPlacePlacesFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JivePlace* placeFromSDK in returnedPlacePlacesFromSDK) {
        id placeFromAPI = [returnedPlacePlacesFromAPI objectAtIndex:i];
        
        NSString* placeNameFromAPI = [JVUtilities get_Place_name:placeFromAPI];
        NSString* placeDisplayNameFromAPI = [JVUtilities get_Place_displayName:placeFromAPI];
        
        STAssertEqualObjects(placeFromSDK.name, placeNameFromAPI, @"Expecting same place name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !",   placeFromSDK.name, placeNameFromAPI);
        STAssertEqualObjects(placeFromSDK.displayName, placeDisplayNameFromAPI , @"Expecting place display name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !", placeFromSDK.displayName, placeDisplayNameFromAPI );
        i++;
    }
}

- (void)testGetPlaceByPlaceURL {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    
    __block JivePlace *returnedPlace = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 placeFromURL:_testPlaceURL withOptions:options onComplete:^(JivePlace *place) {
            returnedPlace = place;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    STAssertTrue([returnedPlace.name isEqualToString: _groupName], @"group name is not correct");
    
}



- (void)testGetPlaceByPlaceObject {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    
    __block JivePlace *returnedPlace = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 place:_testPlace withOptions:options onComplete:^(JivePlace *place) {
            returnedPlace = place;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    STAssertTrue([returnedPlace.name isEqualToString: _groupName], @"group name is not correct");
    
}


- (void) testPlaceActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    
    __block NSArray *returnedActivitiesFromSDK = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1){
        [jive1 placeActivities:_testPlace withOptions:options onComplete:^(NSArray *activities) {
            returnedActivitiesFromSDK = activities;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    NSString* recentPlacesAPIURL =[ NSString stringWithFormat:@"%@%@%@%@", server, @"/api/core/v3/places/", _testPlaceID, @"/activities"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentPlacesAPIURL];
    
    NSArray* returnedActivitiesFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedActivitiesFromSDK count], [returnedActivitiesFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedActivitiesFromSDK count], [returnedActivitiesFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JiveActivity* jiveActivityFromSDK in returnedActivitiesFromSDK) {
        
        id jiveActivityFromAPI = [returnedActivitiesFromAPI objectAtIndex:i];
        
        NSString* activityTitleFromAPI = [JVUtilities get_Activity_title:jiveActivityFromAPI];
        NSString* activityActorDisplayFromAPI = [JVUtilities get_Activity_actor_displayName:jiveActivityFromAPI];
        NSNumber* activityCanCommentFromAPI = [JVUtilities get_Activity_canComment:jiveActivityFromAPI];
        NSNumber* activityReplyCountFromAPI = [JVUtilities get_Activity_replyCount:jiveActivityFromAPI];
        
        STAssertEqualObjects( jiveActivityFromSDK.title, activityTitleFromAPI , @"Expecting same title from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !",   jiveActivityFromSDK.title, activityTitleFromAPI );
        
        STAssertEqualObjects(jiveActivityFromSDK.actor.displayName, activityActorDisplayFromAPI , @"Expecting same  actor display from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !", jiveActivityFromSDK.actor.displayName, activityActorDisplayFromAPI );
        
        STAssertEqualObjects(jiveActivityFromSDK.jive.replyCount, activityReplyCountFromAPI , @"Expecting same  reply counts from SDK and v3 API for  this activity, sdk = '%@' , api = '%@' !", jiveActivityFromSDK.jive.replyCount, activityReplyCountFromAPI );
        
        STAssertEqualObjects(jiveActivityFromSDK.jive.canComment, activityCanCommentFromAPI , @"Expecting reply action from SDK and v3 API for  this activity, sdk = '%@' , api = '%@' !", jiveActivityFromSDK.jive.canComment, activityCanCommentFromAPI );
        i++;
    }
}

- (void)testUpdatePlaceDisplayName {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"displayName"];
    
    
    NSString *originalDisplayName = _testPlace.displayName;
    NSString *displayName =[NSString stringWithFormat:@"new display name for place '%@'", _testPlace.name];

    _testPlace.displayName = displayName;
    __block JivePlace *returnedPlace = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 updatePlace:_testPlace withOptions:options onComplete:^(JivePlace *place) {
            returnedPlace = place;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    //Verify display name is updated correctly by SDK
    STAssertTrue([returnedPlace.displayName isEqualToString: displayName], @"group display name is not updated correctly. Expected=%@, Actual=%@", displayName, returnedPlace.displayName);
    
    //Verify display name v3 api shows updated display name
    NSString* placeAPIURL =[ NSString stringWithFormat:@"%@%@%@", server, @"/api/core/v3/places/", _testPlaceID];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:placeAPIURL];
    NSString* placeDisplayNameFromAPI = [JVUtilities get_Place_displayName:jsonResponseFromAPI];
    
    STAssertEqualObjects(displayName, placeDisplayNameFromAPI , @"Expecting display name is updated from v3 api, expected = '%@' , api = '%@' !", displayName, placeDisplayNameFromAPI );
    
    //Set display name back to original name
    _testPlace.displayName = originalDisplayName;
    
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 updatePlace:_testPlace withOptions:options onComplete:^(JivePlace *place) {
            returnedPlace = place;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
}

@end
