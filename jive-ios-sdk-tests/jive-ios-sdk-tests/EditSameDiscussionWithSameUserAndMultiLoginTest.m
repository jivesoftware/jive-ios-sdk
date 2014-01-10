//! https://brewspace.jiveland.com/docs/DOC-158374
// linht  created 01/09/2014


#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface EditSameDiscussionWithSameUserAndMultiLoginTest : JiveTestCase

@end

@implementation EditSameDiscussionWithSameUserAndMultiLoginTest



- (void) testEditSameDiscussionWithSameUserAndMultiLogin{
    JiveDiscussion *post = [[JiveDiscussion alloc] init];
    
    __block JiveContent *testDis = nil;
    
    //create a doc for editing from userid1
    NSString* contentSubj = [NSString stringWithFormat:@"Test Discussion For testing edit support From SDK- %d", (arc4random() % 1500000)];
    NSLog(@"contentSubj = %@", contentSubj);
    
    post.subject = contentSubj;
    post.content = [[JiveContentBody alloc] init];
    post.content.type = @"text/html";
    post.content.text = @"<body><p>This is a discussion for testing locking support from SDK.</p></body>";
    
    [self waitForTimeout:^(dispatch_block_t finishBlock) {
        [jive1 createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
            STAssertEqualObjects([newPost class], [JiveDiscussion class], @"Wrong content created");
            testDis = newPost;
            finishBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock();
        }];
    }];
    
    STAssertEqualObjects(testDis.subject, post.subject, @"Unexpected subject: %@", [testDis toJSONDictionary]);
    
    
    //get the content from 'jive1' author to check if the newly created doc is in the stream
    NSString *myString = @"/api/core/v3/people/username/";
    NSString *apiString = [myString stringByAppendingString:userid1];
    
    NSLog(@"apiString=%@", apiString);
    
    NSString* apiUrl =[ NSString stringWithFormat:@"%@%@", server, apiString];
    NSLog(@"apiUrl=%@", apiUrl);
    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:apiUrl];
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
    JiveDiscussion* newlyCreatedContent;
    
    for (JiveContent* contentObj in contentsResults) {
        if ([contentObj isKindOfClass:[JiveDiscussion class]]){
            JiveDiscussion* p= ((JiveDiscussion*)(contentObj));
            
#ifdef SHOW_TEST_LOGS
            NSLog(@"doc subject=%@", p.subject);
#endif
            
            if ([p.subject isEqualToString:contentSubj]){
                found = true;
                newlyCreatedContent = p;
                break;
            }
        }
        
    }
    
    if (!found){
        STFail(@"Discussion was not found in the stream.");
    }
    
    //get userid1 person info
    __block JivePerson *personUser1 = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive1 me:^(JivePerson *person) {
            personUser1 = person;
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
    
    //set true to the editable property for the newly created doc
    [newlyCreatedContent.content setValue:@"YES" forKey:JiveContentBodyAttributes.editable];
    
    //jive1 block for editing
    __block JiveContent *modifiedDoc = nil;
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 updateContent:newlyCreatedContent withOptions:nil onComplete:^(JiveContent *results) {
            modifiedDoc = results;
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    
    newlyCreatedContent.content.text = @"<body><p>'ios-sdk-testuser1' modified the doc content with same user and different login object</p></body>";
    
    //jive4 (ios-sdk-testuser1) is trying to update the doc
    
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive4 updateContent:newlyCreatedContent withOptions:nil onComplete:^(JiveContent *results) {
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    
    
    
}


@end
