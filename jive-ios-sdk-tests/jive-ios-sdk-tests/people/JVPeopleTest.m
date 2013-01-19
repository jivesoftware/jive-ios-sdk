//
//  JVPeopleTest.m
//  jive-ios-sdk-tests
//
//  Created by Heath Borders on 1/17/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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
       [jive people:peopleRequestOptions
         onComplete:^(NSArray *persons) {
             returnedPersons = persons;
             finishBlock();
         }
            onError:^(NSError *error) {
                [self unexpectedErrorInWaitForTimeOut:error
                                          finishBlock:finishBlock];
            }];
    }];
    
    STAssertEquals((NSUInteger)1, [returnedPersons count], @"Unexpected persons: %@", [returnedPersons arrayOfJiveObjectJSONDictionaries]);
    JivePerson *person = returnedPersons[0];
    STAssertEqualObjects(@"ios-sdk-testuser1", person.jive.username, @"Unexpected person: %@", [person toJSONDictionary]);
    STAssertEqualObjects(@"lastname1", person.name.familyName, @"Unexpected person: %@", [person toJSONDictionary]);
    STAssertEqualObjects(@"iOS-SDKTestUser1 lastname1", person.name.formatted, @"Unexpected person: %@", [person toJSONDictionary]);
    STAssertEqualObjects(@"iOS-SDKTestUser1", person.name.givenName, @"Unexpected person: %@", [person toJSONDictionary]);
}

- (void) testCreateAndDestroyAStream {
    __block JivePerson *me = nil;
    [self waitForTimeout:^(dispatch_block_t finishMeBlock) {
        [jive me:^(JivePerson *person) {
            STAssertNotNil(person, @"Missing me");
            me = person;
            finishMeBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishMeBlock();
        }];
    }];

    JiveStream *stream = [[JiveStream alloc] init];
    __block JiveStream *testStream = nil;
    
    stream.name = @"Test stream 123456";
    [self waitForTimeout:^(dispatch_block_t finishCreateBlock) {
        [jive createStream:stream forPerson:me withOptions:nil onComplete:^(JiveStream *newPost) {
            testStream = newPost;
            finishCreateBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishCreateBlock();
        }];
    }];
    
    STAssertEqualObjects(testStream.name, stream.name, @"Unexpected stream: %@", [testStream toJSONDictionary]);
    STAssertEqualObjects(testStream.person.jiveId, me.jiveId, @"Unexpected stream: %@", [testStream toJSONDictionary]);
    STAssertNotNil(testStream.published, @"Unexpected stream: %@", [testStream toJSONDictionary]);
    
    [self waitForTimeout:^(dispatch_block_t finishDeleteBlock) {
        [jive deleteStream:testStream onComplete:^{
            finishDeleteBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishDeleteBlock();
        }];
    }];
}

@end
