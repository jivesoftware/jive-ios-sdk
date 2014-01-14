//! https://brewspace.jiveland.com/docs/DOC-158374
// linht  created 01/09/2014


#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface EditSameDocWithSameUserAndMultiLoginTest : JiveTestCase

@end

@implementation EditSameDocWithSameUserAndMultiLoginTest

- (void) testEditSameDocWithSameUserAndMultiLogin{
    JiveDocument *post = [[JiveDocument alloc] init];
    __block JiveContent *testDoc = nil;
    
    //create a doc for editing from userid1
    NSString* docSubj = [NSString stringWithFormat:@"Test Doc For testing edit support From SDK- %d", (arc4random() % 1500000)];
    NSLog(@"docSubj = %@", docSubj);
    
    post.subject = docSubj;
    post.content = [[JiveContentBody alloc] init];
    post.content.type = @"text/html";
    post.content.text = @"<body><p>This is a doc for testing locking support from iPad SDK.</p></body>";
    
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
    
    STAssertEqualObjects(testDoc.subject, post.subject, @"Unexpected subject: %@", [testDoc toJSONDictionary]);
    
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
    JiveDocument* newlyCreatedDoc;
    
    for (JiveContent* contentObj in contentsResults) {
        if ([contentObj isKindOfClass:[JiveDocument class]]){
            JiveDocument* p= ((JiveDocument*)(contentObj));            
#ifdef SHOW_TEST_LOGS
            NSLog(@"doc subject=%@", p.subject);
#endif
            if ([p.subject isEqualToString:docSubj]){
                found = true;
                newlyCreatedDoc = p;
                break;
            }
        }
    }
    
    if (!found){
        STFail(@"Document was not found in the stream.");
    }
    
   //lock newlyCreatedDoc by jive1
    __block JiveContent* blockContent;
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 lockContentForEditing:newlyCreatedDoc withOptions:nil onComplete:^(JiveContent *result) {
            blockContent = result;
            finishBlock2();
        } onError:^(NSError *error) {
            NSLog(@" Error Found: %@",  [error localizedDescription]);
            finishBlock2();
        }];
    }];    
    
    //check the editable property
    __block JiveContent *modifiedContent= nil;
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1  getEditableContent:newlyCreatedDoc withOptions:nil onComplete:^(JiveContent *results) {
            modifiedContent = results;
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    STAssertTrue([[[newlyCreatedDoc content] editable] intValue] == 1, nil);
    
    newlyCreatedDoc.content.text = @"<body><p>'ios-sdk-testuser1' modified the doc content with same user and different login object</p></body>";
    
    //jive4 (ios-sdk-testuser1) is trying to update the doc
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive4 updateContent:newlyCreatedDoc withOptions:nil onComplete:^(JiveContent *results) {
            finishBlock2();
        } onError:^(NSError *error) {
            STFail(@"The different instance of 'ios-sdk-testuser1' can't update the same doc succeed:  %@", [error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    
    
}


@end
