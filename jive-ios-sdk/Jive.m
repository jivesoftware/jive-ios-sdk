//
//  Jive.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
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

#import "Jive.h"
#import "JAPIRequestOperation.h"
#import "NSData+JiveBase64.h"
#import "NSError+Jive.h"
#import "JiveTargetList_internal.h"
#import "JiveAssociationTargetList_internal.h"
#import "JiveNSDictionary+URLArguments.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "NSData+JiveBase64.h"
#import "JiveTypedObject_internal.h"

@interface JiveInvite (internal)

+ (NSString *) jsonForState:(enum JiveInviteState)state;

@end

@interface NSURL (JiveDateParameterValue)

- (NSDate *)jive_dateFromValueOfParameterWithName:(NSString *)parameterName;

@end

@interface Jive() {
    
@private
    __weak id<JiveAuthorizationDelegate> _delegate;
    __strong NSURL* _jiveInstance;
}

@property(nonatomic, strong) NSURL* jiveInstance;

@end

@implementation Jive

@synthesize jiveInstance = _jiveInstance;

+ (NSOperation *)getVersionOperationForInstance:(NSURL *)jiveInstanceURL onComplete:(void (^)(JivePlatformVersion *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURL* requestURL = [NSURL URLWithString:@"api/version"
                               relativeToURL:jiveInstanceURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:requestURL];
    JAPIRequestOperation *operation = [self operationWithRequest:request
                                                          onJSON:(^(id JSON) {
        JivePlatformVersion *platformVersion = [JivePlatformVersion instanceFromJSON:JSON];
        if (platformVersion) {
            BOOL foundValidCoreVersion = NO;
            for (JiveCoreVersion *coreURI in platformVersion.coreURI) {
                if ([coreURI.version isEqualToNumber:@3]) {
                    foundValidCoreVersion = YES;
                    break;
                }
            }
            
            if (foundValidCoreVersion) {
                if (completeBlock) {
                    completeBlock(platformVersion);
                }
            } else {
                if (errorBlock) {
                    errorBlock([NSError jive_errorWithUnsupportedJivePlatformVersion:platformVersion]);
                }
            }
        } else {
            if (errorBlock) {
                errorBlock([NSError jive_errorWithUnderlyingError:nil
                                                             JSON:JSON]);
            }
        }
    })
                                                         onError:errorBlock];
    return operation;
}

+ (void)getVersionForInstance:(NSURL *)jiveInstanceURL onComplete:(void (^)(JivePlatformVersion *))completeBlock onError:(JiveErrorBlock)errorBlock {
    [[Jive getVersionOperationForInstance:jiveInstanceURL
                               onComplete:completeBlock
                                  onError:errorBlock] start];
}

+ (void)initialize {
	if([[NSData class] instanceMethodSignatureForSelector:@selector(jive_base64EncodedString:)] == NULL)
		[NSException raise:NSInternalInconsistencyException format:@"** Expected method not present; the method jive_base64EncodedString: is not implemented by NSData. If you see this exception it is likely that you are using the static library version of Jive and your project is not configured correctly to load categories from static libraries. Did you forget to add the -ObjC and -all_load linker flags?"];
}


- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL
      authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate {
    
    
    if(!jiveInstanceURL) {
        [NSException raise:@"Jive jiveInstanceURL may not be nil." format:nil];
    }
    
    if(self = [super init]) {
        _jiveInstance = jiveInstanceURL;
        _delegate = delegate;
    }
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return self;
}

- (NSURL*) jiveInstanceURL {
    return _jiveInstance;
}

#pragma mark - helper methods

- (NSOperation *) getPeopleArray:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:@"api/core/v3/%@",
                             callName,
                             nil];
    
    return [self listOperationForClass:[JivePerson class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (NSOperation *) peopleResourceOperation:(NSURL *)url withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:[url path],
                             nil];
    
    return [self listOperationForClass:[JivePerson class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (NSOperation *)personResourceOperation:(NSURL *)url withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:[url path],
                             nil];
    
    return [self entityOperationForClass:[JivePerson class]
                                 request:request
                              onComplete:completeBlock
                                 onError:errorBlock];
}

- (NSOperation *)activitiesResourceOperation:(NSURL *)url withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:[url path],
                             nil];
    
    return [self listOperationForClass:[JiveActivity class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (NSOperation *)streamsResourceOperation:(NSURL *)url withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:[url path],
                             nil];
    
    return [self listOperationForClass:[JiveStream class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (NSOperation *)contentsResourceOperation:(NSURL *)url withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:[url path],
                             nil];
    
    return [self listOperationForClass:[JiveContent class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (NSOperation *)personByOperation:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:@"api/core/v3/people/%@",
                             personId,
                             nil];
    NSOperation *operation = [self entityOperationForClass:[JivePerson class]
                                                   request:request
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    return operation;
}

- (NSOperation *) contentsListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:@"api/core/v3/%@",
                             callName,
                             nil];
    NSOperation *operation = [self listOperationForClass:[JiveContent class]
                                                 request:request
                                              onComplete:completeBlock
                                                 onError:errorBlock];
    return operation;
}

- (NSOperation *) placeListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:@"api/core/v3/%@",
                             callName,
                             nil];
    NSOperation *operation = [self listOperationForClass:[JivePlace class]
                                                 request:request
                                              onComplete:completeBlock
                                                 onError:errorBlock];
    return operation;
}

- (NSOperation *) activityListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions> *)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:@"api/core/v3/%@",
                             callName,
                             nil];
    
    return [self listOperationForClass:[JiveActivity class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (NSOperation *) activityDateLimitedListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions> *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:@"api/core/v3/%@",
                             callName,
                             nil];
    
    return [self dateLimitedListOperationForClass:[JiveActivity class]
                                          request:request
                                       onComplete:completeBlock
                                          onError:errorBlock];
}

- (NSOperation *) createContentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options andTemplate:(NSString *)template onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:content
                                                     options:options
                                                 andTemplate:template, nil];
    
    [request setHTTPMethod:@"POST"];
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

#pragma mark - public API
#pragma mark - generic

// Activities
- (void) activitiesWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self activitiesOperationWithOptions:options
                                                       onComplete:completeBlock
                                                          onError:errorBlock];
    [operation start];
}

- (void) actions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self actionsOperation:options onComplete:complete onError:error] start];
}

- (void) frequentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self frequentContentOperationWithOptions:options
                                                            onComplete:completeBlock
                                                               onError:errorBlock];
    [operation start];
}

- (void) frequentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self frequentPeopleOperationWithOptions:options
                                                           onComplete:completeBlock
                                                              onError:errorBlock];
    [operation start];
}

- (void) frequentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self frequentPlacesOperationWithOptions:options
                                                           onComplete:completeBlock
                                                              onError:errorBlock];
    [operation start];
}

- (void) recentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self recentContentOperationWithOptions:options
                                                          onComplete:completeBlock
                                                             onError:errorBlock];
    [operation start];
}

- (void) recentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self recentPeopleOperationWithOptions:options
                                                         onComplete:completeBlock
                                                            onError:errorBlock];
    [operation start];
}

- (void) recentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self recentPlacesOperationWithOptions:options
                                                         onComplete:completeBlock
                                                            onError:errorBlock];
    [operation start];
}

- (NSOperation *) activitiesOperationWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self activityDateLimitedListOperation:@"activities"
                                      withOptions:options
                                       onComplete:completeBlock
                                          onError:errorBlock];
}

- (NSOperation *) activitiesOperationWithURL:(NSURL *)activitiesURL onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:activitiesURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:activitiesURL];
    NSOperation *operation = [self dateLimitedListOperationForClass:[JiveActivity class]
                                                            request:mutableURLRequest
                                                         onComplete:completeBlock
                                                            onError:errorBlock];
    return operation;
}

- (NSOperation *) actionsOperation:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activityListOperation:@"actions" withOptions:options onComplete:complete onError:error];
}

- (NSOperation *) frequentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:  (JiveErrorBlock)errorBlock {
    return [self contentsListOperation:@"activities/frequent/content"
                           withOptions:options
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (NSOperation *) frequentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self getPeopleArray:@"activities/frequent/people" withOptions:options onComplete:completeBlock onError:errorBlock];
}

- (NSOperation *) frequentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self placeListOperation:@"activities/frequent/places"
                        withOptions:options
                         onComplete:completeBlock
                            onError:errorBlock];
}

- (NSOperation *) recentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self contentsListOperation:@"activities/recent/content"
                           withOptions:options
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (NSOperation *) recentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self getPeopleArray:@"activities/recent/people" withOptions:options onComplete:completeBlock onError:errorBlock];
}

- (NSOperation *) recentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self placeListOperation:@"activities/recent/places"
                        withOptions:options
                         onComplete:completeBlock
                            onError:errorBlock];
}

#pragma mark - Announcements

- (void) announcementsWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self announcementsOperationWithOptions:options
                                                          onComplete:completeBlock
                                                             onError:errorBlock];
    [operation start];
}

- (void) announcementWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self announcementOperationWithAnnouncement:announcement
                                                                 options:options
                                                              onComplete:completeBlock
                                                                 onError:errorBlock];
    [operation start];
}

- (void) deleteAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self deleteAnnouncementOperationWithAnnouncement:announcement
                                                                    onComplete:completeBlock
                                                                       onError:errorBlock];
    [operation start];
}

- (void) markAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self markAnnouncementOperationWithAnnouncement:announcement
                                                                      asRead:read
                                                                  onComplete:completeBlock
                                                                     onError:errorBlock];
    [operation start];
}

- (NSOperation *) announcementsOperationWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self contentsListOperation:@"announcements"
                           withOptions:options
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (NSOperation *) announcementOperationWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[announcement.selfRef path], nil];
    NSOperation *operation = [self entityOperationForClass:[JiveAnnouncement class]
                                                   request:request
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    return operation;
}

- (NSOperation *) deleteAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[announcement.selfRef path], nil];
    [request setHTTPMethod:@"DELETE"];
    NSOperation *operation = [self emptyOperationWithRequest:request
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    return operation;
}

- (NSOperation *) markAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[announcement.readRef path], nil];
    if (read) {
        [request setHTTPMethod:@"POST"];
    } else {
        [request setHTTPMethod:@"DELETE"];
    }
    NSOperation *operation = [self emptyOperationWithRequest:request
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    return operation;
}

#pragma mark - Inbox

- (void) inbox:(JiveInboxOptions*) options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self inboxOperation:options
                                       onComplete:completeBlock
                                          onError:errorBlock];
    [operation start];
}

- (NSOperation *)inboxOperation:(JiveInboxOptions *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:options
                                                andTemplate:@"api/core/v3/inbox", nil];
    
    NSOperation *operation = [self dateLimitedListOperationForClass:[JiveInboxEntry class]
                                                            request:request
                                                         onComplete:completeBlock
                                                            onError:errorBlock];
    return operation;
}

- (void) markInboxEntries:(NSArray *)inboxEntries asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableSet *inboxEntryUpdates = [NSMutableSet new];
    
    for (JiveInboxEntry *inboxEntry in inboxEntries) {
        if (inboxEntry.jive.update) {
            [inboxEntryUpdates addObject:inboxEntry.jive.update];
        }
    }
    
    [self markInboxEntryUpdates:[inboxEntryUpdates allObjects]
                         asRead:read
                     onComplete:completeBlock
                        onError:errorBlock];
}

- (void) markInboxEntryUpdates:(NSArray *)inboxEntryUpdates asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableSet *incompleteOperationUpdateURLs = [NSMutableSet setWithArray:inboxEntryUpdates];
    NSMutableArray *errors = [NSMutableArray new];
    
    void (^heapCompleteBlock)(void) = [completeBlock copy];
    JiveErrorBlock heapErrorBlock = [errorBlock copy];
    void (^markOperationCompleteBlock)(NSURLRequest *, NSError *) = [^(NSURLRequest *request, NSError *error) {
        [incompleteOperationUpdateURLs removeObject:[request URL]];
        if (error) {
            [errors addObject:error];
        }
        if ([incompleteOperationUpdateURLs count] == 0) {
            if ([errors count] == 0) {
                if (heapCompleteBlock) {
                    heapCompleteBlock();
                }
            } else {
                if (heapErrorBlock) {
                    heapErrorBlock([NSError jive_errorWithMultipleErrors:errors]);
                }
            }
        }
    } copy];
    
    NSString *HTTPMethod = read ? @"POST" : @"DELETE";
    NSMutableArray *operations = [NSMutableArray new];
    for (NSURL *updateURL in incompleteOperationUpdateURLs) {
        NSMutableURLRequest *markRequest = [NSMutableURLRequest requestWithURL:updateURL];
        [markRequest setHTTPMethod:HTTPMethod];
        [self maybeApplyCredentialsToMutableURLRequest:markRequest
                                                forURL:updateURL];
        NSOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:markRequest
                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                   markOperationCompleteBlock(request, nil);
                                                                               }
                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                   markOperationCompleteBlock(request, error);
                                                                               }];
        [operations addObject:operation];
    }
    
    if ([operations count] == 0) {
        if (heapCompleteBlock) {
            // guarantee that all callbacks happen on the next spin of the run loop.
            dispatch_async(dispatch_get_main_queue(), heapCompleteBlock);
        }
    } else {
        /*
         * It is extremely unlikely, but starting the operations after setting them all up guarantees that
         * One won't finish in the middle of setup and trigger a premature
         * [incompleteOperationUpdateURLs count] == 0 state.
         */
        [operations makeObjectsPerformSelector:@selector(start)];
    }
}

#pragma mark - People

- (void)personFromURL:(NSURL *)personURL onComplete:(void (^)(JivePerson *person))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self personOperationWithURL:personURL
                                               onComplete:completeBlock
                                                  onError:errorBlock];
    
    [operation start];
}

- (NSOperation *)personOperationWithURL:(NSURL *)personURL onComplete:(void (^)(JivePerson *person))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:personURL];
    
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:personURL];
    
    NSOperation *operation = [self entityOperationForClass:[JivePerson class]
                                                   request:mutableURLRequest
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    return operation;
}

- (NSOperation *)peopleOperation:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self getPeopleArray:@"people" withOptions:options onComplete:complete onError:error];
}

- (void) people:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self peopleOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)recommendedPeopleOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self getPeopleArray:@"people/recommended" withOptions:options onComplete:complete onError:error];
}

- (void) recommendedPeople:(JiveCountRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(JiveErrorBlock) error {
    [[self recommendedPeopleOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)trendingOperation:(JiveTrendingPeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self getPeopleArray:@"people/trending" withOptions:options onComplete:complete onError:error];
}

- (void) trending:(JiveTrendingPeopleRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(JiveErrorBlock) error {
    [[self trendingOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)personOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personResourceOperation:person.selfRef
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) person:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self personOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)meOperation:(void(^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personByOperation:@"@me" withOptions:nil onComplete:complete onError:error];
}

- (void) me:(void(^)(JivePerson *)) complete onError:(JiveErrorBlock) error {
    [[self meOperation:complete onError:error] start];
}

- (NSOperation *)personByEmailOperation:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personByOperation:[NSString stringWithFormat:@"email/%@", email] withOptions:options onComplete:complete onError:error];
}

- (void) personByEmail:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self personByEmailOperation:email withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)personByUserNameOperation:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personByOperation:[NSString stringWithFormat:@"username/%@", userName] withOptions:options onComplete:complete onError:error];
}

- (void) personByUserName:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self personByUserNameOperation:userName withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)managerOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personResourceOperation:person.manager
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) manager:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self managerOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)person:(NSString *)personId reportsOperation:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personByOperation:[NSString stringWithFormat:@"%@/@reports/%@", personId, reportsPersonId] withOptions:options onComplete:complete onError:error];
}

- (void) person:(NSString *)personId reports:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self person:personId reportsOperation:reportsPersonId withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) deletePersonOperation:(JivePerson *)person onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[person.selfRef path], nil];
    
    [request setHTTPMethod:@"DELETE"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deletePerson:(JivePerson *)person onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deletePersonOperation:person onComplete:complete onError:error] start];
}

- (NSOperation *)activitiesOperation:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activitiesResourceOperation:person.activity
                                 withOptions:options
                                  onComplete:complete
                                     onError:error];
}

- (void) activities:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self activitiesOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) colleguesOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:person.colleagues
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) collegues:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self colleguesOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) followersOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:person.followers
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (NSOperation *) followersOperation:(JivePerson *)person onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self followersOperation:person withOptions:nil onComplete:complete onError:error];
}

- (void) followers:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self followersOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (void) followers:(JivePerson *)person onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [self followers:person withOptions:nil onComplete:complete onError:error];
}

- (NSOperation *)reportsOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:person.reports
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) reports:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self reportsOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)followingOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:person.following
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) following:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self followingOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)blogOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[person.blog path], nil];
    
    return [self entityOperationForClass:[JiveBlog class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) blog:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(JiveErrorBlock)errorBlock {
    [[self blogOperation:person withOptions:options onComplete:complete onError:errorBlock] start];
}

- (NSOperation *) avatarForPersonOperation:(JivePerson *)person onComplete:(void (^)(UIImage *avatarImage))complete onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [self requestWithOptions:nil andTemplate:[person.avatar path], nil];
    void (^heapCompleteBlock)(UIImage *) = [complete copy];
    void (^heapErrorBlock)(NSError *) = [errorBlock copy];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:mutableURLRequest
                                                                              imageProcessingBlock:NULL
                                                                                           success:(^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (heapCompleteBlock) {
            heapCompleteBlock(image);
        }
    })
                                                                                           failure:(^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        if (heapErrorBlock) {
            heapErrorBlock(error);
        }
    })];
    return operation;
}

- (void) avatarForPerson:(JivePerson *)person onComplete:(void (^)(UIImage *))complete onError:(JiveErrorBlock)error {
    [[self avatarForPersonOperation:person onComplete:complete onError:error] start];
}

- (NSOperation *) followingInOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self streamsResourceOperation:person.followingIn
                              withOptions:options
                               onComplete:complete
                                  onError:error];
}

- (void) followingIn:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self followingInOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)updateFollowingInOperation:(NSArray *)followingInStreams forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self followingInRequestWithStreams:followingInStreams options:options template:[person.followingIn path], nil];
    return [self listOperationForClass:[JiveStream class] request:request onComplete:complete onError:error];
}

- (void)updateFollowingIn:(NSArray *)followingInStreams forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self updateFollowingInOperation:followingInStreams forPerson:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) streamsOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self streamsResourceOperation:person.streams
                              withOptions:options
                               onComplete:complete
                                  onError:error];
}

- (void) streams:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self streamsOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) tasksOperation:(JivePerson *)person withOptions:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsResourceOperation:person.tasks
                               withOptions:options
                                onComplete:complete
                                   onError:error];
}

- (void) tasks:(JivePerson *)person withOptions:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self tasksOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) updatePersonOperation:(JivePerson *)person onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:person
                                                     options:nil
                                                 andTemplate:[person.selfRef path], nil];
    
    [request setHTTPMethod:@"PUT"];
    return [self entityOperationForClass:[JivePerson class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updatePerson:(JivePerson *)person onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self updatePersonOperation:person onComplete:complete onError:error] start];
}

- (NSOperation *) personOperation:(JivePerson *)person follow:(JivePerson *)target onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSString *path = [[person.selfRef path] stringByAppendingPathComponent:target.jiveId];
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:path, nil];
    
    [request setHTTPMethod:@"PUT"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) person:(JivePerson *)person follow:(JivePerson *)target onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self personOperation:person follow:target onComplete:complete onError:error] start];
}

- (NSOperation *) createPersonOperation:(JivePerson *)person withOptions:(JiveWelcomeRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:person
                                                     options:options
                                                 andTemplate:@"api/core/v3/people", nil];
    
    [request setHTTPMethod:@"POST"];
    return [self entityOperationForClass:[JivePerson class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createPerson:(JivePerson *)person withOptions:(JiveWelcomeRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self createPersonOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createTaskOperation:(JiveTask *)task forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:task
                                                     options:options
                                                 andTemplate:[person.tasks path], nil];
    
    [request setHTTPMethod:@"POST"];
    return [self entityOperationForClass:[JiveTask class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createTask:(JiveTask *)task forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error {
    [[self createTaskOperation:task forPerson:person withOptions:options onComplete:complete onError:error] start];
}

#pragma mark - Search

- (NSOperation *) searchPeopleRequestOperation:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^) (NSArray *people))complete onError:(JiveErrorBlock)error {
    return [self getPeopleArray:@"search/people" withOptions:options onComplete:complete onError:error];
}

- (void) searchPeople:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^)(NSArray *people))complete onError:(JiveErrorBlock)error {
    NSOperation *operation = [self searchPeopleRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (NSOperation *) searchPlacesRequestOperation:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(JiveErrorBlock)error {
    return [self placeListOperation:@"search/places"
                        withOptions:options
                         onComplete:complete
                            onError:error];
}

- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(JiveErrorBlock)error {
    NSOperation * operation = [self searchPlacesRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (NSOperation *) searchContentsRequestOperation:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:@"search/contents"
                           withOptions:options
                            onComplete:complete
                               onError:error];
}

- (void) searchContents:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(JiveErrorBlock)error {
    
    NSOperation *operation = [self searchContentsRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

#pragma mark - Environment

- (NSOperation *)filterableFieldsOperation:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil
                                                andTemplate:@"api/core/v3/people/@filterableFields", nil];
    
    return [Jive operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return JSON;
    }];
}

- (void) filterableFields:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self filterableFieldsOperation:complete onError:error] start];
}

- (NSOperation *)supportedFieldsOperation:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil
                                                andTemplate:@"api/core/v3/people/@supportedFields", nil];
    
    return [Jive operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return JSON;
    }];
}

- (void) supportedFields:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self supportedFieldsOperation:complete onError:error] start];
}

- (NSOperation *)resourcesOperation:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil
                                                andTemplate:@"api/core/v3/people/@resources", nil];
    
    return [Jive operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveResource instancesFromJSONList:JSON];
    }];
}

- (void) resources:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self resourcesOperation:complete onError:error] start];
}

#pragma mark - Content

- (void) contentFromURL:(NSURL *)contentURL onComplete:(void (^)(JiveContent *content))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:contentURL];
    
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:contentURL];
    
    NSOperation *operation = nil;
    if(contentURL.query == nil || [contentURL.query rangeOfString:@"filter="].location == NSNotFound) {
        operation = [self entityOperationForClass:[JiveContent class]
                                          request:mutableURLRequest
                                       onComplete:completeBlock
                                          onError:errorBlock];
    } else {
        operation = [self listOperationForClass:[JiveContent class] request:mutableURLRequest onComplete:^(NSArray *objects) {
            completeBlock([objects objectAtIndex:0]);
        } onError:errorBlock];
    }
    
    
    [operation start];
}

- (NSOperation *) contentsOperationWithURL:(NSURL *)contentsURL onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:contentsURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:contentsURL];
    NSOperation *operation = [self listOperationForClass:[JiveContent class]
                                                 request:mutableURLRequest
                                              onComplete:completeBlock
                                                 onError:errorBlock];
    return operation;
}

- (NSOperation *)contentsOperation:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:@"contents" withOptions:options onComplete:complete onError:error];
}

- (void) contents:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self contentsOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)popularContentsOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:@"contents/popular" withOptions:options onComplete:complete onError:error];
}

- (void) popularContents:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self popularContentsOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)recommendedContentsOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:@"contents/recommended" withOptions:options onComplete:complete onError:error];
}

- (void) recommendedContents:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self recommendedContentsOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)trendingContentsOperation:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:@"contents/trending" withOptions:options onComplete:complete onError:error];
}

- (void) trendingContents:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self trendingContentsOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)contentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[content.selfRef path], nil];
    
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) content:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    [[self contentOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)commentsOperationForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsResourceOperation:content.commentsRef
                               withOptions:options
                                onComplete:complete
                                   onError:error];
}

- (void) commentsForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self commentsOperationForContent:content withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)contentLikedByOperation:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:content.likesRef withOptions:options onComplete:complete onError:error];
}

- (void) contentLikedBy:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self contentLikedByOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (void) activityObject:(JiveActivityObject *) activityObject contentWithCompleteBlock:(void(^)(JiveContent *content))completeBlock errorBlock:(JiveErrorBlock)errorBlock {
    NSURL *contentURL = [NSURL URLWithString:activityObject.jiveId];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:contentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:contentURL];
    
    NSOperation *operation = [self entityOperationForClass:[JiveContent class]
                                                   request:mutableURLRequest
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    [operation start];
}

- (void) comment:(JiveComment *) comment rootContentWithCompleteBlock:(void(^)(JiveContent *rootContent))completeBlock errorBlock:(JiveErrorBlock)errorBlock {
    NSURL *rootContentURL = [NSURL URLWithString:comment.rootURI];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:rootContentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:rootContentURL];
    
    NSOperation *operation = [self entityOperationForClass:[JiveContent class]
                                                   request:mutableURLRequest
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    [operation start];
}

- (void) message:(JiveMessage *) message discussionWithCompleteBlock:(void(^)(JiveDiscussion *discussion))completeBlock errorBlock:(void(^)(NSError *error))errorBlock {
    NSURL *discussionURL = [NSURL URLWithString:message.discussion];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:discussionURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:discussionURL];
    
    NSOperation *operation = [self entityOperationForClass:[JiveDiscussion class]
                                                   request:mutableURLRequest
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    [operation start];
}

- (void) createReplyMessage:(JiveMessage *)replyMessage forDiscussion:(JiveDiscussion *)discussion withOptions:(JiveReturnFieldsRequestOptions *)options completeBlock:(void (^)(JiveMessage *message))completeBlock errorBlock:(void (^)(NSError *error))errorBlock {
    NSOperation *createReplyMessageOperation = [self operationToCreateReplyMessage:replyMessage
                                                                     forDiscussion:discussion
                                                                       withOptions:options
                                                                     completeBlock:completeBlock
                                                                        errorBlock:errorBlock];
    [createReplyMessageOperation start];
}

- (NSOperation *) operationToCreateReplyMessage:(JiveMessage *)replyMessage forDiscussion:(JiveDiscussion *)discussion withOptions:(JiveReturnFieldsRequestOptions *)options completeBlock:(void (^)(JiveMessage *message))completeBlock errorBlock:(void (^)(NSError *error))errorBlock {
    NSOperation *createReplyMessageOperation = [self createContentOperation:replyMessage
                                                                withOptions:options
                                                                andTemplate:[discussion.messagesRef path]
                                                                 onComplete:(^(JiveContent *content) {
        completeBlock((JiveMessage *)content);
    })
                                                                    onError:errorBlock];
    return createReplyMessageOperation;
}

- (NSOperation *) contentFollowingInOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self streamsResourceOperation:content.followingInRef
                              withOptions:options
                               onComplete:complete
                                  onError:error];
}

- (void) contentFollowingIn:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self contentFollowingInOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)updateFollowingInOperation:(NSArray *)followingInStreams forContent:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self followingInRequestWithStreams:followingInStreams options:options template:[content.followingInRef path], nil];
    return [self listOperationForClass:[JiveStream class] request:request onComplete:complete onError:error];
}

- (void)updateFollowingIn:(NSArray *)followingInStreams forContent:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self updateFollowingInOperation:followingInStreams forContent:content withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) contentOperation:(JiveContent *)content markAsRead:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[content.readRef path], nil];
    
    [request setHTTPMethod:read ? @"POST" : @"DELETE"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) content:(JiveContent *)content markAsRead:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self contentOperation:content markAsRead:read onComplete:complete onError:error] start];
}

- (NSOperation *) contentOperation:(JiveContent *)content likes:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[content.likesRef path], nil];
    
    [request setHTTPMethod:read ? @"POST" : @"DELETE"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) content:(JiveContent *)content likes:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self contentOperation:content likes:read onComplete:complete onError:error] start];
}

- (NSOperation *) deleteContentOperation:(JiveContent *)content onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[content.selfRef path], nil];
    
    [request setHTTPMethod:@"DELETE"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deleteContent:(JiveContent *)content onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteContentOperation:content onComplete:complete onError:error] start];
}

- (NSOperation *) updateContentOperation:(JiveContent *)content withOptions:(JiveMinorCommentRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:content
                                                     options:options
                                                 andTemplate:[content.selfRef path], nil];
    
    [request setHTTPMethod:@"PUT"];
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updateContent:(JiveContent *)content withOptions:(JiveMinorCommentRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    [[self updateContentOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) messagesOperationForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsResourceOperation:content.messagesRef
                               withOptions:options
                                onComplete:complete
                                   onError:error];
}

- (void) messagesForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self messagesOperationForContent:content withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createContentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:content
                            withOptions:options
                            andTemplate:@"api/core/v3/contents"
                             onComplete:complete
                                onError:error];
}

- (void) createContent:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    [[self createContentOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createDirectMessageOperation:(JiveContent *)content withTargets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:@"api/core/v3/dms", nil];
    NSMutableDictionary *JSON = (NSMutableDictionary *)content.toJSONDictionary;
    [JSON setValue:[targets toJSONArray:YES] forKey:@"participants"];
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createDirectMessage:(JiveContent *)content withTargets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    [[self createDirectMessageOperation:content withTargets:targets andOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createCommentOperation:(JiveComment *)comment withOptions:(JiveAuthorCommentRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:comment
                            withOptions:options
                            andTemplate:@"api/core/v3/comments"
                             onComplete:complete
                                onError:error];
}

- (void) createComment:(JiveComment *)comment withOptions:(JiveAuthorCommentRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    [[self createCommentOperation:comment withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createMessageOperation:(JiveMessage *)message withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:message
                            withOptions:options
                            andTemplate:@"api/core/v3/messages"
                             onComplete:complete
                                onError:error];
}

- (void) createMessage:(JiveMessage *)message withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    [[self createMessageOperation:message withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createContentOperation:(JiveContent *)content withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:@"api/core/v3/contents", nil];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xJiveBoundary";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSMutableData *body = [NSMutableData data];
    NSData *boundaryData = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *contentData = [NSJSONSerialization dataWithJSONObject:content.toJSONDictionary
                                                          options:0
                                                            error:nil];
    NSString * const typeFormat = @"Content-Type: %@\r\n\r\n";
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"content\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:typeFormat, @"application/json; charset=UTF-8"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:contentData];
    for (JiveAttachment *attachment in attachmentURLs) {
        CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                (__bridge CFStringRef)[attachment.url pathExtension],
                                                                NULL);
        NSString *formDataString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                                    attachment.name, [attachment.url lastPathComponent]];
        NSString *fileTypeDataString = [NSString stringWithFormat:typeFormat,
                                        (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType)];
        
        CFRelease(UTI);
        [body appendData:boundaryData];
        [body appendData:[formDataString dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[fileTypeDataString dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithContentsOfURL:attachment.url]];
    }
    
    [body appendData:boundaryData];
    [request setHTTPBody:body];
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createContent:(JiveContent *)content withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    [[self createContentOperation:content withAttachments:attachmentURLs options:options onComplete:complete onError:error] start];
}

- (void)createDocument:(JiveDocument *)document withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    [self createContent:document withAttachments:attachmentURLs options:options onComplete:complete onError:error];
}

- (void)createPost:(JivePost *)post withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    [self createContent:post withAttachments:attachmentURLs options:options onComplete:complete onError:error];
}

- (NSOperation *)createDocumentOperation:(JiveDocument *)document withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:document withAttachments:attachmentURLs options:options onComplete:complete onError:error];
}

- (NSOperation *)createPostOperation:(JivePost *)post withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:post withAttachments:attachmentURLs options:options onComplete:complete onError:error];
}


#pragma mark - Places

- (NSOperation *)placesOperation:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self placeListOperation:@"places" withOptions:options onComplete:complete onError:error];
}

- (void) places:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self placesOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)recommendedPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self placeListOperation:@"places/recommended" withOptions:options onComplete:complete onError:error];
}

- (void) recommendedPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self recommendedPlacesOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)trendingPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self placeListOperation:@"places/trending" withOptions:options onComplete:complete onError:error];
}

- (void) trendingPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self trendingPlacesOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *)placePlacesOperation:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[place.childPlacesRef path], nil];
    
    return [self listOperationForClass:[JivePlace class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) placePlaces:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self placePlacesOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)placeOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[place.selfRef path], nil];
    
    return [self entityOperationForClass:[JivePlace class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void)placeFromURL:(NSURL *)placeURL withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *place))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = nil;
    if(placeURL.query == nil || [placeURL.query rangeOfString:@"filter="].location == NSNotFound) {
        operation = [self placeOperationWithURL:placeURL
                                    withOptions:options
                                     onComplete:completeBlock
                                        onError:errorBlock];
    } else {
        NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:placeURL];
        [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                                forURL:placeURL];
        operation = [self listOperationForClass:[JivePlace class] request:mutableURLRequest onComplete:^(NSArray *objects) {
            JivePlace *place = nil;
            if ([objects count]) {
                place = objects[0];
            }
            completeBlock(place);
        } onError:errorBlock];
    }

    [operation start];
}

- (NSOperation *)placeOperationWithURL:(NSURL *)placeURL withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *person))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [self requestWithOptions:options andTemplate:[placeURL absoluteString], nil];
    
    NSOperation *operation = [self entityOperationForClass:[JivePlace class]
                                                   request:mutableURLRequest
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    
    return operation;
}

- (void) place:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    [[self placeOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)placeActivitiesOperation:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activitiesResourceOperation:place.activityRef
                                 withOptions:options
                                  onComplete:complete
                                     onError:error];
}

- (void) placeActivities:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self placeActivitiesOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (void) deletePlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self deletePlaceOperationWithPlace:place
                                                      onComplete:completeBlock
                                                         onError:errorBlock];
    [operation start];
}

- (void) deleteAvatarForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self deleteAvatarOperationForPlace:place
                                                      onComplete:completeBlock
                                                         onError:errorBlock];
    [operation start];
}

- (void) announcementsForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self announcementsOperationForPlace:place
                                                          options:options
                                                       onComplete:completeBlock
                                                          onError:errorBlock];
    [operation start];
}

- (void) avatarForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(void (^)(UIImage *avatarImage))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self avatarOperationForPlace:place
                                                   options:options
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    [operation start];
}

- (void) tasksForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self tasksOperationForPlace:place
                                                  options:options
                                               onComplete:completeBlock
                                                  onError:errorBlock];
    [operation start];
}

- (NSOperation *) deletePlaceOperationWithPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[place.selfRef path], nil];
    [request setHTTPMethod:@"DELETE"];
    NSOperation *operation = [self emptyOperationWithRequest:request
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    return operation;
}

- (NSOperation *) deleteAvatarOperationForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[place.avatarRef path], nil];
    [request setHTTPMethod:@"DELETE"];
    NSOperation *operation = [self emptyOperationWithRequest:request
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    return operation;
}

- (NSOperation *) announcementsOperationForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self contentsResourceOperation:place.announcementsRef
                               withOptions:options
                                onComplete:completeBlock
                                   onError:errorBlock];
}

- (NSOperation *) avatarOperationForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(void (^)(UIImage *avatarImage))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [self requestWithOptions:options andTemplate:[place.avatarRef path], nil];
    void (^heapCompleteBlock)(UIImage *) = [completeBlock copy];
    void (^heapErrorBlock)(NSError *) = [errorBlock copy];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:mutableURLRequest
                                                                              imageProcessingBlock:NULL
                                                                                           success:(^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (heapCompleteBlock) {
            heapCompleteBlock(image);
        }
    })
                                                                                           failure:(^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        if (heapErrorBlock) {
            heapErrorBlock(error);
        }
    })];
    return operation;
}

- (NSOperation *) tasksOperationForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self contentsResourceOperation:place.tasksRef
                               withOptions:options
                                onComplete:completeBlock
                                   onError:errorBlock];
}

- (NSOperation *) placeFollowingInOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self streamsResourceOperation:place.followingInRef
                              withOptions:options
                               onComplete:complete
                                  onError:error];
}

- (void) placeFollowingIn:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self placeFollowingInOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *)updateFollowingInOperation:(NSArray *)followingInStreams forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {    
    NSMutableURLRequest *request = [self followingInRequestWithStreams:followingInStreams options:options template:[place.followingInRef path], nil];

    return [self listOperationForClass:[JiveStream class] request:request onComplete:complete onError:error];
}

- (void)updateFollowingIn:(NSArray *)followingInStreams forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self updateFollowingInOperation:followingInStreams forPlace:place withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) updatePlaceOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:place
                                                     options:options
                                                 andTemplate:[place.selfRef path], nil];
    
    [request setHTTPMethod:@"PUT"];
    return [self entityOperationForClass:[JivePlace class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updatePlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    [[self updatePlaceOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) invitesOperation:(JivePlace *)place withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[place.invitesRef path], nil];
    
    return [self listOperationForClass:[JiveInvite class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) invites:(JivePlace *)place withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self invitesOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createTaskOperation:(JiveTask *)task forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:task
                                                     options:options
                                                 andTemplate:[place.tasksRef path], nil];
    
    [request setHTTPMethod:@"POST"];
    return [self entityOperationForClass:[JiveTask class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createTask:(JiveTask *)task forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error {
    [[self createTaskOperation:task forPlace:place withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createPlaceOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:place
                                                     options:options
                                                 andTemplate:@"api/core/v3/places", nil];
    
    [request setHTTPMethod:@"POST"];
    return [self entityOperationForClass:[JivePlace class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    [[self createPlaceOperation:place withOptions:options onComplete:complete onError:error] start];
}

#pragma mark - Members

- (void) deleteMember:(JiveMember *)member onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self deleteMemberOperationWithMember:member
                                                        onComplete:completeBlock
                                                           onError:errorBlock];
    [operation start];
}

- (void) memberWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self memberOperationWithMember:member
                                                     options:options
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    [operation start];
}

- (void) membersForGroup:(JivePlace *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self membersOperationForGroup:group
                                                    options:options
                                                 onComplete:completeBlock
                                                    onError:errorBlock];
    [operation start];
}

- (void) membersForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSOperation *operation = [self membersOperationForPerson:person
                                                     options:options
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    return [operation start];
}

- (NSOperation *) deleteMemberOperationWithMember:(JiveMember *)member onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[member.selfRef path], nil];
    [request setHTTPMethod:@"DELETE"];
    NSOperation *operation = [self emptyOperationWithRequest:request
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    return operation;
}

- (NSOperation *)memberOperationWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[member.selfRef path], nil];
    NSOperation *operation = [self entityOperationForClass:[JiveMember class]
                                                   request:request
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    return operation;
}

- (NSOperation *) membersOperationForGroup:(JivePlace *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[group.membersRef path], nil];
    NSOperation *operation = [self listOperationForClass:[JiveMember class]
                                                 request:request
                                              onComplete:completeBlock
                                                 onError:errorBlock];
    return operation;
}

- (NSOperation *) membersOperationForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[person.members path], nil];
    NSOperation *operation = [self listOperationForClass:[JiveMember class]
                                                 request:request
                                              onComplete:completeBlock
                                                 onError:errorBlock];
    return operation;
}

- (NSOperation *) updateMemberOperation:(JiveMember *)member withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:member
                                                     options:options
                                                 andTemplate:[member.selfRef path], nil];
    
    [request setHTTPMethod:@"PUT"];
    return [self entityOperationForClass:[JiveMember class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updateMember:(JiveMember *)member withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *))complete onError:(JiveErrorBlock)error {
    [[self updateMemberOperation:member withOptions:options onComplete:complete onError:error] start];
}

#pragma mark - Streams

- (NSOperation *) streamOperation:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[stream.selfRef path], nil];
    
    return [self entityOperationForClass:[JiveStream class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) stream:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    [[self streamOperation:stream withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) streamActivitiesOperation:(JiveStream *)stream withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activitiesResourceOperation:stream.activityRef
                                 withOptions:options
                                  onComplete:complete
                                     onError:error];
}

- (void) streamActivities:(JiveStream *)stream withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self streamActivitiesOperation:stream withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) streamConnectionsActivitiesOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activityListOperation:@"streams/connections/activities" withOptions:options onComplete:complete onError:error];
}

- (void) streamConnectionsActivities:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self streamConnectionsActivitiesOperation:options onComplete:complete onError:error] start];
}

- (NSOperation *) deleteStreamOperation:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[stream.selfRef path], nil];
    
    [request setHTTPMethod:@"DELETE"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deleteStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteStreamOperation:stream onComplete:complete onError:error] start];
}

- (NSOperation *) streamAssociationsOperation:(JiveStream *)stream withOptions:(JiveAssociationsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:[stream.associationsRef path],
                             nil];
    
    return [self listOperationForClass:[JiveTypedObject class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) streamAssociations:(JiveStream *)stream withOptions:(JiveAssociationsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self streamAssociationsOperation:stream withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) updateStreamOperation:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:stream
                                                     options:options
                                                 andTemplate:[stream.selfRef path], nil];
    
    [request setHTTPMethod:@"PUT"];
    return [self entityOperationForClass:[JiveStream class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updateStream:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    [[self updateStreamOperation:stream withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createStreamOperation:(JiveStream *)stream forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:stream
                                                     options:options
                                                 andTemplate:[person.streams path], nil];
    
    [request setHTTPMethod:@"POST"];
    return [self entityOperationForClass:[JiveStream class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createStream:(JiveStream *)stream forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    [[self createStreamOperation:stream forPerson:person withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) deleteAssociationOperation:(JiveTypedObject *)association fromStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil
                                                andTemplate:@"%@/%@/%@", [stream.associationsRef path], association.type, [association.selfRef lastPathComponent], nil];
    
    [request setHTTPMethod:@"DELETE"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deleteAssociation:(JiveTypedObject *)association fromStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteAssociationOperation:association fromStream:stream onComplete:complete onError:error] start];
}

- (NSOperation *) createAssociationsOperation:(JiveAssociationTargetList *)targets forStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[stream.associationsRef path], nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:[targets toJSONArray] options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) createAssociations:(JiveAssociationTargetList *)targets forStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self createAssociationsOperation:targets forStream:stream onComplete:complete onError:error] start];
}

#pragma mark - Invites

- (NSOperation *) inviteOperation:(JiveInvite *)invite withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[invite.selfRef path], nil];
    
    return [self entityOperationForClass:[JiveInvite class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) invite:(JiveInvite *)invite withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error {
    [[self inviteOperation:invite withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) deleteInviteOperation:(JiveInvite *)invite onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil andTemplate:[invite.selfRef path], nil];
    
    [request setHTTPMethod:@"DELETE"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deleteInvite:(JiveInvite *)invite onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteInviteOperation:invite onComplete:complete onError:error] start];
}

- (NSOperation *) updateInviteOperation:(JiveInvite *)invite withState:(enum JiveInviteState)state andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[invite.selfRef path], nil];
    NSDictionary *JSON = @{@"id" : invite.jiveId, @"state" : [JiveInvite jsonForState:state]};
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:body];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return [self entityOperationForClass:[JiveInvite class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updateInvite:(JiveInvite *)invite withState:(enum JiveInviteState)state andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error {
    [[self updateInviteOperation:invite withState:state andOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) createInviteToOperation:(JivePlace *)place withMessage:(NSString *)message targets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:[place.invitesRef path], nil];
    NSDictionary *JSON = @{@"body" : message, @"invitees" : [targets toJSONArray:NO]};
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return [self listOperationForClass:[JiveInvite class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) createInviteTo:(JivePlace *)place withMessage:(NSString *)message targets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self createInviteToOperation:place withMessage:message targets:targets andOptions:options onComplete:complete onError:error] start];
}

#pragma mark - Images

- (NSOperation *)imagesOperationFromURL:(NSURL *)imagesURL onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:imagesURL];
    
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:imagesURL];
    
    NSOperation *operation = nil;
    operation = [self listOperationForClass:[JiveImage class] request:mutableURLRequest onComplete:complete onError:error];
    return operation;
}

- (void)imagesFromURL:(NSURL *)imagesURL onComplete:(void (^)(NSArray *images))completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self imagesOperationFromURL:imagesURL onComplete:completeBlock onError:errorBlock] start];
}

- (NSOperation*) uploadImageOperation:(UIImage*) image onComplete:(void (^)(JiveImage*))complete onError:(JiveErrorBlock) errorBlock {
    
    NSMutableURLRequest* request = [self requestWithImageAsPNGBody:image options:nil andTemplate:@"api/core/v3/images", nil];
    
    [self maybeApplyCredentialsToMutableURLRequest:request
                                            forURL:self.jiveInstanceURL];
    
    AFHTTPRequestOperation *op= [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        JiveImage *jiveImage = [[JiveImage class] instanceFromJSON:json];
        complete(jiveImage);
    } failure:^(AFHTTPRequestOperation *operation, NSError *err) {
        if(errorBlock) {
            errorBlock(err);
        }
    }];
    
    return op;
}

- (void) uploadImage:(UIImage*) image onComplete:(void (^)(JiveImage*))complete onError:(JiveErrorBlock) errorBlock {
    [[self uploadImageOperation:image onComplete:complete onError:errorBlock] start];
}

#pragma mark - Outcomes
- (NSOperation *) outcomesListOperation:(JiveContent *)content withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSURLRequest *request = [self requestWithOptions:options
                                         andTemplate:@"%@/outcomes", content.selfRef.path, nil];
    NSOperation *operation = [self listOperationForClass:[JiveOutcome class]
                                                 request:request
                                              onComplete:complete
                                                 onError:error];
    return operation;
}

- (NSOperation *) outcomesOperation:(JiveContent *)content withOptions:(JiveOutcomeRequestOptions *)options onComplete:(void (^)(NSArray *outcomes))complete onError:(JiveErrorBlock) error {
    return [self outcomesListOperation:content
                           withOptions:options
                            onComplete:complete
                               onError:error];
}

- (void) outcomes:(JiveContent *)content withOptions:(JiveOutcomeRequestOptions *)options onComplete:(void (^)(NSArray *outcomes))complete onError:(JiveErrorBlock) error {
    [[self outcomesOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (NSOperation *) deleteOutcomeOperation:(JiveOutcome *)outcome onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithOptions:nil
                                                andTemplate:@"api/core/v3/outcomes/%@", outcome.jiveId, nil];
    
    [request setHTTPMethod:@"DELETE"];
    return [self emptyOperationWithRequest:request
                                onComplete:complete
                                   onError:error];
}

- (void) deleteOutcome:(JiveOutcome *)outcome onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteOutcomeOperation:outcome onComplete:complete onError:error] start];
}

- (NSOperation *) createOutcomeOperation:(JiveOutcome *)outcome forContent:(JiveContent *)content onComplete:(void (^)(JiveOutcome *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:outcome
                                                     options:nil
                                                 andTemplate:@"%@%@", content.selfRef.path, @"/outcomes", nil];
    
    [request setHTTPMethod:@"POST"];
    return [self entityOperationForClass:[JiveOutcome class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createOutcome:(JiveOutcome *)outcome forContent:(JiveContent *)content onComplete:(void (^)(JiveOutcome *))complete onError:(JiveErrorBlock)error {
    [[self createOutcomeOperation:outcome forContent:content onComplete:complete onError:error] start];
}

#pragma mark - Properties

- (NSOperation *) propertyWithNameOperation:(NSString *)propertyName onComplete:(void (^)(JiveProperty *))complete onError:(JiveErrorBlock)error {
    NSURLRequest *request = [self requestWithOptions:nil
                                         andTemplate:@"api/core/v3/metadata/properties/%@", propertyName, nil];
    NSOperation *operation = [self entityOperationForClass:[JiveProperty class]
                                                   request:request
                                                onComplete:complete
                                                   onError:error];
    
    return operation;
}

- (void) propertyWithName:(NSString *)propertyName onComplete:(void (^)(JiveProperty *))complete onError:(JiveErrorBlock)error {
    [[self propertyWithNameOperation:propertyName onComplete:complete onError:error] start];
}

#pragma mark - private API

- (NSMutableURLRequest *)followingInRequestWithStreams:(NSArray *)streams options:(NSObject<JiveRequestOptions>*)options template:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION {
    NSString *targetURIKeyPath = [NSString stringWithFormat:@"%@.%@.%@.%@", NSStringFromSelector(@selector(resources)), JiveResourceAttributes.selfKey, NSStringFromSelector(@selector(ref)), NSStringFromSelector(@selector(absoluteString))];
    NSArray *targetURIs = [streams count] ? [streams valueForKeyPath:targetURIKeyPath] : [NSArray array];
    
    NSMutableURLRequest *request = [self requestWithOptions:options andTemplate:template, nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:targetURIs options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return request;
}

- (NSMutableURLRequest *) requestWithOptions:(NSObject<JiveRequestOptions>*)options template:(NSString*)template andArguments:(va_list)args {
    if (!template)
        return nil;
    
    NSMutableString* requestString = [[NSMutableString alloc] initWithFormat:template arguments:args];
    NSString *queryString = [options toQueryString];
    
    if (queryString) {
        [requestString appendFormat:@"?%@", queryString];
    }
    
    NSURL* requestURL = [NSURL URLWithString:requestString
                               relativeToURL:_jiveInstance];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    [self maybeApplyCredentialsToMutableURLRequest:request
                                            forURL:requestURL];
    
    return request;
}

- (NSMutableURLRequest *) requestWithOptions:(NSObject<JiveRequestOptions>*)options andTemplate:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, template);
    NSMutableURLRequest *request = [self requestWithOptions:options template:template andArguments:args];
    va_end(args);
    
    return request;
}

- (NSMutableURLRequest *) requestWithJSONBody:(JiveObject *)bodySource options:(NSObject<JiveRequestOptions>*)options andTemplate:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, template);
    NSMutableURLRequest *request = [self requestWithOptions:options template:template andArguments:args];
    va_end(args);
    NSDictionary *JSON = bodySource.toJSONDictionary;
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return request;
}

// This is a stop-gap until AFNetworking's multi-part support is fixed.
- (NSMutableURLRequest *) requestWithImageAsPNGBody:(UIImage*) image options:(NSObject<JiveRequestOptions>*)options andTemplate:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION {
    
    va_list args;
    va_start(args, template);
    NSMutableURLRequest *request = [self requestWithOptions:options template:template andArguments:args];
    va_end(args);
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xJiveBoundary";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    return request;
}

- (void) maybeApplyCredentialsToMutableURLRequest:(NSMutableURLRequest *)mutableURLRequest
                                           forURL:(NSURL *)URL {
    if(_delegate && [_delegate respondsToSelector:@selector(credentialsForJiveInstance:)]) {
        id<JiveCredentials> credentials = [_delegate credentialsForJiveInstance:URL];
        [credentials applyToRequest:mutableURLRequest];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(mobileAnalyticsHeaderForJiveInstance:)]) {
        JiveMobileAnalyticsHeader *mobileAnalyticsHeader = [_delegate mobileAnalyticsHeaderForJiveInstance:URL];
        [mobileAnalyticsHeader applyToRequest:mutableURLRequest];
    }
}

+ (JAPIRequestOperation *)operationWithRequest:(NSURLRequest *)request onJSON:(void(^)(id))JSONBlock onError:(JiveErrorBlock)errorBlock {
    if (request) {
        JAPIRequestOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, id JSON) {
            if (JSONBlock) {
                JSONBlock(JSON);
            }
        } failure:^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, NSError *err, id JSON) {
            if (errorBlock) {
                errorBlock([NSError jive_errorWithUnderlyingError:err
                                                             JSON:JSON]);
            }
        }];
        
        return operation;
    } else {
        return nil;
    }
}

+ (JAPIRequestOperation *)operationWithRequest:(NSURLRequest *)request onComplete:(void(^)(id))completeBlock onError:(JiveErrorBlock)errorBlock responseHandler:(id(^)(id JSON)) handler {
    return [self operationWithRequest:request
                               onJSON:(^(id JSON) {
        if (completeBlock) {
            id entity = handler(JSON);
            completeBlock(entity);
        }
    })
                              onError:errorBlock];
}

- (JAPIRequestOperation *)dateLimitedListOperationForClass:(Class)clazz
                                                   request:(NSURLRequest *)request
                                                onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock
                                                   onError:(JiveErrorBlock)errorBlock {
    
    if (request) {
        JAPIRequestOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, id JSON) {
            id entity = [clazz instancesFromJSONList:JSON[@"list"]];
            
            NSDictionary *links = JSON[@"links"];
            NSURL *nextURL = [NSURL URLWithString:links[@"next"]];
            NSURL *previousURL = [NSURL URLWithString:links[@"previous"]];
            
            NSDate *earliestDate = [nextURL jive_dateFromValueOfParameterWithName:@"before"];
            NSDate *latestDate = [previousURL jive_dateFromValueOfParameterWithName:@"after"];
            
            if (completeBlock) {
                completeBlock(entity, earliestDate, latestDate);
            }
            
        } failure:^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, NSError *err, id JSON) {
            if (errorBlock) {
                errorBlock([NSError jive_errorWithUnderlyingError:err
                                                             JSON:JSON]);
            }
        }];
        
        return operation;
    } else {
        return nil;
    }
}

- (JAPIRequestOperation *)listOperationForClass:(Class) clazz request:(NSURLRequest *)request onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    JAPIRequestOperation *operation = [Jive operationWithRequest:request
                                                      onComplete:completeBlock
                                                         onError:errorBlock
                                                 responseHandler:(^id(id JSON) {
        return [clazz instancesFromJSONList:[JSON objectForKey:@"list"]];
    })];
    return operation;
}

- (JAPIRequestOperation *)entityOperationForClass:(Class) clazz request:(NSURLRequest *)request onComplete:(void (^)(id))completeBlock onError:(JiveErrorBlock)errorBlock {
    JAPIRequestOperation *operation = [Jive operationWithRequest:request
                                                      onComplete:completeBlock
                                                         onError:errorBlock
                                                 responseHandler:(^id(id JSON) {
        return [clazz instanceFromJSON:JSON];
    })];
    return operation;
}

- (JAPIRequestOperation*) emptyOperationWithRequest:(NSURLRequest*) request onComplete:(void(^)(void)) complete onError:(JiveErrorBlock) error {
    void (^nilObjectComplete)(id);
    if (complete) {
        void (^heapComplete)(void) = [complete copy];
        nilObjectComplete = ^(id nilObject) {
            heapComplete();
        };
    } else {
        nilObjectComplete = NULL;
    }
    JAPIRequestOperation *operation = [Jive operationWithRequest:request
                                                      onComplete:nilObjectComplete
                                                         onError:error
                                                 responseHandler:(^id(id JSON) {
        return nil;
    })];
    return operation;
}

@end

@implementation NSURL (JiveDateParameterValue)

- (NSDate *)jive_dateFromValueOfParameterWithName:(NSString *)parameterName {
    NSDictionary *parameters = [NSDictionary jive_dictionaryWithHttpArgumentsString:[self query]];
    if (parameters) {
        NSString *dateISO8601 = parameters[parameterName];
        if (dateISO8601) {
            NSDateFormatter *ISO8601DateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
            NSDate *date = [ISO8601DateFormatter dateFromString:dateISO8601];
            return date;
        }
    }
    
    return nil;
}

@end
