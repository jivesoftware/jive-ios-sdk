//! https://brewspace.jiveland.com/docs/DOC-158374
// linht  created 01/09/2014


#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface EditSameDocWithTwoUsersTest : JiveTestCase

@end

@implementation EditSameDocWithTwoUsersTest




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
    [newlyCreatedDoc.content setValue:@"YES" forKey:JiveContentBodyAttributes.editable];
    //set "EditingBy" to jive1
    newlyCreatedDoc.editingBy = personUser1;
    
    
    //jive1 block for editing
    __block JiveContent *modifiedDoc = nil;
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 updateContent:newlyCreatedDoc withOptions:nil onComplete:^(JiveContent *results) {
            modifiedDoc = results;
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    
    newlyCreatedDoc.content.text = @"<body><p>'ios-sdk-testuser1' modified the doc content with same user and different login object</p></body>";
    
    //jive4 (ios-sdk-testuser1) is trying to update the doc
    __block BOOL successBlock= TRUE;
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive4 updateContent:newlyCreatedDoc withOptions:nil onComplete:^(JiveContent *results) {
            successBlock = FALSE;
            finishBlock2();
        } onError:^(NSError *error) {
            NSLog(@" Error Found: %@",  [error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    //expected: error
    STAssertTrue(successBlock == TRUE, nil);
    
    
}


@end
