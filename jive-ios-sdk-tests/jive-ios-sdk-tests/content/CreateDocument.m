//
//  CreateDocument.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 1/31/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface CreateDocument : JiveTestCase

@end

@implementation CreateDocument

- (void) testCreateDocument {
JiveDocument *post = [[JiveDocument alloc] init];
__block JiveContent *testDoc = nil;

NSString* docSubj = [NSString stringWithFormat:@"Test Doc From SDK- %d", (arc4random() % 1500000)];

post.subject = docSubj;
post.content = [[JiveContentBody alloc] init];
post.content.type = @"text/html";
post.content.text = @"<body><p>This is a test of the new doc creation from iPad SDK.</p></body>";

[self waitForTimeout:^(dispatch_block_t finishBlock) {
    [jive1 createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
        STAssertEqualObjects([newPost class], [JiveDocument class], @"Wrong content created");
        
        testDoc = newPost;
        
        finishBlock();
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
        finishBlock();
    }];
}];

STAssertEqualObjects(testDoc.subject, post.subject, @"Unexpected person: %@", [testDoc toJSONDictionary]);

    
    
    
    NSString *myString = @"/api/core/v3/people/username/";
    NSString *apiString = [myString stringByAppendingString:userid1];
    
    NSLog(@"apiString=%@", apiString);
    
    NSString* apiUrl =[ NSString stringWithFormat:@"%@%@", server, apiString];
    NSLog(@"apiUrl=%@", apiUrl);
    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:apiUrl];
    
    // NSArray* returnedAPIPersons = [jsonResponseFromAPI objectForKey:@"list"];
    // id personAPI = [returnedAPIPersons objectAtIndex:0];
    
    NSString* authorStr = [JVUtilities get_Resource_self:jsonResponseFromAPI];
    
    NSURL* authorURL = [[NSURL alloc] initWithString:authorStr];
    
    NSLog(@"authorURL=%@", authorURL);
    
    
__block NSArray *contentsResults = nil;
JiveContentRequestOptions* jiveContentRequestOptions = [[JiveContentRequestOptions alloc] init];

[jiveContentRequestOptions addAuthor:authorURL];


[self waitForTimeout:^(dispatch_block_t finishBlock2) {
    [jive1 contents:jiveContentRequestOptions onComplete:^(NSArray* results) {
        contentsResults = results;
        finishBlock2();
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
        finishBlock2();
    }];
}];

BOOL found = FALSE;

for (JiveContent* contentObj in contentsResults) {
  
    if ([contentObj isKindOfClass:[JiveDocument class]])
    {            
        JiveDocument* p= ((JiveDocument*)(contentObj));
       
        #ifdef SHOW_TEST_LOGS
          NSLog(@"doc subject=%@", p.subject);
        #endif
       
        if ([p.subject isEqualToString:docSubj])
        {
            found = true;
        }
    }
    
}

if (!found)
{
    STFail(@"Document was not created successfully.");
}

}

@end
