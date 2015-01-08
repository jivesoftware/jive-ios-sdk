//
//  StreamActivities.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 2/4/13.
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

#import "QEStreamsTests.h"
#import "JVUtilities.h"

@interface StreamActivities : QEStreamsTests;
@property (strong,nonatomic)  JiveStream *testCustomStream;
@end


@implementation StreamActivities

- (void)setUp {

    [super setUp];
    
    JivePerson *me = [self getPerson:userid1];
    self.testCustomStream = [self createCustomStream:@"TestStream1" person:me];
    
    STAssertTrue(self.testCustomStream != nil , @"Custom stream does not exist and is created properly");

    JivePerson* user = [ self getPerson:userid2];
    [self followPerson:user inStream:self.testCustomStream];
    
   }

- (void) testStreamActivities {
    
    NSString* streamURL = [self.testCustomStream.selfRef absoluteString];
    
    #ifdef SHOW_TEST_LOGS
      NSLog(@"stream URL=%@",  streamURL);
    #endif
    
    NSString* afterDate = @"2014-01-01T23:13:29.851+0000";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    
    NSDate* dateSDK = [dateFormat dateFromString:afterDate ];
    NSLog(@"dateSDK='%@'", dateSDK);
    
    JiveDateLimitedRequestOptions* jiveDateLimitedRequestOptions = [[JiveDateLimitedRequestOptions alloc] init];
    jiveDateLimitedRequestOptions.after = dateSDK;
    
    __block NSArray *returnedActivitiesArray = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock2) {
        [jive1 streamActivities:self.testCustomStream
                      withOptions:jiveDateLimitedRequestOptions
         
                        onComplete:^(NSArray *results) {
                           
                           returnedActivitiesArray = results;
                           finishBlock2();
                       } onError:^(NSError *error) {
                           STFail([error localizedDescription]);
                           finishBlock2();
                       }];
    });
    
    //#ifdef SHOW_TEST_LOGS
      NSLog(@"Number of Actitivies returned from SDK=%@", @([returnedActivitiesArray count]));
   // #endif
    
    // /streams/{streamID}/activities
    NSString* streamURLForActivities = [streamURL stringByAppendingString: @"/activities"];
    
    // get the stream activities count for the doc through v3 API and Verify
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:streamURLForActivities ];
    NSArray* returnedActivitiesListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
        
    NSLog(@"Number of Actitivies returned from v3 API=%@", @([returnedActivitiesListFromAPI count]));
    
    STAssertEquals([returnedActivitiesArray count], [returnedActivitiesListFromAPI count], @"Expecting same activities count in custom streams, from SDK and API");
  }

@end
