//! https://brewspace.jiveland.com/docs/DOC-158374
// linht  created 01/09/2014


#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface EditSameDiscussionWithSameUserAndMultiLoginTest : JiveTestCase

@end

@implementation EditSameDiscussionWithSameUserAndMultiLoginTest



- (void) testEditSameDiscussionWithSameUserAndMultiLogin{
    
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
    NSString* docSubj = [NSString stringWithFormat:@"Test discussion For testing edit support From SDK- %d", (arc4random() % 1500000)];
    NSLog(@"docSubj = %@", docSubj);
    
    JiveDiscussion* post = [[JiveDiscussion alloc] init];
    post.subject = docSubj;
    post.content = [[JiveContentBody alloc] init];
    post.content.type = @"text/html";
    post.content.text = @"<body><p>This is a discussion for testing locking support from SDK.</p></body>";
    post.visibility = @"place";
    post.parent = publishedPlace.name;
    post.parent = publishedPlace.selfRef.absoluteString;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock) {
        [jive1 createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
            STAssertEqualObjects([newPost class], [JiveDiscussion class], @"Wrong content created");
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
    JiveDiscussion* newlyCreatedDis;
    
    for (JiveContent* contentObj in contentsResults) {
        if ([contentObj isKindOfClass:[JiveDiscussion class]]){
            JiveDiscussion* p= ((JiveDiscussion*)(contentObj));
#ifdef SHOW_TEST_LOGS
            NSLog(@"dis subject=%@", p.subject);
#endif
            if ([p.subject isEqualToString:docSubj]){
                found = true;
                newlyCreatedDis = p;
                break;
            }
        }
    }
    
    if (!found){
        STFail(@"Document was not found in the stream.");
    }
    
    //lock newlyCreatedDis by jive1
    __block JiveContent* blockContent;
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 lockContentForEditing:newlyCreatedDis withOptions:nil onComplete:^(JiveContent *result) {
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
        [jive1  getEditableContent:newlyCreatedDis withOptions:nil onComplete:^(JiveContent *results) {
            modifiedContent = results;
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    STAssertTrue([[[newlyCreatedDis content] editable] intValue] == 1, nil);
    
    newlyCreatedDis.content.text = @"<body><p>'ios-sdk-testuser2' modified the doc content</p></body>";
    
    //userid4 (the userid login as jive1) is updating a discussion
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive4 updateContent:newlyCreatedDis withOptions:nil onComplete:^(JiveContent *results) {
            finishBlock2();
        } onError:^(NSError *error) {
            STFail(@"%@", [error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    
}


@end
