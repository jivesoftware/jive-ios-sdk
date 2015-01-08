//
//  FollowPlace.m
//  jive-ios-sdk-tests
//
//  Created by Sherry Zhou on 6/20/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface FollowPlace : JiveTestCase
@property (strong,nonatomic)  __block NSMutableArray *customStreams;

@property (strong,nonatomic)  JivePlace *testPlace;
@property (strong,nonatomic)  NSString *testPlaceID;
@property (strong,nonatomic)  NSURL *testPlaceURL;
@property (strong,nonatomic)  NSString *groupName;
@end

@implementation FollowPlace
- (void)setUp {
    
    [super setUp];
    __block JivePerson *me = nil;
    
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
    
    //create 2 custom streams
    JiveStream *stream;
    _customStreams = [[NSMutableArray alloc] init];
    __block JiveStream *aCustomStream;
    for (int i = 1; i <= 2; i++) {
        stream = [[JiveStream alloc] init];
        stream.name = [NSString stringWithFormat:@"CustStrm-%d", (arc4random() % 1500000)];
        
        waitForTimeout(^(dispatch_block_t finishCreateBlock) {
            [jive1 createStream:stream forPerson:me withOptions:nil onComplete:^(JiveStream *newPost) {
                aCustomStream = newPost;
                finishCreateBlock();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
                aCustomStream = nil;
                finishCreateBlock();
            }];
        });
        if (aCustomStream != nil) {
            STAssertEqualObjects(aCustomStream.name, stream.name, @"Unexpected stream: %@", [aCustomStream toJSONDictionary]);
            [_customStreams addObject:aCustomStream];
        }
    }
    
    
    //Get place named 'iosAutoGroup1'
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
        }
    }
    STAssertTrue([[_testPlace class] isSubclassOfClass:[JivePlace class]], @"Test failed at setup. Wrong class");
    STAssertTrue(_testPlaceID != nil,  @"Test failed at setup. Place %@ not found", _groupName);

}

- (void)testFollowPlace {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    
    //follow the 2 custom streams
    __block NSArray *returnedStreams;
    
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 updateFollowingIn:_customStreams forPlace:_testPlace withOptions:options  onComplete:^(NSArray *results) {
            returnedStreams = results;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });
    
    //verify updateFollowingIn return expected  stream counts
    STAssertTrue([returnedStreams count]==2, @"should follow this place in one stream");
    
    //verify placeFollowingIn return expected stream name and counts
    returnedStreams = nil;
    waitForTimeout(^(dispatch_block_t finishBlock1) {
        [jive1 placeFollowingIn:_testPlace withOptions:options onComplete:^(NSArray *results) {
            returnedStreams = results;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    STAssertTrue([returnedStreams count]==2, @"should follow this place in 2 stream");
    
    NSUInteger i = 0;
    JiveStream *aCustomeStream = nil;
    for (JiveStream* aReturnedStreamFromSDK in returnedStreams) {
       aCustomeStream = [_customStreams objectAtIndex:i];
       STAssertEqualObjects(aCustomeStream.name, aReturnedStreamFromSDK.name, @"placeFollowingIn not return correct stream name. Expect='%s'. Actual='%s'", aCustomeStream.name, aReturnedStreamFromSDK.name);
       i++;
    }
    
    //Get followin stream from api
    NSString* placeFollowInAPIURL =[ NSString stringWithFormat:@"%@%@%@%s", server, @"/api/core/v3/places/", _testPlaceID, "/followingIn"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:placeFollowInAPIURL];
    NSArray* returnedtPlaceFollowInFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedStreams count], [returnedtPlaceFollowInFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i",
                   [returnedStreams count], [returnedtPlaceFollowInFromAPI count]);
    
    //verify name of followed custom stream between API and SDK
    NSString* aStreamNameFromAPI;
    i = 0;
    aCustomeStream = nil;
    for (JiveStream* aReturnedStreamFromSDK in returnedStreams) {
       
        aStreamNameFromAPI = [JVUtilities get_Stream_name:[returnedtPlaceFollowInFromAPI objectAtIndex:i]];
        STAssertEqualObjects(aReturnedStreamFromSDK.name, aStreamNameFromAPI , @"The returned stream name are not match. SDK='%s' API='%s'", aCustomeStream.name, aStreamNameFromAPI );
        i++;
    }

    //verify unfollow, follow first custom stream only
    NSArray *streamsToFollow = @[[_customStreams objectAtIndex:0]];
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 updateFollowingIn:streamsToFollow forPlace:_testPlace withOptions:options  onComplete:^(NSArray *results) {
            returnedStreams = results;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });
    
    STAssertTrue([returnedStreams count]==1, @"should follow this place in one stream");
    
    i = 0;
    aCustomeStream = nil;
    for (JiveStream* aReturnedStreamFromSDK in returnedStreams) {
        aCustomeStream = [_customStreams objectAtIndex:i];
        STAssertEqualObjects(aCustomeStream.name, aReturnedStreamFromSDK.name, @"placeFollowingIn not return correct stream name. Expect='%s'. Actual='%s'", aCustomeStream.name, aReturnedStreamFromSDK.name);
        i++;
    }
}

- (void)tearDown
{
    for (JiveStream *aCustomStream in _customStreams) {
        waitForTimeout(^(dispatch_block_t finishDeleteBlock) {
            [jive1 deleteStream:aCustomStream onComplete:^{
            finishDeleteBlock();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
            finishDeleteBlock();
            }];
        });
    }

    [super tearDown];
}
@end
