//
//  StreamActivities.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 2/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface StreamActivities : JiveTestCase

@end




@implementation StreamActivities

/*
- (void) testStreamActivities {
    
    JiveReturnFieldsRequestOptions *returnFieldOptions = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [returnFieldOptions addField:@"jive"];
    
    [returnFieldOptions addField:@"followerCount"];
    [returnFieldOptions addField:@"displayName"];
    
    
    __block JivePerson *returnedPerson = nil;
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 personByUserName:@"ios-sdk-testuser1"
                    withOptions:returnFieldOptions
         
                     onComplete:^(JivePerson *results) {
                         if (results!=nil)
                         {returnedPerson = results;
                         }
                         else NSLog(@"nil");
                         finishBlock3();
                     } onError:^(NSError *error) {
                         STFail([error localizedDescription]);
                         finishBlock3();
                     }];
    }];
    
    #ifdef SHOW_TEST_LOGS
      NSLog(@"person name=%@", returnedPerson.jive.username);
      NSLog(@"person name=%@", returnedPerson.displayName);
      NSLog(@"person name=%@", [returnedPerson followerCount]);
    #endif
    
    JiveReturnFieldsRequestOptions *returnFieldOptions2 = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [returnFieldOptions2 addField:@"id"];
    [returnFieldOptions2 addField:@"name"];
    [returnFieldOptions2 addField:@"source"];
    
    __block NSArray *returnedStreamsArray = nil;
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 streams:returnedPerson
           withOptions:returnFieldOptions2
         
            onComplete:^(NSArray *results) {
                
                returnedStreamsArray = results;
                finishBlock2();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock2();
            }];
    }];
    
    JiveStream *testCustomStream = nil;
    
    NSString *testStream = @"TestStream1";
    
    for (JiveStream *stream in returnedStreamsArray) {
       if ([stream.name isEqualToString:testStream])
        {
            testCustomStream = stream;
            break;
        }
    }
    
    JiveResourceEntry *resourceEntry = testCustomStream.selfRef;
    NSString* streamURL = [resourceEntry.ref absoluteString];
    
    #ifdef SHOW_TEST_LOGS
      NSLog(@"stream URL=%@",  streamURL);
    #endif
    
    NSString* afterDate = @"2012-12-01T23:13:29.851+0000";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    
    NSDate* dateSDK = [dateFormat dateFromString:afterDate ];
    NSLog(@"dateSDK='%@'", dateSDK);
    
    JiveDateLimitedRequestOptions* jiveDateLimitedRequestOptions = [[JiveDateLimitedRequestOptions alloc] init];
    jiveDateLimitedRequestOptions.after = dateSDK;
    
    __block NSArray *returnedActivitiesArray = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 streamActivities:testCustomStream
                      withOptions:jiveDateLimitedRequestOptions
         
                        onComplete:^(NSArray *results) {
                           
                           returnedActivitiesArray = results;
                           finishBlock2();
                       } onError:^(NSError *error) {
                           STFail([error localizedDescription]);
                           finishBlock2();
                       }];
    }];
    
    #ifdef SHOW_TEST_LOGS
      NSLog(@"Number of Actitivies returned from SDK=%i", [returnedActivitiesArray count]);
    #endif
   // /streams/{streamID}/activities
    
    NSString* streamURLForActivities = [streamURL stringByAppendingString: @"/activities"];
    
    // get the stream activities count for the doc through v3 API and Verify
    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:streamURLForActivities ];
    NSArray* returnedActivitiesListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
        
    NSLog(@"Number of Actitivies returned from v3 API=%i", [returnedActivitiesListFromAPI count]);
    
    
    STAssertEquals([returnedActivitiesArray count], [returnedActivitiesListFromAPI count], @"Expecting same activities count in custom streams, from SDK and API");


  }

*/

@end
