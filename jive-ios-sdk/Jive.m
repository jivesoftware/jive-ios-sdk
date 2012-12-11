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
    NSMutableSet *incompleteOperationUpdateURLs = [NSMutableSet new];
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
    for (JiveInboxEntry *inboxEntry in inboxEntries) {
        if (inboxEntry.jive.update &&
            (inboxEntry.jive.read != read) &&
            // many Inbox Entries may have the same update URL.
            ![incompleteOperationUpdateURLs containsObject:inboxEntry.jive.update]) {
            NSMutableURLRequest *markRequest = [NSMutableURLRequest requestWithURL:inboxEntry.jive.update];
            [markRequest setHTTPMethod:HTTPMethod];
            [self maybeApplyCredentialsToMutableURLRequest:markRequest
                                                    forURL:inboxEntry.jive.update];
            [incompleteOperationUpdateURLs addObject:inboxEntry.jive.update];
            NSOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:markRequest
                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                       markOperationCompleteBlock(request, nil);
                                                                                   }
                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                       markOperationCompleteBlock(request, error);
                                                                                   }];
            [operations addObject:operation];
        }
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

- (void) getPeopleArray:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/%@" options:options andArgs:callName, nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) people:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [self getPeopleArray:@"people" withOptions:options onComplete:complete onError:error];
}

- (void) recommendedPeople:(JiveCountRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error {
    [self getPeopleArray:@"people/recommended" withOptions:options onComplete:complete onError:error];
}

- (void) trending:(JiveTrendingPeopleRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error {
    [self getPeopleArray:@"people/trending" withOptions:options onComplete:complete onError:error];
}

- (void) person:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/people/%@" options:options andArgs:personId,nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^JivePerson *(id JSON) {
        return [JivePerson instanceFromJSON:JSON];
    }];
    
    [operation start];
}

- (void) me:(void(^)(JivePerson *)) complete onError:(void(^)(NSError*)) error {
    
    [self person:@"@me" withOptions:nil onComplete:complete onError:error];
}

- (void) personByEmail:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [self person:[NSString stringWithFormat:@"email/%@", email] withOptions:options onComplete:complete onError:error];
}

- (void) personByUserName:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [self person:[NSString stringWithFormat:@"username/%@", userName] withOptions:options onComplete:complete onError:error];
}

- (void) manager:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [self person:[NSString stringWithFormat:@"%@/@manager", personId] withOptions:options onComplete:complete onError:error];
}

- (void) person:(NSString *)personId reports:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [self person:[NSString stringWithFormat:@"%@/@reports/%@", personId, reportsPersonId] withOptions:options onComplete:complete onError:error];
}

- (void) activities:(NSString*) personId withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/activities" options:options andArgs:personId,nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveInboxEntry instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) collegues:(NSString*) personId withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error {
    
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/@colleagues" options:options andArgs:personId,nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) followers:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/@followers" options:options andArgs:personId,nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) followers:(NSString *)personId onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [self followers:personId withOptions:nil onComplete:complete onError:error];
}

- (void) reports:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/@reports" options:options andArgs:personId,nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) following:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/@following" options:options andArgs:personId,nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) searchPeople:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^)(NSArray *people))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/search/people" options:options andArgs:nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/search/places" options:options andArgs:nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JivePlace instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) searchContents:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/search/contents" options:options andArgs:nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveContent instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
}

- (void) blog:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/blog" options:options andArgs:personId,nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveBlog instanceFromJSON:JSON];
    }];
    
    [operation start];
}

- (void) filterableFields:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/people/@filterableFields" options:nil andArgs:nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return JSON;
    }];
    
    [operation start];
}

- (void) supportedFields:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/people/@supportedFields" options:nil andArgs:nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return JSON;
    }];
    
    [operation start];
}

- (void) resources:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/people/@resources" options:nil andArgs:nil];
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [JiveResource instancesFromJSONList:JSON];
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
