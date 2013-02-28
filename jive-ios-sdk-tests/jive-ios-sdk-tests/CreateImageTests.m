//
//  CreateImageTests.m
//  jive-ios-sdk-tests
//
//  Created by Rob Derstadt on 2/27/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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
