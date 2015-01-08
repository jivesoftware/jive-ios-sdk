//
//  CreateDeletePlace.m
//  jive-ios-sdk-tests
//
//  Created by Sherry Zhou on 6/24/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface CreateDeletePlace : JiveTestCase
@property (strong,nonatomic)  NSString *testGroupID;
@end

@implementation CreateDeletePlace

- (void)testCreateDeleteGroup {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"displayName"];
    [options addField:@"placeID"];
    
    // Create a open group
    JiveGroup *newGroup = [[JiveGroup alloc] init];
    NSString *name = [NSString stringWithFormat:@"group-%d", (arc4random() % 1500000)];
    newGroup.groupType = @"OPEN";
    newGroup.name = name;
    newGroup.displayName = [NSString stringWithFormat:@"new group created via SDK %@", name];
    
    __block JivePlace *returnedPlace = nil;
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 createPlace:newGroup withOptions:options onComplete:^(JivePlace *place) {
            returnedPlace = place;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    //Verify display name is set correctly by SDK
    STAssertTrue([returnedPlace.name isEqualToString: name], @"group not created correctly. Expected=%@, Actual=%@", name, returnedPlace.name);
    
    //Verify  v3 api can retrive this group and shows correct display name
    NSString* placeAPIURL =[ NSString stringWithFormat:@"%@%@%@", server, @"/api/core/v3/places/", returnedPlace.placeID];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:placeAPIURL];
    NSString* placeDisplayNameFromAPI = [JVUtilities get_Place_displayName:jsonResponseFromAPI];
    
    STAssertEqualObjects(returnedPlace.displayName, placeDisplayNameFromAPI , @"Expecting group with display name is found via  v3 api, expected = '%@' , api = '%@' !",
                         returnedPlace.displayName, placeDisplayNameFromAPI );
    
    //Delete this group
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 deletePlace:returnedPlace onComplete:^() {
                         finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });

    //Verify searchPlace SDK return 0 group
    JiveSearchPlacesRequestOptions* searchOptions = [[JiveSearchPlacesRequestOptions alloc]init];
    [searchOptions addSearchTerm:name];
    
    __block NSArray *returnedPlaces = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 searchPlaces:searchOptions onComplete:^(NSArray *results) {
            returnedPlaces = results;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });

    STAssertTrue([returnedPlaces count]==0, @"group %@ should be deleted successfully. But actually not", name);
    
    //Verify v3 api return 404 when retrive this group by placeID
    placeAPIURL =[ NSString stringWithFormat:@"%@%@%@", server, @"/api/core/v3/places/", returnedPlace.placeID];
    jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:placeAPIURL];
    long errorStatusFromAPI = [JVUtilities get_Error_status:jsonResponseFromAPI];
    STAssertTrue(errorStatusFromAPI == 404, @"group %@ should be deleted successfully. But actually not", name);
}

@end
