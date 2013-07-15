//
//  CreateAssociations.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 3/7/13.
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

@interface CreateAssociations : JiveTestCase

@end


@implementation CreateAssociations


- (void) testCreateStreamAssociation_Person {
  
    /*
     __block JivePerson *me = nil;
    
    
    [self waitForTimeout:^(dispatch_block_t finishMeBlock) {
        [jive1 me:^(JivePerson *person) {
            STAssertNotNil(person, @"Missing me");
            me = person;
            finishMeBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishMeBlock();
        }];
    }];
    
    
    
    
    NSString* streamName = [NSString stringWithFormat:@"CustStrm-%d", (arc4random() % 1500000)];
    
    JiveStream *stream = [[JiveStream alloc] init];
    __block JiveStream *testStream = nil;
    
    stream.name = streamName;
    
    
    [self waitForTimeout:^(dispatch_block_t finishCreateBlock) {
        [jive1 createStream:stream forPerson:me withOptions:nil onComplete:^(JiveStream *newPost) {
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
    
     JiveAssociationTargetList* jiveAssociationTargetList
       = [[JiveAssociationTargetList alloc] init];
        [jiveAssociationTargetList addAssociationTarget
    
    [self waitForTimeout:^(dispatch_block_t finishCreateBlock) {
        [jive1 createAssociations:stream forPerson:me withOptions:nil onComplete:^(JiveStream *newPost) {
            testStream = newPost;
            finishCreateBlock();
        } onError:^(NSError *error) {
            
            STFail([error localizedDescription]);
            finishCreateBlock();
        }];
    }];

    
    
    [self waitForTimeout:^(dispatch_block_t finishDeleteBlock) {
        [jive1 deleteStream:testStream onComplete:^{
            finishDeleteBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishDeleteBlock();
        }];
    }];
    */
    
}

@end
