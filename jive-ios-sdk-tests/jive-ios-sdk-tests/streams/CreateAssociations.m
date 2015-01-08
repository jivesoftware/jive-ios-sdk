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

#import "QEStreamsTests.h"

@interface CreateAssociations : QEStreamsTests
@property (strong,nonatomic)  JiveStream *testStream;
@end


@implementation CreateAssociations


- (void)setUp {
    
    [super setUp];
    
    JivePerson *me = [self getPerson:userid1];
    NSString* streamName = [NSString stringWithFormat:@"CustStrm-%d", (arc4random() % 1500000)];

    self.testStream = [self createCustomStream:streamName person:me];
    
    STAssertTrue(self.testStream != nil , @"Custom stream does not exist and is created properly");
    
}

- (void) testCreateStreamAssociations {
    
    //Add person to associate with this custom stream
    JiveAssociationTargetList* jiveAssociationTargetList = [[JiveAssociationTargetList alloc] init];
    JivePerson* user1 = [self getPerson:userid2];
    STAssertTrue(user1 != nil , @"user not found");
    if (!user1) {
        return;
    }
    
    [jiveAssociationTargetList addAssociationTarget:user1];
    
    //Add place to associate with this custom stream
    __block NSArray *searchResults = nil;
    
    NSString *groupName = @"iosAutoGroup1";
    JiveSearchPlacesRequestOptions* options = [[JiveSearchPlacesRequestOptions alloc]init];
    [options addSearchTerm:groupName];
    waitForTimeout(^(dispatch_block_t finishSearchBlock1) {
        [jive1 searchPlaces:options onComplete:^(NSArray *results) {
            searchResults= results;
            finishSearchBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishSearchBlock1();
        }];
    });
    
    
    JivePlace  *testGroup = nil;
    for (JivePlace *aGroup in searchResults) {
        if ([aGroup.name isEqualToString:groupName]) {
            testGroup = aGroup;
        }
    }
    
    STAssertTrue(testGroup != nil , @"%@ not found" , groupName);
    [jiveAssociationTargetList addAssociationTarget:testGroup];

    //Add content to associate with this custom stream
    JiveSearchContentsRequestOptions* contentOptions = [[JiveSearchContentsRequestOptions alloc]init];
    
    [contentOptions  addSearchTerm:@"Test Doc From SDK-*"];
    waitForTimeout(^(dispatch_block_t finishSearchBlock2) {
        [jive1 searchContents:contentOptions  onComplete:^(NSArray *results) {
            searchResults= results;
            finishSearchBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishSearchBlock2();
        }];
    });
    STAssertTrue(searchResults[0] != nil , @"content title starts with 'Test Doc From SDK'  not found");
    [jiveAssociationTargetList addAssociationTarget:searchResults[0]];
    
    //Create associations
    waitForTimeout(^(dispatch_block_t finishCreateBlock) {
        [jive1 createAssociations:jiveAssociationTargetList forStream:self.testStream onComplete:^{
            finishCreateBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishCreateBlock();
        }];
    });
    
    JiveAssociationsRequestOptions *associationOptions = [[JiveAssociationsRequestOptions alloc] init];
    
    __block NSArray *returnedAssociations = nil;
    waitForTimeout(^(dispatch_block_t finishGetBlock) {
        [associationOptions addType:@"document"];
        [associationOptions addType:@"person"];
        [associationOptions addType:@"group"];
        [jive1 streamAssociations:self.testStream withOptions:associationOptions onComplete:^(NSArray *associations) {
            returnedAssociations = associations;
            STAssertEquals([associations count], (NSUInteger)3, @"Wrong number of associations");
            finishGetBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishGetBlock();
        }];
    });
    
    NSLog(@"Number of associations returned from SDK=%@", @([returnedAssociations count]));
}

- (void)tearDown
{
    waitForTimeout(^(dispatch_block_t finishDeleteBlock) {
        [jive1 deleteStream:self.testStream onComplete:^{
            finishDeleteBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishDeleteBlock();
        }];
    });

    [super tearDown];
}


@end
