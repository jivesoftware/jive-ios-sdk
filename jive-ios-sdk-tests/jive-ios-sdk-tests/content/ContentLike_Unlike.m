//
//  ContentLike_Unlike.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 1/25/13.
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

@interface ContentLike_Unlike : JiveTestCase

@end
 
@implementation ContentLike_Unlike



 
- (void) testContentLike_Unlike {
    
    JiveSearchContentsRequestOptions *searchOptions = [[JiveSearchContentsRequestOptions alloc] init];
    
  //  JiveContent *returnedContent = nil;
    __block NSArray *returnedContentsList = nil;
    
    NSString *docTitle = @"iOS-SDK-TestUser1 Document Subject2";
    

    [searchOptions addSearchTerm:docTitle];
    waitForTimeout(^(dispatch_block_t finishBlock3) {
        [jive2 searchContents:searchOptions onComplete:^(NSArray *results) {
            
            returnedContentsList = results;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    });
    
    
    JiveContent *testContent = nil;
    for (JiveContent *aContent in returnedContentsList) {
        if ([aContent.subject isEqualToString:docTitle]) {
            testContent = aContent;
        }
    }
        
    waitForTimeout(^(dispatch_block_t finishBlock2) {
        [jive1 content:testContent likes:FALSE onComplete:^{
            finishBlock2();
        } onError:^(NSError *error) {
            // If content was not already liked, then ignore this error
            // STFail([error localizedDescription]);
            finishBlock2();
        }];
    });
    
    
    JivePagedRequestOptions* options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 0;
    
    __block NSArray *returnedLikesListFromSDK = nil;
    __block NSArray *returnedLikesListFromSDK2 = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock2) {
        [jive2 contentLikedBy:testContent withOptions:options onComplete:^(NSArray *results) {
            returnedLikesListFromSDK = results;
            
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    });
    
    
    NSUInteger likeCountBefore = [returnedLikesListFromSDK count];
    
   
    waitForTimeout(^(dispatch_block_t finishBlock2) {
      [jive1 content:testContent likes:TRUE onComplete:^{
            finishBlock2();
      } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
      }];
    });
    
        
    waitForTimeout(^(dispatch_block_t finishBlock2) {
        [jive2 contentLikedBy:testContent withOptions:options onComplete:^(NSArray *results) {
            returnedLikesListFromSDK2 = results;
            
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    });
    
    
    NSUInteger likeCountAfter = [returnedLikesListFromSDK2 count];
         
    STAssertEquals(likeCountAfter, likeCountBefore + 1, @"Expecting likes counts should be increased by 1 on this document!");
    
}



@end
