//
//  JiveVoteTests.m
//  jive-ios-sdk
//
//  Created by Ben Oberkfell on 7/24/14.
//
//    Copyright 2014 Jive Software Inc.
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

#include "JiveObjectTests.h"

@interface JiveVoteTests : JiveObjectTests

@end

@implementation JiveVoteTests

- (void)testPollVotesParsed {
    NSString* dummyPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"poll_results"
                                                                           ofType:@"json"];
    
    
    
    NSData* dummyContent = [NSData dataWithContentsOfFile:dummyPath];
    
    NSError *error;
    NSMutableDictionary *pollDictionary = [NSJSONSerialization
                                           JSONObjectWithData:dummyContent
                                           options:0
                                           error:&error];
    
    NSArray *votes = [JiveVote objectsFromJSONList:[pollDictionary objectForKey:@"list"] withInstance:self.instance];
    
    NSUInteger expectedOptionCount = 3;

    STAssertEquals([votes count], expectedOptionCount, @"Expected three options.");

    // The test data specifies 0 votes for A, 1 vote for B, 2 votes for C
    // so just use the array index as expected vote count
    NSArray *expectedOptionList = @[@"A", @"B", @"C"];
    
    for (NSUInteger i=0; i < [expectedOptionList count]; i++) {
        NSString *expectedOption = (NSString*)[expectedOptionList objectAtIndex:i];
        NSNumber *expectedCount = [NSNumber numberWithUnsignedInteger:i];
        
        JiveVote *thisVote = (JiveVote*)[votes objectAtIndex:i];
        
        STAssertTrue([expectedOption isEqualToString:thisVote.option], @"Expected option %@ to appear", expectedOption);
        STAssertEquals(thisVote.count, expectedCount, @"Vote count for %@ does not match expected %d", expectedOption, expectedCount);
    }
    
}


@end
