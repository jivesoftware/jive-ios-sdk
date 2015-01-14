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
#import "JVUtilities.h"

@interface JVPeopleTest : JiveTestCase
@property (strong,nonatomic)  JivePerson *testPerson;
@property (strong,nonatomic)  NSString *testPersonID;
@property (strong,nonatomic)  NSURL *testPersonURL;
@property (strong,nonatomic)  NSString *testPersonUsername;
@property (strong,nonatomic)  JivePlace *testGroup;
@property (strong,nonatomic)  NSURL *testGroupURL;
@property (strong,nonatomic)  NSString *testGroupID;
@property (strong,nonatomic)  NSString *testGroupName;
@end

@implementation JVPeopleTest

- (void)setUp {
    
    [super setUp];
    
    _testPersonUsername=@"iosauto1";
    JiveSearchPeopleRequestOptions* searchPeopleoptions = [[JiveSearchPeopleRequestOptions alloc]init];
    [searchPeopleoptions addSearchTerm:_testPersonUsername];
    
    __block NSArray *returnedPerson = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 searchPeople:searchPeopleoptions onComplete:^(NSArray *results) {
            returnedPerson = results;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });
    
    for (JivePerson *person in returnedPerson) {
        if ( [person.jive.username isEqualToString: _testPersonUsername]) {
            _testPerson = person;
            _testPersonID = person.jiveId;
            _testPersonURL = person.selfRef;
        }
    }
    STAssertTrue([[_testPerson class] isSubclassOfClass:[JivePerson class]], @"Test failed at setup. Wrong class");
    STAssertTrue(_testPersonID != nil,  @"JVPeopleTest failed at setup. Person %@ not found", _testPersonUsername);
    STAssertTrue(_testPersonURL != nil,  @"JVPeopleTest failed at setup. URL for place %@ not found", _testPersonUsername);
    
    
    _testGroupName=@"iosAutoGroup1";
    JiveSearchPlacesRequestOptions* searchPlaceOptions = [[JiveSearchPlacesRequestOptions alloc]init];
    [searchPlaceOptions addSearchTerm:_testGroupName];
    
    __block NSArray *returnedPlaces = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 searchPlaces:searchPlaceOptions onComplete:^(NSArray *results) {
            returnedPlaces = results;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });
    
    for (JivePlace *place in returnedPlaces) {
        if ( [place.name isEqualToString: _testGroupName]) {
            _testGroup = place;
            _testGroupID = place.placeID;
            _testGroupURL = place.selfRef;
        }
    }
    STAssertTrue([[_testGroup class] isSubclassOfClass:[JivePlace class]], @"Test failed at setup. Wrong class");
    STAssertTrue(_testGroupID != nil,  @"Test failed at setup. Place %@ not found", _testGroupName);
    STAssertTrue(_testGroupURL != nil,  @"Test failed at setup. URL for place %@ not found", _testGroupName);
    
}

- (void)testGetPersonByPersonURL {
    NSString *expectedPersonDisplayName = @"iosAuto1 lastname1";
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"displayname"];
    
    __block JivePerson *returnedPerson = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 personFromURL:_testPersonURL onComplete:^(JivePerson *person) {
            returnedPerson = person;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    STAssertTrue([returnedPerson.displayName isEqualToString: expectedPersonDisplayName], @"person dislayname is not correct. Expected: %@, actual: ", expectedPersonDisplayName,returnedPerson.displayName );
    
}

- (void) testGetPeopleSortByUpdatedAsc {
    JivePeopleRequestOptions *options = [[JivePeopleRequestOptions alloc] init];
    options.sort = JiveSortOrderUpdatedAsc;;
    
    __block NSArray *returnedPeopleFromSDK = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1){
        [jive1 people:options onComplete:^(NSArray *people) {
            returnedPeopleFromSDK = people;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    NSLog(@"testListAllPeople: people count = %@", @([returnedPeopleFromSDK count]));
    
    NSString* getPeopleAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/people?sort=updatedAsc"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:getPeopleAPIURL];
    
    NSArray* returnedPeopleFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedPeopleFromSDK count], [returnedPeopleFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedPeopleFromSDK count], [returnedPeopleFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JivePerson* personFromSDK in returnedPeopleFromSDK) {
        id personFromAPI = [returnedPeopleFromAPI objectAtIndex:i];
        
        NSNumber* personFollowingCountFromAPI = [JVUtilities get_Person_followingCount:personFromAPI];
        NSString* personDisplayNameFromAPI = [JVUtilities get_Person_DisplayName:personFromAPI];
        
        STAssertEqualObjects(personFromSDK.displayName, personDisplayNameFromAPI, @"Expecting same display name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !",   personFromSDK.displayName, personDisplayNameFromAPI);
        STAssertEqualObjects(personFromSDK.followingCount, personFollowingCountFromAPI , @"Expecting same place display nme from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !", personFromSDK.followingCount, personFollowingCountFromAPI );
        i++;
    }
}

- (void)testGetPeopleByIDs {
    JivePeopleRequestOptions *peopleRequestOptions = [JivePeopleRequestOptions new];
    [peopleRequestOptions addID:_testPersonID];
    [peopleRequestOptions addField:@"displayName"];
    [peopleRequestOptions addField:@"followingCount"];
    
    __block NSArray *returnedPeopleFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock) {
        [jive1 people:peopleRequestOptions
           onComplete:^(NSArray *persons) {
               returnedPeopleFromSDK = persons;
               finishBlock();
           }
              onError:^(NSError *error) {
                  STFail([error localizedDescription]);
                  finishBlock();
              }];
    });
    NSString* getPeopleAPIURL =[ NSString stringWithFormat:@"%@%@%@", server, @"/api/core/v3/people?ids=", _testPersonID];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:getPeopleAPIURL];
    
    NSArray* returnedPeopleFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedPeopleFromSDK count], [returnedPeopleFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedPeopleFromSDK count], [returnedPeopleFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JivePerson* personFromSDK in returnedPeopleFromSDK) {
        id personFromAPI = [returnedPeopleFromAPI objectAtIndex:i];
        
        NSString* personDisplayNameFromAPI = [JVUtilities get_Person_DisplayName:personFromAPI];
        NSNumber* personFollowingCountFromAPI = [JVUtilities get_Person_followingCount:personFromAPI];
        
        STAssertEqualObjects(personFromSDK.displayName, personDisplayNameFromAPI, @"Expecting same display name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !",   personFromSDK.displayName, personDisplayNameFromAPI);
        STAssertEqualObjects(personFromSDK.followerCount, personFollowingCountFromAPI , @"Expecting same place display nme from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !", personFromSDK.followingCount, personFollowingCountFromAPI );
        i++;
    }
    
}

- (void)test_people_with_title_Software_Engineer {
    JivePeopleRequestOptions *peopleRequestOptions = [JivePeopleRequestOptions new];
    peopleRequestOptions.title = @"Software Engineer";
    
    __block NSArray *returnedPersons = nil;
    waitForTimeout(^(dispatch_block_t finishBlock) {
       [jive1 people:peopleRequestOptions
         onComplete:^(NSArray *persons) {
             returnedPersons = persons;
             finishBlock();
         }
            onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock();
            }];
    });
}

- (void)testGetPeopleByQuery {
    NSString *query = @"iosAuto";
    JivePeopleRequestOptions *peopleRequestOptions = [JivePeopleRequestOptions new];
    peopleRequestOptions.query = query;
    
    __block NSArray *returnedPeopleFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock) {
        [jive1 people:peopleRequestOptions
           onComplete:^(NSArray *people) {
               returnedPeopleFromSDK = people;
               finishBlock();
           }
              onError:^(NSError *error) {
                  STFail([error localizedDescription]);
                  finishBlock();
              }];
    });
    
    NSString* getPeopleAPIURL =[ NSString stringWithFormat:@"%@%@%@", server, @"/api/core/v3/people?query=", query];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:getPeopleAPIURL];
    
    NSArray* returnedPeopleFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedPeopleFromSDK count], [returnedPeopleFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedPeopleFromSDK count], [returnedPeopleFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JivePerson* personFromSDK in returnedPeopleFromSDK) {
        id personFromAPI = [returnedPeopleFromAPI objectAtIndex:i];
        
        NSNumber* personFollowerCountFromAPI = [JVUtilities get_Person_followerCount:personFromAPI];
        NSString* personDisplayNameFromAPI = [JVUtilities get_Person_DisplayName:personFromAPI];
        
        STAssertEqualObjects(personFromSDK.displayName, personDisplayNameFromAPI, @"Expecting same display name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !",   personFromSDK.displayName, personDisplayNameFromAPI);
        STAssertEqualObjects(personFromSDK.followerCount, personFollowerCountFromAPI , @"Expecting same place display nme from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !", personFromSDK.followerCount, personFollowerCountFromAPI );
        i++;
    }
    
}

- (void)testMe {
    NSString *meDisplayName = @"iosAuto1 lastname1";
    NSString *meUsername = @"iosauto1";
    
    __block JivePerson* me = nil;
    waitForTimeout(^(dispatch_block_t finishMeBlock) {
        [jive1 me:^(JivePerson *person) {
            STAssertNotNil(person, @"Missing me");
            me = person;
            finishMeBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishMeBlock();
        }];
    });
    
    STAssertTrue([me.displayName isEqualToString: meDisplayName], @"current user's dislayname is not correct. Expected: %@, actual: ", meDisplayName, me.displayName );
    STAssertTrue([me.jive.username isEqualToString: meUsername], @"curent user's username   is not correct. Expected: %@, actual: ", meUsername, me.jive.username);
}


- (void)testGetPersonByEmail {
    NSString *email = @"iosAuto2@jivesoftware.com";
    NSString *expectedPersonDisplayName = @"iosAuto2 lastname2";
    
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"displayName"];
    
    __block JivePerson* returnedPerson = nil;
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 personByEmail:email withOptions:options onComplete:^(JivePerson *person) {
            returnedPerson = person;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    STAssertTrue([returnedPerson.displayName isEqualToString: expectedPersonDisplayName], @"person dislayname is not correct. Expected: %@, actual: ", expectedPersonDisplayName,returnedPerson.displayName );
}

- (void)testGetPersonByUsername {
    NSString *username = @"iosauto2";
    NSString *expectedPersonDisplayName = @"iosAuto2 lastname2";
    
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"displayName"];
    
    __block JivePerson* returnedPersonFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 personByUserName:username withOptions:options onComplete:^(JivePerson *person) {
            returnedPersonFromSDK = person;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    STAssertTrue([returnedPersonFromSDK.displayName isEqualToString: expectedPersonDisplayName], @"person dislayname is not correct. Expected: %@, actual: ", expectedPersonDisplayName,returnedPersonFromSDK.displayName );
    
    NSString* getPeopleAPIURL =[ NSString stringWithFormat:@"%@%@%@", server, @"/api/core/v3//people/username/", username];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:getPeopleAPIURL];
    
    NSString* personDisplayNameFromAPI = [JVUtilities get_Person_DisplayName:jsonResponseFromAPI];
    
    //verify the display name  should be same between API and SDK
    STAssertEqualObjects(returnedPersonFromSDK.displayName, personDisplayNameFromAPI, @"Expecting same display name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !",   returnedPersonFromSDK.displayName, personDisplayNameFromAPI);
}


- (void)testGetRecommendedPeople {
   
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count=5;
    
    __block NSArray *returnedCommendedPeopleFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock) {
        [jive1 recommendedPeople:options onComplete:^(NSArray *people) {
               returnedCommendedPeopleFromSDK = people;
               finishBlock();
           }
              onError:^(NSError *error) {
                  STFail([error localizedDescription]);
                  finishBlock();
           }];
    });
    NSString* getRecommendedPeopleAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/people/recommended?count=5"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:getRecommendedPeopleAPIURL];
    
    NSArray* returnedRecommendedPeopleFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedCommendedPeopleFromSDK count], [returnedRecommendedPeopleFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedCommendedPeopleFromSDK count], [returnedRecommendedPeopleFromAPI count]);
}

- (void)testTrendingPeopleInGroup {
    
    JiveTrendingPeopleRequestOptions *options = [[JiveTrendingPeopleRequestOptions alloc] init];
    options.url=_testGroupURL;
    
    __block NSArray *returnedTrendingPeopleFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock) {
        [jive1 trending:options onComplete:^(NSArray *people) {
            returnedTrendingPeopleFromSDK = people;
            finishBlock();
        }
            onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock();
        }];
    });
    NSString* getTrendingPeopleAPIURL =[ NSString stringWithFormat:@"%@%@%@%@", server, @"/api/core/v3/people/trending?filter=place(", _testGroupURL, @")"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:getTrendingPeopleAPIURL];
    
    NSArray* returnedTrendingPeopleFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedTrendingPeopleFromSDK count], [returnedTrendingPeopleFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedTrendingPeopleFromSDK count], [returnedTrendingPeopleFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JivePerson* personFromSDK in returnedTrendingPeopleFromSDK) {
        id personFromAPI = [returnedTrendingPeopleFromAPI objectAtIndex:i];
        
        NSNumber* personFollowerCountFromAPI = [JVUtilities get_Person_followerCount:personFromAPI];
        NSString* personDisplayNameFromAPI = [JVUtilities get_Person_DisplayName:personFromAPI];
        
        STAssertEqualObjects(personFromSDK.displayName, personDisplayNameFromAPI, @"Expecting same display name from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !",   personFromSDK.displayName, personDisplayNameFromAPI);
        STAssertEqualObjects(personFromSDK.followerCount, personFollowerCountFromAPI , @"Expecting same place display nme from SDK and v3 API for this activity, sdk = '%@' , api = '%@' !", personFromSDK.followerCount, personFollowerCountFromAPI );
        i++;
    }
}

- (void)testAvatarForPerson {
     __block UIImage *returnedAvatarFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock) {
        [jive1  avatarForPerson:_testPerson onComplete:^(UIImage *returnedAvatar) {
            returnedAvatarFromSDK = returnedAvatar;
            finishBlock();
        }
            onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock();
            }];
    });
   STAssertNotNil(returnedAvatarFromSDK,  @"Avatar for user %@ is null", _testPersonUsername);
    STAssertTrue([[returnedAvatarFromSDK class] isSubclassOfClass:[UIImage class]], @"Test failed at setup. Wrong class");
    
}



- (void) testPersonActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    
    __block NSArray *returnedActivitiesFromSDK = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1){
        [jive1 activities:_testPerson withOptions:options onComplete:^(NSArray *activities) {
            returnedActivitiesFromSDK = activities;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    NSString* personActivityAPIURL =[ NSString stringWithFormat:@"%@%@%@%@", server, @"/api/core/v3/people/", _testPersonID, @"/activities"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:personActivityAPIURL];
    
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

- (void) testPersonStreams {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    
    __block NSArray *returnedStreamsFromSDK = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1){
        [jive1 streams:_testPerson withOptions:options onComplete:^(NSArray *activities) {
            returnedStreamsFromSDK = activities;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    NSString* personStreamsAPIURL =[ NSString stringWithFormat:@"%@%@%@%@", server, @"/api/core/v3/people/", _testPersonID, @"/streams"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:personStreamsAPIURL];
    
    NSArray* returnedStreamsFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedStreamsFromSDK count], [returnedStreamsFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedStreamsFromSDK count], [returnedStreamsFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JiveStream* streamFromSDK in returnedStreamsFromSDK) {
        
        id streamFromAPI = [returnedStreamsFromAPI objectAtIndex:i];
        
        NSString* streamNameFromAPI = [JVUtilities get_Stream_name:streamFromAPI];
        STAssertEqualObjects(streamFromSDK.name, streamNameFromAPI , @"Expecting same stream from SDK and v3 API for this stream, sdk = '%@' , api = '%@' !",   streamFromSDK.name, streamNameFromAPI );
        
        i++;
    }
}

- (void) testPersonBlog {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    
    __block JiveBlog *blogFromSDK = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock1){
        [jive1 blog:_testPerson withOptions:options onComplete:^(JiveBlog *blog) {
            blogFromSDK = blog;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    NSString* personBlogAPIURL =[ NSString stringWithFormat:@"%@%@%@%@", server, @"/api/core/v3/people/", _testPersonID, @"/blog"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:personBlogAPIURL];
    
    //verify the number returned rows between API and SDK
    NSString* blogNameFromAPI = [jsonResponseFromAPI objectForKey:@"name"];

    STAssertEqualObjects(blogFromSDK.name, blogNameFromAPI , @"Expecting same blog from SDK and v3 API for this stream, sdk = '%@' , api = '%@' !",   blogFromSDK.name, blogNameFromAPI );
    
}

- (void) testCreateTaskForPerson {
    JiveSortedRequestOptions *options = [[JiveSortedRequestOptions alloc] init];
    options.sort = JiveSortOrderDateCreatedAsc;
    
    __block NSArray *returnedTasksFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 tasks:_testPerson withOptions:options onComplete:^(NSArray *tasks) {
            returnedTasksFromSDK = tasks;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });
    
    NSString* tasksForPeopleAPIURL =[ NSString stringWithFormat:@"%@%@%@%s", server, @"/api/core/v3/people/", _testPersonID, "/tasks?sort=dateCreatedAsc"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:tasksForPeopleAPIURL];
    NSArray* returnedTasksListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedTasksFromSDK count], [returnedTasksListFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedTasksFromSDK count], [returnedTasksListFromAPI count]);
    
    // Create a task
    JiveTask *newTask = [[JiveTask alloc] init];
    NSString *subject = [NSString stringWithFormat:@"task-%d", (arc4random() % 1500000)];
    newTask.subject = subject;
    newTask.dueDate = [NSDate date];
    
    __block JiveTask *returnedTaskFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 createTask:newTask forPerson:_testPerson withOptions:options onComplete:^(JiveTask *task) {
            returnedTaskFromSDK = task;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    //Verify the number returned rows between API and SDK
    returnedTasksFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 tasks:_testPerson withOptions:options onComplete:^(NSArray *tasks) {
            returnedTasksFromSDK = tasks;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });

    jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:tasksForPeopleAPIURL];
    returnedTasksListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    STAssertEquals([returnedTasksFromSDK count], [returnedTasksListFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedTasksFromSDK count], [returnedTasksListFromAPI count]);

    //Verify each task's subject between SDK and API
    NSUInteger i = 0;
    for (JiveTask* aTaskFromSDK in returnedTasksFromSDK ) {
        
        id taskFromAPI = [returnedTasksListFromAPI objectAtIndex:i];
        
        NSString* aTaskSubjectFromAPI = [JVUtilities get_Project_task_subject:taskFromAPI];
        
        STAssertEqualObjects( aTaskFromSDK.subject, aTaskSubjectFromAPI , @"Expecting same results from SDK and v3 API for recent places for this user, sdk = '%@' , api = '%@' !",   aTaskFromSDK.subject, aTaskSubjectFromAPI);
        
        i++;
    }
    
    //Cleanup. Delete the task
    if (returnedTaskFromSDK != nil) {
        waitForTimeout(^(dispatch_block_t finishBlock1)   {
            [jive1 deleteContent:returnedTaskFromSDK onComplete:^ {
                finishBlock1();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock1();
            }];
        });
    }

}

@end
