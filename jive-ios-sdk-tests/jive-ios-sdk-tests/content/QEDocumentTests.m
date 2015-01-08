//
//  QEDocumentTests.m
//  jive-ios-sdk-tests
//
//  Created by Orson Bushnell on 4/15/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "QEDocumentTests.h"


@implementation QEDocumentTests

- (void)setUp
{
    [super setUp];
    
    JiveSearchContentsRequestOptions *searchOptions = [[JiveSearchContentsRequestOptions alloc] init];
    __block NSArray *returnedContentsList = nil;
    NSString* docSubj = @"iOS-SDK-TestUser1 Document Subject1";
    
    searchOptions.search = @[docSubj];
    waitForTimeout(^(dispatch_block_t finishBlock3) {
        [jive1 searchContents:searchOptions onComplete:^(NSArray *results) {
            returnedContentsList = results;
            finishBlock3();
        } onError:^(NSError *error) {
            NSLog(@"Could not find the test content: %@", [error localizedDescription]);
            finishBlock3();
        }];
    });
    
    for (JiveContent *aContent in returnedContentsList) {
        if ([aContent.subject isEqualToString:docSubj]) {
            self.testContent = aContent;
        }
    }
    
    if (self.testContent == nil) {
        JiveDocument *post = [[JiveDocument alloc] init];
        __block JiveContent *testDoc = nil;
        
        NSLog(@"Creating test content");
        
        post.subject = docSubj;
        post.content = [[JiveContentBody alloc] init];
        post.content.type = @"text/html";
        post.content.text = @"<body><p>This is a test of the new doc creation from iPad SDK.</p></body>";
        
        waitForTimeout(^(dispatch_block_t finishBlock) {
            [jive1 createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
                STAssertEqualObjects([newPost class], [JiveDocument class], @"Wrong content created");
                
                testDoc = newPost;
                
                finishBlock();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock();
            }];
        });
        
        STAssertEqualObjects(testDoc.subject, post.subject, @"Unexpected person: %@", [testDoc toJSONDictionary]);
        
        self.testContent = testDoc;
        
    }
}

- (void)tearDown
{
    self.testContent = nil;
    [super tearDown];
}

@end
