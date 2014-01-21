

#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface EditSameDocWithTwoUsersTest : JiveTestCase

@end

@implementation EditSameDocWithTwoUsersTest


- (void) testEditSameDocWithTwoUsers{
    
    //find the place 'iosAutoGroup1'
    JivePlacesRequestOptions *placesRequestOptions = [JivePlacesRequestOptions new];
    [placesRequestOptions addSearchTerm:@"iosAutoGroup1"];
    
    __block NSArray *returnedPlaces = nil;
    [self waitForTimeout:^(JiveTestCaseAsyncFinishBlock finishBlock) {
        [jive1 places:placesRequestOptions
           onComplete:^(NSArray *places) {
               returnedPlaces = places;
               finishBlock();
           }
              onError:^(NSError *error) {
                  STFail(@"error.  Can't find the place, 'iosAutoGroup1', to publish a doc to the place");
                  [self unexpectedErrorInWaitForTimeOut:error
                                            finishBlock:finishBlock];
              }];
    }];
    
    JivePlace* publishedPlace;
    if ( ([returnedPlaces count] > 0) && ([returnedPlaces[0] isKindOfClass:[JivePlace class]])){
       publishedPlace = (JivePlace*) [returnedPlaces objectAtIndex:0];
    }
    else{
        STFail(@"The returned class is not 'JivePlace' class");
    }
        
    
    __block JiveContent *testDoc = nil;
    //create a doc for editing from userid1
    NSString* docSubj = [NSString stringWithFormat:@"Test Doc For testing edit support From SDK- %d", (arc4random() % 1500000)];
    NSLog(@"docSubj = %@", docSubj);
    
    JiveDocument* post = [[JiveDocument alloc] init];
    post.subject = docSubj;
    post.content = [[JiveContentBody alloc] init];
    post.content.type = @"text/html";
    post.content.text = @"<body><p>This is a doc for testing locking support from iPad SDK.</p></body>";
    post.visibility = @"place";
    post.parent = publishedPlace.name;
    post.parent = publishedPlace.selfRef.absoluteString;
    
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
    
    newlyCreatedDoc.content.text = @"<body><p>'ios-sdk-testuser2' modified the doc content</p></body>";
    
    //userid2 is trying to update the doc
    __block BOOL successBlock= TRUE;
    __block NSString* errorCode;
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive2 updateContent:newlyCreatedDoc withOptions:nil onComplete:^(JiveContent *results) {
            successBlock = FALSE;
            finishBlock2();
        } onError:^(NSError *error) {
            errorCode = [error localizedDescription];
            finishBlock2();
        }];
    }];
    
    STAssertTrue(successBlock == TRUE, nil);
    STAssertTrue([errorCode rangeOfString:@"409"].location > 0, nil);
    
    
}



@end
