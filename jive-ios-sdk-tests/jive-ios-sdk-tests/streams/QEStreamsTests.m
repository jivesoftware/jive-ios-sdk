//
//  QEStreamsTests.m
//  jive-ios-sdk-tests
//
//  Created by Sherry Zhou on 5/21/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "QEStreamsTests.h"

@implementation QEStreamsTests

- (JivePerson*) getPerson:(NSString*)username {
    JiveReturnFieldsRequestOptions *returnFieldOptions = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [returnFieldOptions addField:@"jive"];
    [returnFieldOptions addField:@"followerCount"];
    [returnFieldOptions addField:@"displayName"];
    
    __block JivePerson *returnedPerson = nil;
    waitForTimeout(^(dispatch_block_t finishBlock3) {
        [jive1 personByUserName:username
                    withOptions:returnFieldOptions
                    onComplete:^(JivePerson *results) {
                        if (results!=nil) {
                            returnedPerson = results;
                         } else
                             NSLog(@"nil");
                         finishBlock3();
                     } onError:^(NSError *error) {
                         STFail([error localizedDescription]);
                         finishBlock3();
                     }];
    });
    
#ifdef SHOW_TEST_LOGS
    NSLog(@"person name=%@", returnedPerson.jive.username);
    NSLog(@"person name=%@", returnedPerson.displayName);
    NSLog(@"person name=%@", [returnedPerson followerCount]);
#endif
    return returnedPerson;
}

- (JiveStream*)findCustomStream:(NSString*)customStreamName person:(JivePerson*)person {
    JiveReturnFieldsRequestOptions *returnFieldOptions = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [returnFieldOptions addField:@"id"];
    [returnFieldOptions addField:@"name"];
    [returnFieldOptions addField:@"source"];
    
    __block NSArray *returnedStreamsArray = nil;
    waitForTimeout(^(dispatch_block_t finishBlock2) {
        [jive1 streams:person
           withOptions:returnFieldOptions
            onComplete:^(NSArray *results) {
                returnedStreamsArray = results;
                finishBlock2();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock2();
            }];
    });
    
    JiveStream* testCustomStream = nil;
    
    for (JiveStream *stream in returnedStreamsArray) {
        if ([stream.name isEqualToString:customStreamName])
        {
            testCustomStream = stream;
            break;
        }
    }
    return testCustomStream;
}

- (JiveStream*)createCustomStream:(NSString*)customStreamName person:(JivePerson*)person {
    JiveStream *stream = [[JiveStream alloc] init];
    stream.name = customStreamName;
    
    __block JiveStream *testStream = [self findCustomStream:customStreamName person:person] ;
    
    if (testStream == nil ) {
        waitForTimeout(^(dispatch_block_t finishCreateBlock) {
            [jive1 createStream:stream forPerson:person withOptions:nil onComplete:^(JiveStream *newPost) {
                testStream = newPost;
                finishCreateBlock();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishCreateBlock();
            }];
        });
        STAssertEqualObjects(testStream.name, customStreamName, @"Unexpected stream: %@", [testStream toJSONDictionary]);
        STAssertEqualObjects(testStream.person.jiveId, person.jiveId, @"Unexpected stream: %@", [testStream toJSONDictionary]);
        STAssertNotNil(testStream.published, @"Unexpected stream: %@", [testStream toJSONDictionary]);
    }
    
    return testStream;
}

-(void) followPerson:(JivePerson *)person inStream:(JiveStream *)stream {
    JiveReturnFieldsRequestOptions *returnFieldOptions = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [returnFieldOptions addField:@"id"];
    [returnFieldOptions addField:@"name"];
    [returnFieldOptions addField:@"source"];
    
    __block NSArray *followingStreamsArray = [NSArray array];
    waitForTimeout(^(dispatch_block_t finishBlock2) {
        [jive1 followingIn:person
           withOptions:returnFieldOptions
           onComplete:^(NSArray *results) {
                followingStreamsArray = results;
                finishBlock2();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock2();
        }];
    });
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:followingStreamsArray];
    [array addObject:stream];
    followingStreamsArray = [NSArray arrayWithArray:array];
    waitForTimeout(^(dispatch_block_t finishBlock2) {
        [jive1 updateFollowingIn:followingStreamsArray forPerson:person
                withOptions:returnFieldOptions
                onComplete:^(NSArray *results) {
                    followingStreamsArray = results;
                    finishBlock2();
                } onError:^(NSError *error) {
                    STFail([error localizedDescription]);
                    finishBlock2();
                }];
    });
}

@end
