//
//  SearchPeople.m
//  jive-ios-sdk-tests
//
//  Created by Linh Tran on 1/30/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//


#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface SearchPeople : JiveTestCase

@end

@implementation SearchPeople

-(void) test_searchPeople
{
    NSLog ( @"Starting test case --  'searchPeople'  with 'ios' and default sorting (descending)");
    
    JiveSearchPeopleRequestOptions* options = [[JiveSearchPeopleRequestOptions alloc]init];
    [options addSearchTerm:@"ios"];
  
    
    __block NSArray *returnedSDKPersons = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 searchPeople:options onComplete:^(NSArray *results) {
            returnedSDKPersons = results;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    
    //get the jsons response from API
   /* NSString* apiUrl = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/search/people?filter=search(ios)";
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:apiUrl];
    */
    NSString* apiUrl =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/search/people?filter=search(ios)"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:apiUrl];
    
    
    NSArray* returnedAPIPersons = [jsonResponseFromAPI objectForKey:@"list"];
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedSDKPersons count], [returnedAPIPersons count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedSDKPersons count], [returnedAPIPersons count]);
    
    //verify the 1st of returned row from API and SDK;
    JivePerson *personSDK = returnedSDKPersons[0];
    id personAPI = [returnedAPIPersons objectAtIndex:0];
 
    #ifdef SHOW_TEST_LOGS
      NSLog(@" personAPI = %@", personAPI);
    #endif
    
    STAssertEqualObjects([personSDK displayName], [JVUtilities get_Person_DisplayName:personAPI], @"The 'displayName' of SDK and API are not matched.  SDK = %@ and API = %@", [personSDK displayName], [JVUtilities get_Person_DisplayName:personAPI]);
    
    STAssertEqualObjects([personSDK jiveId], [JVUtilities get_Person_JiveId:personAPI], @"The 'jiveId' of SDK and API are not matched.  SDK = %@ and API = %@", [personSDK jiveId], [JVUtilities get_Person_JiveId:personAPI]);
    
    STAssertEqualObjects([[personSDK name] givenName], [JVUtilities get_Person_giveName:personAPI], @"The 'givenName' of SDK and API are not matched.  SDK = %@ and API = %@", [[personSDK name] givenName], [JVUtilities get_Person_giveName:personAPI]);
    
    STAssertEqualObjects([[personSDK name] familyName], [JVUtilities get_Person_familyName:personAPI], @"The 'familyName' of SDK and API are not matched.  SDK = %@ and API = %@", [[personSDK name] familyName], [JVUtilities get_Person_familyName:personAPI]);
    
    STAssertEqualObjects([[personSDK name] formatted], [JVUtilities get_Person_formattedName:personAPI], @"The 'formatted' of SDK and API are not matched.  SDK = %@ and API = %@", [[personSDK name] formatted], [JVUtilities get_Person_formattedName:personAPI]);
    
    STAssertEqualObjects([personSDK location], [JVUtilities get_Person_location:personAPI], @"The 'location' of SDK and API are not matched.  SDK = %@ and API = %@", [personSDK location], [JVUtilities get_Person_location:personAPI]);
    
    STAssertEqualObjects([personSDK type], [JVUtilities get_Person_type:personAPI], @"The 'type' of SDK and API are not matched.  SDK = %@ and API = %@", [personSDK type], [JVUtilities get_Person_type:personAPI]);
    
    STAssertEqualObjects([personSDK published], [JVUtilities get_Person_published:personAPI], @"The 'published' of SDK and API are not matched.  SDK = %@ and API = %@", [personSDK published], [JVUtilities get_Person_published:personAPI]);
    
    STAssertEquals([personSDK followerCount], [JVUtilities get_Person_followerCount:personAPI], @"The 'followerCount' of SDK and API are not matched.  SDK = %i and API = %i", [personSDK followerCount], [JVUtilities get_Person_followerCount:personAPI]);
    
    STAssertEquals([personSDK followingCount], [JVUtilities get_Person_followingCount:personAPI], @"The 'followingCount' of SDK and API are not matched.  SDK = %i and API = %i", [personSDK followingCount], [JVUtilities get_Person_followingCount:personAPI]);
    
    STAssertEqualObjects([personSDK thumbnailUrl], [JVUtilities get_Person_thurbnailUrl:personAPI], @"The 'thumbnailUrl' of SDK and API are not matched.  SDK = %@ and API = %@", [personSDK thumbnailUrl], [JVUtilities get_Person_thurbnailUrl:personAPI]);
    
    STAssertEqualObjects([personSDK updated], [JVUtilities get_Person_updated:personAPI], @"The 'thumbnailUrl' of SDK and API are not matched.  SDK = %@ and API = %@", [personSDK updated], [JVUtilities get_Person_updated:personAPI]);
    
}

@end
