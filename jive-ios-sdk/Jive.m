//
//  Jive.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "Jive.h"
#import "JAPIRequestOperation.h"
#import "JiveSearchContentParams.h"
#import "JiveContent.h"
#import "JivePerson.h"
#import "JivePlace.h"
#import "NSData+JiveBase64.h"
#import "JiveExtension.h"
#import "NSError+Jive.h"

@interface Jive() {
    
@private
    __weak id<JiveAuthorizationDelegate> _delegate;
    __strong NSURL* _jiveInstance;
}

@property(nonatomic, strong) NSURL* jiveInstance;

@end

@implementation Jive

@synthesize jiveInstance = _jiveInstance;

+ (void)initialize {
	if([[NSData class] instanceMethodSignatureForSelector:@selector(jive_base64EncodedString)] == NULL)
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
    
    return self;
}

#pragma mark - public API

// Inbox
- (void) inbox:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error {
    [self inbox:nil onComplete:complete onError:error];
}

- (void) inbox: (JiveInboxOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error {
    
    
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/inbox" options:options andArgs:nil];
    
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^id(id JSON) {
        return [JiveInboxEntry instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
    
}

- (void) markInboxEntries:(NSArray *)inboxEntries asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(void(^)(NSError *error))errorBlock {
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

- (void) markInboxEntryUpdates:(NSArray *)inboxEntryUpdates asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(void(^)(NSError *))errorBlock {
    NSMutableSet *incompleteOperationUpdateURLs = [NSMutableSet setWithArray:inboxEntryUpdates];
    NSMutableArray *errors = [NSMutableArray new];
    
    void (^heapCompleteBlock)(void) = [completeBlock copy];
    void (^heapErrorBlock)(NSError *) = [errorBlock copy];
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

- (JAPIRequestOperation *) getPeopleArray:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/%@" options:options andArgs:callName, nil];
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
}

- (JAPIRequestOperation *)peopleOperation:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self getPeopleArray:@"people" withOptions:options onComplete:complete onError:error];
}

- (void) people:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self peopleOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)recommendedPeopleOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self getPeopleArray:@"people/recommended" withOptions:options onComplete:complete onError:error];
}

- (void) recommendedPeople:(JiveCountRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error {
    [[self recommendedPeopleOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)trendingOperation:(JiveTrendingPeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self getPeopleArray:@"people/trending" withOptions:options onComplete:complete onError:error];
}

- (void) trending:(JiveTrendingPeopleRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error {
    [[self trendingOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)personOperation:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/people/%@" options:options andArgs:personId,nil];
    
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^JivePerson *(id JSON) {
        return [JivePerson instanceFromJSON:JSON];
    }];
}

- (void) person:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self personOperation:personId withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)meOperation:(void(^)(JivePerson *))complete onError:(void(^)(NSError* error))error {
    return [self personOperation:@"@me" withOptions:nil onComplete:complete onError:error];
}

- (void) me:(void(^)(JivePerson *)) complete onError:(void(^)(NSError*)) error {
    [self person:@"@me" withOptions:nil onComplete:complete onError:error];
}

- (JAPIRequestOperation *)personByEmailOperation:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    return [self personOperation:[NSString stringWithFormat:@"email/%@", email] withOptions:options onComplete:complete onError:error];
}

- (void) personByEmail:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self personByEmailOperation:email withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)personByUserNameOperation:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    return [self personOperation:[NSString stringWithFormat:@"username/%@", userName] withOptions:options onComplete:complete onError:error];
}

- (void) personByUserName:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self personByUserNameOperation:userName withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)managerOperation:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    return [self personOperation:[NSString stringWithFormat:@"%@/@manager", personId] withOptions:options onComplete:complete onError:error];
}

- (void) manager:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self managerOperation:personId withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)person:(NSString *)personId reportsOperation:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    return [self personOperation:[NSString stringWithFormat:@"%@/@reports/%@", personId, reportsPersonId] withOptions:options onComplete:complete onError:error];
}

- (void) person:(NSString *)personId reports:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self person:personId reportsOperation:reportsPersonId withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)activitiesOperation:(NSString *)personId withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/activities" options:options andArgs:personId,nil];
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveInboxEntry instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
}

- (void) activities:(NSString*) personId withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/activities" options:options andArgs:personId,nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveInboxEntry instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (JAPIRequestOperation *) colleguesOperation:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self getPeopleArray:[NSString stringWithFormat:@"people/%@/@colleagues", personId] withOptions:options onComplete:complete onError:error];
}

- (void) collegues:(NSString*) personId withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error {
    [[self colleguesOperation:personId withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *) followersOperation:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/@followers" options:options andArgs:personId,nil];
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
}

- (JAPIRequestOperation *) followersOperation:(NSString *)personId onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self followersOperation:personId withOptions:nil onComplete:complete onError:error];
}

- (void) followers:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self followersOperation:personId withOptions:options onComplete:complete onError:error] start];
}

- (void) followers:(NSString *)personId onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [self followers:personId withOptions:nil onComplete:complete onError:error];
}

- (JAPIRequestOperation *)reportsOperation:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self getPeopleArray:[NSString stringWithFormat:@"people/%@/@reports", personId] withOptions:options onComplete:complete onError:error];
}

- (void) reports:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self reportsOperation:personId withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)followingOperation:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self getPeopleArray:[NSString stringWithFormat:@"people/%@/@following", personId] withOptions:options onComplete:complete onError:error];
}

- (void) following:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self followingOperation:personId withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation*) searchPeopleRequestOperation:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^) (NSArray *people))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/search/people" options:options andArgs:nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    return operation;
}

- (void) searchPeople:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^)(NSArray *people))complete onError:(void (^)(NSError *))error {
    
    JAPIRequestOperation* operation = [self searchPeopleRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (JAPIRequestOperation*) searchPlacesRequestOperation:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/search/places" options:options andArgs:nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePlace instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    return operation;
}

- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(void (^)(NSError *))error {

    JAPIRequestOperation* operation = [self searchPlacesRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (JAPIRequestOperation*) searchContentsRequestOperation:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/search/contents" options:options andArgs:nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveContent instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    return operation;
}

- (void) searchContents:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(void (^)(NSError *))error {
    
    JAPIRequestOperation* operation = [self searchContentsRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (void) blog:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/blog" options:options andArgs:personId,nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveBlog instanceFromJSON:JSON];
    }];
    
    [operation start];
}

- (JAPIRequestOperation *)filterableFieldsOperation:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/people/@filterableFields" options:nil andArgs:nil];
    
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return JSON;
    }];
}

- (void) filterableFields:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self filterableFieldsOperation:complete onError:error] start];
}

- (JAPIRequestOperation *)supportedFieldsOperation:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/people/@supportedFields" options:nil andArgs:nil];
    
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return JSON;
    }];
}

- (void) supportedFields:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self supportedFieldsOperation:complete onError:error] start];
}

- (JAPIRequestOperation *)resourcesOperation:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/people/@resources" options:nil andArgs:nil];
    
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveResource instancesFromJSONList:JSON];
    }];
}

- (void) resources:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self resourcesOperation:complete onError:error] start];
}

- (void) activityObject:(JiveActivityObject *) activityObject contentWithCompleteBlock:(void(^)(JiveContent *content))completeBlock errorBlock:(void(^)(NSError *error))errorBlock {
    NSURL *contentURL = [NSURL URLWithString:activityObject.jiveId];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:contentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:contentURL];
    
    JAPIRequestOperation *operation = [self operationWithRequest:mutableURLRequest
                                                      onComplete:completeBlock
                                                         onError:errorBlock
                                                 responseHandler:^id(id JSON) {
                                                     return [JiveContent instanceFromJSON:JSON];
                                                 }];
    [operation start];
}

- (void) comment:(JiveComment *) comment rootContentWithCompleteBlock:(void(^)(JiveContent *rootContent))completeBlock errorBlock:(void(^)(NSError *error))errorBlock {
    NSURL *rootContentURL = [NSURL URLWithString:comment.rootURI];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:rootContentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:rootContentURL];
    
    JAPIRequestOperation *operation = [self operationWithRequest:mutableURLRequest
                                                      onComplete:completeBlock
                                                         onError:errorBlock
                                                 responseHandler:^id(id JSON) {
                                                     return [JiveContent instanceFromJSON:JSON];
                                                 }];
    [operation start];
}

- (void) contentsList:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/%@" options:options andArgs:callName, nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveContent instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) contents:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [self contentsList:@"contents" withOptions:options onComplete:complete onError:error];
}

- (void) popularContents:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [self contentsList:@"contents/popular" withOptions:options onComplete:complete onError:error];
}

- (void) recommendedContents:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [self contentsList:@"contents/recommended" withOptions:options onComplete:complete onError:error];
}

- (void) trendingContents:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [self contentsList:@"contents/trending" withOptions:options onComplete:complete onError:error];
}

- (void) content:(NSString *)contentId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(void (^)(NSError *))error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/contents/%@" options:options andArgs:contentId, nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveContent instanceFromJSON:JSON];
    }];
    
    [operation start];
}

- (void) commentsForContent:(NSString *)contentId withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/contents/%@/comments" options:options andArgs:contentId, nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveComment instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) contentLikedBy:(NSString *)contentId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self getPeopleArray:[NSString stringWithFormat:@"contents/%@/likes", contentId] withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *) placeListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/places%@" options:options andArgs:callName, nil];
    
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePlace instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
}

- (void) placeList:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self placeListOperation:callName withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)placesOperation:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self placeListOperation:@"" withOptions:options onComplete:complete onError:error];
}

- (void) places:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self placesOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)recommendedPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self placeListOperation:@"/recommended" withOptions:options onComplete:complete onError:error];
}

- (void) recommendedPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self recommendedPlacesOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)trendingPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self placeListOperation:@"/trending" withOptions:options onComplete:complete onError:error];
}

- (void) trendingPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self trendingPlacesOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)placePlacesOperation:(NSString *)placeId withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self placeListOperation:[NSString stringWithFormat:@"/%@/places", placeId] withOptions:options onComplete:complete onError:error];
}

- (void) placePlaces:(NSString *)placeID withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self placePlacesOperation:placeID withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)placeOperation:(NSString *)placeId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/places/%@" options:options andArgs:placeId, nil];
    
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^JivePlace *(id JSON) {
        return [JivePlace instanceFromJSON:JSON];
    }];
}

- (void) place:(NSString *)placeId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(void (^)(NSError *))error {
    [[self placeOperation:placeId withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)placeActivitiesOperation:(NSString *)placeId withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/places/%@/activities" options:options andArgs:placeId, nil];
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveInboxEntry instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
}

- (void) placeActivities:(NSString *)placeId withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self placeActivitiesOperation:placeId withOptions:options onComplete:complete onError:error] start];
}

#pragma mark - private API

- (NSURLRequest*) requestWithTemplate:(NSString*) template options:(NSObject<JiveRequestOptions>*) options andArgs:(NSString*) args,...{
    
    NSMutableString* requestString = [NSMutableString stringWithFormat:template, args];
    NSString *queryString = [options toQueryString];
    
    if (queryString)
        [requestString appendFormat:@"?%@", queryString];
    
    NSURL* requestURL = [NSURL URLWithString:requestString
                               relativeToURL:_jiveInstance];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [self maybeApplyCredentialsToMutableURLRequest:request
                                            forURL:requestURL];
    
    return request;
}

- (void) maybeApplyCredentialsToMutableURLRequest:(NSMutableURLRequest *)mutableURLRequest
                                           forURL:(NSURL *)URL {
    if(_delegate && [_delegate respondsToSelector:@selector(credentialsForJiveInstance:)]) {
        JiveCredentials *credentials = [_delegate credentialsForJiveInstance:URL];
        [credentials applyToRequest:mutableURLRequest];
    }
}

- (JAPIRequestOperation*) operationWithRequest:(NSURLRequest*) request onComplete:(void(^)(id)) complete onError:(void(^)(NSError* error)) error responseHandler: (id(^)(id)) handler {
    
    JAPIRequestOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id entity = handler(JSON);
        complete(entity);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err, id JSON) {
        error(err);
    }];
    
    return operation;
}

@end
