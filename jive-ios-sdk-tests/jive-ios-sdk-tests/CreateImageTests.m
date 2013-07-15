//
//  CreateImageTests.m
//  jive-ios-sdk-tests
//
//  Created by Rob Derstadt on 2/27/13.
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
#import "JVUtilities.h"

@interface CreateImageTests : JiveTestCase

@end

@implementation CreateImageTests 

- (void) testImageUpload {
   
    NSString* imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"jive-software" ofType:@"png"];
    
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];
   
    [self waitForTimeout:^(dispatch_block_t finishBlock) {
        [[jive1 uploadImageOperation:image onComplete:^(JiveImage* jiveImage) {
            STAssertNotNil(jiveImage, @"Image result was nil");
            STAssertNotNil(jiveImage.ref, @"Image ref was nil");
            STAssertNotNil(jiveImage.jiveId, @"Image jiveId was nil");
            STAssertNotNil(jiveImage.size, @"Image size was nil");
            STAssertNotNil(jiveImage.type, @"Image type was nil");
            finishBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock();
        }] start];
    }];

}

@end
