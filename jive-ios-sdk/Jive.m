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

// Activities
- (void) activitiesWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *activities))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self activitiesOperationWithOptions:options
                                                                onComplete:completeBlock
                                                                   onError:errorBlock];
    [operation start];
}

- (void) frequentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self frequentContentOperationWithOptions:options
                                                                     onComplete:completeBlock
                                                                        onError:errorBlock];
    [operation start];
}

- (void) frequentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self frequentPeopleOperationWithOptions:options
                                                                    onComplete:completeBlock
                                                                       onError:errorBlock];
    [operation start];
}

- (void) frequentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self frequentPlacesOperationWithOptions:options
                                                                    onComplete:completeBlock
                                                                       onError:errorBlock];
    [operation start];
}

- (void) recentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self recentContentOperationWithOptions:options
                                                                   onComplete:completeBlock
                                                                      onError:errorBlock];
    [operation start];
}

- (void) recentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self recentPeopleOperationWithOptions:options
                                                                  onComplete:completeBlock
                                                                     onError:errorBlock];
    [operation start];
}

- (void) recentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self recentPlacesOperationWithOptions:options
                                                                  onComplete:completeBlock
                                                                     onError:errorBlock];
    [operation start];
}


- (JAPIRequestOperation *) getPeopleArray:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/%@" options:options andArgs:callName, nil];
    
    return [self listOperationForClass:[JivePerson class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (JAPIRequestOperation *) activitiesOperationWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *activities))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/activities"
                                              options:options
                                              andArgs:nil];
    
    JAPIRequestOperation *operation = [self listOperationForClass:[JiveActivityObject class]
                                                          request:request
                                                       onComplete:completeBlock
                                                          onError:errorBlock];
    return operation;
}

- (JAPIRequestOperation *) frequentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:  (void (^)(NSError *error))errorBlock {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/activities/frequent/content"
                                              options:options
                                              andArgs:nil];
    
    JAPIRequestOperation *operation = [self listOperationForClass:[JiveContent class]
                                                          request:request
                                                       onComplete:completeBlock
                                                          onError:errorBlock];
    return operation;
}

- (JAPIRequestOperation *) frequentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(void (^)(NSError *error))errorBlock {
    return [self getPeopleArray:@"activities/frequent/people" withOptions:options onComplete:completeBlock onError:errorBlock];
}

- (JAPIRequestOperation *) frequentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/activities/frequent/places"
                                              options:options
                                              andArgs:nil];
    
    JAPIRequestOperation *operation = [self listOperationForClass:[JivePlace class]
                                                          request:request
                                                       onComplete:completeBlock
                                                          onError:errorBlock];
    return operation;
}

- (JAPIRequestOperation *) recentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/activities/recent/content"
                                              options:options
                                              andArgs:nil];
    
    JAPIRequestOperation *operation = [self listOperationForClass:[JiveContent class]
                                                          request:request
                                                       onComplete:completeBlock
                                                          onError:errorBlock];
    return operation;
}

- (JAPIRequestOperation *) recentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock {
    return [self getPeopleArray:@"activities/recent/people" withOptions:options onComplete:completeBlock onError:errorBlock];
}

- (JAPIRequestOperation *) recentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/activities/recent/places"
                                              options:options
                                              andArgs:nil];
    
    JAPIRequestOperation *operation = [self listOperationForClass:[JivePlace class]
                                                          request:request
                                                       onComplete:completeBlock
                                                          onError:errorBlock];
    return operation;
}

// Announcements
- (void) announcementsWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self announcementsOperationWithOptions:options
                                                                   onComplete:completeBlock
                                                                      onError:errorBlock];
    [operation start];
}

- (void) announcementWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self announcementOperationWithAnnouncement:announcement
                                                                          options:options
                                                                       onComplete:completeBlock
                                                                          onError:errorBlock];
    [operation start];
}

- (void) deleteAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self deleteAnnouncementOperationWithAnnouncement:announcement
                                                                             onComplete:completeBlock
                                                                                onError:errorBlock];
    [operation start];
}

- (void) markAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self markAnnouncementOperationWithAnnouncement:announcement
                                                                               asRead:read
                                                                           onComplete:completeBlock
                                                                              onError:errorBlock];
    [operation start];
}

- (JAPIRequestOperation *) announcementsOperationWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/announcements"
                                              options:options
                                              andArgs:nil];
    JAPIRequestOperation *operation = [self listOperationForClass:[JiveAnnouncement class]
                                                          request:request
                                                       onComplete:completeBlock
                                                          onError:errorBlock];
    return operation;
}

- (JAPIRequestOperation *) announcementOperationWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *selfResourceEntry = [announcement.resources objectForKey:@"self"];
    NSMutableURLRequest *request = [self requestWithTemplate:[selfResourceEntry.ref path]
                                                     options:nil
                                                     andArgs:nil];
    JAPIRequestOperation *operation = [self entityOperationForClass:[JiveAnnouncement class]
                                                            request:request
                                                         onComplete:completeBlock
                                                            onError:errorBlock];
    return operation;
}

- (JAPIRequestOperation *) deleteAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *selfResourceEntry = [announcement.resources objectForKey:@"self"];
    NSMutableURLRequest *request = [self requestWithTemplate:[selfResourceEntry.ref path]
                                                     options:nil
                                                     andArgs:nil];
    [request setHTTPMethod:@"DELETE"];
    JAPIRequestOperation *operation = [self emptyOperationWithRequest:request
                                                           onComplete:completeBlock
                                                              onError:errorBlock];
    return operation;
}

- (JAPIRequestOperation *) markAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *readResourceEntry = [announcement.resources objectForKey:@"read"];
    NSMutableURLRequest *request = [self requestWithTemplate:[readResourceEntry.ref path]
                                                     options:nil
                                                     andArgs:nil];
    if (read) {
        [request setHTTPMethod:@"POST"];
    } else {
        [request setHTTPMethod:@"DELETE"];
    }
    JAPIRequestOperation *operation = [self emptyOperationWithRequest:request
                                                           onComplete:completeBlock
                                                              onError:errorBlock];
    return operation;
}

// Inbox
- (void) inbox:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error {
    [self inbox:nil onComplete:complete onError:error];
}

- (void) inbox: (JiveInboxOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error {
    
    
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/inbox" options:options andArgs:nil];
    
    JAPIRequestOperation *operation = [self listOperationForClass:[JiveInboxEntry class]
                                                          request:request
                                                       onComplete:complete
                                                          onError:error];
    
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

- (JAPIRequestOperation *) peopleResourceOperation:(JiveResourceEntry *)resourceEntry withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:[resourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    
    return [self listOperationForClass:[JivePerson class]
                               request:request
                            onComplete:complete
                               onError:error];
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

- (JAPIRequestOperation *)personResourceOperation:(JiveResourceEntry *)resourceEntry withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:[resourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    
    return [self entityOperationForClass:[JivePerson class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (JAPIRequestOperation *)personOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    return [self personResourceOperation:[person.resources objectForKey:@"self"]
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) person:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self personOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)personByOperation:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/people/%@" options:options andArgs:personId,nil];
    
    JAPIRequestOperation *operation = [self entityOperationForClass:[JivePerson class]
                                                            request:request
                                                         onComplete:complete
                                                            onError:error];
    return operation;
}

- (JAPIRequestOperation *)meOperation:(void(^)(JivePerson *))complete onError:(void(^)(NSError* error))error {
    return [self personByOperation:@"@me" withOptions:nil onComplete:complete onError:error];
}

- (void) me:(void(^)(JivePerson *)) complete onError:(void(^)(NSError*)) error {
    [[self meOperation:complete onError:error] start];
}

- (JAPIRequestOperation *)personByEmailOperation:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    return [self personByOperation:[NSString stringWithFormat:@"email/%@", email] withOptions:options onComplete:complete onError:error];
}

- (void) personByEmail:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self personByEmailOperation:email withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)personByUserNameOperation:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    return [self personByOperation:[NSString stringWithFormat:@"username/%@", userName] withOptions:options onComplete:complete onError:error];
}

- (void) personByUserName:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self personByUserNameOperation:userName withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)managerOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    return [self personResourceOperation:[person.resources objectForKey:@"manager"]
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) manager:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self managerOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)person:(NSString *)personId reportsOperation:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    return [self personByOperation:[NSString stringWithFormat:@"%@/@reports/%@", personId, reportsPersonId] withOptions:options onComplete:complete onError:error];
}

- (void) person:(NSString *)personId reports:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error {
    [[self person:personId reportsOperation:reportsPersonId withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)activitiesOperation:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    JiveResourceEntry *resourceEntry = [person.resources objectForKey:@"activity"];
    NSURLRequest *request = [self requestWithTemplate:[resourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    
    return [self listOperationForClass:[JiveInboxEntry class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) activities:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error {
    [[self activitiesOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *) colleguesOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self peopleResourceOperation:[person.resources objectForKey:@"colleagues"]
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) collegues:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error {
    [[self colleguesOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *) followersOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self peopleResourceOperation:[person.resources objectForKey:@"followers"]
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (JAPIRequestOperation *) followersOperation:(JivePerson *)person onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self followersOperation:person withOptions:nil onComplete:complete onError:error];
}

- (void) followers:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self followersOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (void) followers:(JivePerson *)person onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [self followers:person withOptions:nil onComplete:complete onError:error];
}

- (JAPIRequestOperation *)reportsOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self peopleResourceOperation:[person.resources objectForKey:@"reports"]
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) reports:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self reportsOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)followingOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self peopleResourceOperation:[person.resources objectForKey:@"following"]
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) following:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self followingOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation*) searchPeopleRequestOperation:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^) (NSArray *people))complete onError:(void (^)(NSError *))error {
    return [self getPeopleArray:@"search/people" withOptions:options onComplete:complete onError:error];
}

- (void) searchPeople:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^)(NSArray *people))complete onError:(void (^)(NSError *))error {
    JAPIRequestOperation* operation = [self searchPeopleRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (JAPIRequestOperation*) searchPlacesRequestOperation:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/search/places" options:options andArgs:nil];
    JAPIRequestOperation *operation = [self listOperationForClass:[JivePlace class]
                                                          request:request
                                                       onComplete:complete
                                                          onError:error];
    
    return operation;
}

- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(void (^)(NSError *))error {
    JAPIRequestOperation* operation = [self searchPlacesRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (JAPIRequestOperation*) searchContentsRequestOperation:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(void (^)(NSError *))error {
    
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/search/contents" options:options andArgs:nil];
    JAPIRequestOperation *operation = [self listOperationForClass:[JiveContent class]
                                                          request:request
                                                       onComplete:complete
                                                          onError:error];
    return operation;
}

- (void) searchContents:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(void (^)(NSError *))error {
    
    JAPIRequestOperation* operation = [self searchContentsRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (JAPIRequestOperation *)blogOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(void (^)(NSError *))error {
    JiveResourceEntry *resourceEntry = [person.resources objectForKey:@"blog"];
    NSURLRequest *request = [self requestWithTemplate:[resourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    
    return [self entityOperationForClass:[JiveBlog class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) blog:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(void (^)(NSError *))error {
    [[self blogOperation:person withOptions:options onComplete:complete onError:error] start];
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

- (void) contentFromURL:(NSURL *)contentURL onComplete:(void (^)(JiveContent *content))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:contentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:contentURL];
    
    JAPIRequestOperation *operation = [self entityOperationForClass:[JiveContent class]
                                                            request:mutableURLRequest
                                                         onComplete:completeBlock
                                                            onError:errorBlock];
    [operation start];
}

- (JAPIRequestOperation *) contentsListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/%@" options:options andArgs:callName, nil];
    JAPIRequestOperation *operation = [self listOperationForClass:[JiveContent class]
                                                          request:request
                                                       onComplete:complete
                                                          onError:error];
    return operation;
}

- (void) contentsList:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self contentsListOperation:callName withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)contentsOperation:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self contentsListOperation:@"contents" withOptions:options onComplete:complete onError:error];
}

- (void) contents:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self contentsOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)popularContentsOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self contentsListOperation:@"contents/popular" withOptions:options onComplete:complete onError:error];
}

- (void) popularContents:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self popularContentsOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)recommendedContentsOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self contentsListOperation:@"contents/recommended" withOptions:options onComplete:complete onError:error];
}

- (void) recommendedContents:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self recommendedContentsOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)trendingContentsOperation:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self contentsListOperation:@"contents/trending" withOptions:options onComplete:complete onError:error];
}

- (void) trendingContents:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self trendingContentsOperation:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)contentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(void (^)(NSError *))error {
    JiveResourceEntry *resourceEntry = [content.resources objectForKey:@"self"];
    NSURLRequest *request = [self requestWithTemplate:[resourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) content:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(void (^)(NSError *))error {
    [[self contentOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)commentsForContentOperation:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    JiveResourceEntry *resourceEntry = [content.resources objectForKey:@"comments"];
    NSURLRequest *request = [self requestWithTemplate:[resourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    
    return [self listOperationForClass:[JiveComment class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) commentsForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self commentsForContentOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)contentLikedByOperation:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self peopleResourceOperation:[content.resources objectForKey:@"likes"] withOptions:options onComplete:complete onError:error];
}

- (void) contentLikedBy:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self contentLikedByOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (void) activityObject:(JiveActivityObject *) activityObject contentWithCompleteBlock:(void(^)(JiveContent *content))completeBlock errorBlock:(void(^)(NSError *error))errorBlock {
    NSURL *contentURL = [NSURL URLWithString:activityObject.jiveId];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:contentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:contentURL];
    
    JAPIRequestOperation *operation = [self entityOperationForClass:[JiveContent class]
                                                            request:mutableURLRequest
                                                         onComplete:completeBlock
                                                            onError:errorBlock];
    [operation start];
}

- (void) comment:(JiveComment *) comment rootContentWithCompleteBlock:(void(^)(JiveContent *rootContent))completeBlock errorBlock:(void(^)(NSError *error))errorBlock {
    NSURL *rootContentURL = [NSURL URLWithString:comment.rootURI];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:rootContentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:rootContentURL];
    
    JAPIRequestOperation *operation = [self entityOperationForClass:[JiveContent class]
                                                            request:mutableURLRequest
                                                         onComplete:completeBlock
                                                            onError:errorBlock];
    [operation start];
}

- (JAPIRequestOperation *) placeListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    NSURLRequest *request = [self requestWithTemplate:@"/api/core/v3/places%@" options:options andArgs:callName, nil];
    
    JAPIRequestOperation *operation = [self listOperationForClass:[JivePlace class]
                                                          request:request
                                                       onComplete:complete
                                                          onError:error];
    return operation;
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

- (JAPIRequestOperation *)placePlacesOperation:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    JiveResourceEntry *resourceEntry = [place.resources objectForKey:@"places"];
    NSURLRequest *request = [self requestWithTemplate:[resourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    
    return [self listOperationForClass:[JivePlace class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) placePlaces:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self placePlacesOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)placeOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(void (^)(NSError *))error {
    JiveResourceEntry *resourceEntry = [place.resources objectForKey:@"self"];
    NSURLRequest *request = [self requestWithTemplate:[resourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    
    return [self entityOperationForClass:[JivePlace class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) place:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(void (^)(NSError *))error {
    [[self placeOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (JAPIRequestOperation *)placeActivitiesOperation:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    JiveResourceEntry *resourceEntry = [place.resources objectForKey:@"activity"];
    NSURLRequest *request = [self requestWithTemplate:[resourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    
    return [self listOperationForClass:[JiveInboxEntry class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) placeActivities:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    [[self placeActivitiesOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (void) deletePlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self deletePlaceOperationWithPlace:place
                                                               onComplete:completeBlock
                                                                  onError:errorBlock];
    [operation start];
}

- (void) deleteAvatarForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self deleteAvatarOperationForPlace:place
                                                               onComplete:completeBlock
                                                                  onError:errorBlock];
    [operation start];
}

- (void) announcementsForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self announcementsOperationForPlace:place
                                                                   options:options
                                                                onComplete:completeBlock
                                                                   onError:errorBlock];
    [operation start];
}

- (void) avatarForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(void (^)(UIImage *avatarImage))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSOperation *operation = [self avatarOperationForPlace:place
                                                   options:options
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    [operation start];
}

- (void) tasksForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSOperation *operation = [self tasksOperationForPlace:place
                                                  options:options
                                               onComplete:completeBlock
                                                  onError:errorBlock];
    [operation start];
}

- (JAPIRequestOperation *) deletePlaceOperationWithPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *selfResourceEntry = [place.resources objectForKey:@"self"];
    NSMutableURLRequest *request = [self requestWithTemplate:[selfResourceEntry.ref path]
                                                     options:nil
                                                     andArgs:nil];
    [request setHTTPMethod:@"DELETE"];
    JAPIRequestOperation *operation = [self emptyOperationWithRequest:request
                                                           onComplete:completeBlock
                                                              onError:errorBlock];
    return operation;
}

- (JAPIRequestOperation *) deleteAvatarOperationForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *avatarResourceEntry = [place.resources objectForKey:@"avatar"];
    NSMutableURLRequest *request = [self requestWithTemplate:[avatarResourceEntry.ref path]
                                                     options:nil
                                                     andArgs:nil];
    [request setHTTPMethod:@"DELETE"];
    JAPIRequestOperation *operation = [self emptyOperationWithRequest:request
                                                           onComplete:completeBlock
                                                              onError:errorBlock];
    return operation;
}

- (JAPIRequestOperation *) announcementsOperationForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *announcementsResourceEntry = [place.resources objectForKey:@"announcements"];
    NSURLRequest *request = [self requestWithTemplate:[announcementsResourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    JAPIRequestOperation *operation = [self listOperationForClass:[JiveAnnouncement class]
                                                          request:request
                                                       onComplete:completeBlock
                                                          onError:errorBlock];
    return operation;
}

- (NSOperation *) avatarOperationForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(void (^)(UIImage *avatarImage))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *avatarResourceEntry = [place.resources objectForKey:@"avatar"];
    NSURLRequest *request = [self requestWithTemplate:[avatarResourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    void (^heapCompleteBlock)(UIImage *) = [completeBlock copy];
    void (^heapErrorBlock)(NSError *) = [errorBlock copy];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
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

- (NSOperation *) tasksOperationForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *tasksResourceEntry = [place.resources objectForKey:@"tasks"];
    NSURLRequest *request = [self requestWithTemplate:[tasksResourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    NSOperation *operation = [self listOperationForClass:[JiveTask class]
                                                 request:request
                                              onComplete:completeBlock
                                                 onError:errorBlock];
    return operation;
}

#pragma mark - Members

- (void) deleteMember:(JiveMember *)member onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSOperation *operation = [self deleteMemberOperationWithMember:member
                                                        onComplete:completeBlock
                                                           onError:errorBlock];
    [operation start];
}

- (void) memberWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSOperation *operation = [self memberOperationWithMember:member
                                                     options:options
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    [operation start];
}

- (void) membersForGroup:(JiveGroup *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSOperation *operation = [self membersOperationForGroup:group
                                                    options:options
                                                 onComplete:completeBlock
                                                    onError:errorBlock];
    [operation start];
}

- (void) membersForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(void (^)(NSError *error))errorBlock {
    NSOperation *operation = [self membersOperationForPerson:person
                                                     options:options
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    return [operation start];
}

- (NSOperation *) deleteMemberOperationWithMember:(JiveMember *)member onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *selfResourceEntry = [member.resources objectForKey:@"self"];
    NSMutableURLRequest *request = [self requestWithTemplate:[selfResourceEntry.ref path]
                                                     options:nil
                                                     andArgs:nil];
    [request setHTTPMethod:@"DELETE"];
    NSOperation *operation = [self emptyOperationWithRequest:request
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    return operation;
}

- (NSOperation *)memberOperationWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *selfResourceEntry = [member.resources objectForKey:@"self"];
    NSURLRequest *request = [self requestWithTemplate:[selfResourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    NSOperation *operation = [self entityOperationForClass:[JiveMember class]
                                                   request:request
                                                onComplete:completeBlock
                                                   onError:errorBlock];
    return operation;
}

- (NSOperation *) membersOperationForGroup:(JiveGroup *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *membersResourceEntry = [group.resources objectForKey:@"members"];
    NSURLRequest *request = [self requestWithTemplate:[membersResourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    NSOperation *operation = [self listOperationForClass:[JiveMember class]
                                                 request:request
                                              onComplete:completeBlock
                                                 onError:errorBlock];
    return operation;
}

- (NSOperation *) membersOperationForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JiveResourceEntry *membersResourceEntry = [person.resources objectForKey:@"members"];
    NSURLRequest *request = [self requestWithTemplate:[membersResourceEntry.ref path]
                                              options:options
                                              andArgs:nil];
    NSOperation *operation = [self listOperationForClass:[JiveMember class]
                                                 request:request
                                              onComplete:completeBlock
                                                 onError:errorBlock];
    return operation;
}

#pragma mark - private API

- (NSMutableURLRequest *) requestWithTemplate:(NSString*) template options:(NSObject<JiveRequestOptions>*) options andArgs:(NSString*) args,...{
    if (template) {
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
    } else {
        return nil;
    }
}

- (void) maybeApplyCredentialsToMutableURLRequest:(NSMutableURLRequest *)mutableURLRequest
                                           forURL:(NSURL *)URL {
    if(_delegate && [_delegate respondsToSelector:@selector(credentialsForJiveInstance:)]) {
        JiveCredentials *credentials = [_delegate credentialsForJiveInstance:URL];
        [credentials applyToRequest:mutableURLRequest];
    }
}

- (JAPIRequestOperation*) operationWithRequest:(NSURLRequest*) request onComplete:(void(^)(id)) completeBlock onError:(void(^)(NSError* error)) errorBlock responseHandler: (id(^)(id JSON)) handler {
    if (request) {
        JAPIRequestOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            id entity = handler(JSON);
            if (completeBlock) {
                completeBlock(entity);
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err, id JSON) {
            if (errorBlock) {
                errorBlock(err);
            }
        }];
        
        return operation;
    } else {
        return nil;
    }
}

- (JAPIRequestOperation *)listOperationForClass:(Class) clazz request:(NSURLRequest *)request onComplete:(void (^)(NSArray *))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self operationWithRequest:request
                                                      onComplete:completeBlock
                                                         onError:errorBlock
                                                 responseHandler:(^id(id JSON) {
        return [clazz instancesFromJSONList:[JSON objectForKey:@"list"]];
    })];
    return operation;
}

- (JAPIRequestOperation *)entityOperationForClass:(Class) clazz request:(NSURLRequest *)request onComplete:(void (^)(id))completeBlock onError:(void (^)(NSError *error))errorBlock {
    JAPIRequestOperation *operation = [self operationWithRequest:request
                                                      onComplete:completeBlock
                                                         onError:errorBlock
                                                 responseHandler:(^id(id JSON) {
        return [clazz instanceFromJSON:JSON];
    })];
    return operation;
}

- (JAPIRequestOperation*) emptyOperationWithRequest:(NSURLRequest*) request onComplete:(void(^)(void)) complete onError:(void(^)(NSError* error)) error {
    void (^nilObjectComplete)(id);
    if (complete) {
        void (^heapComplete)(void) = [complete copy];
        nilObjectComplete = ^(id nilObject) {
            heapComplete();
        };
    } else {
        nilObjectComplete = NULL;
    }
    JAPIRequestOperation *operation = [self operationWithRequest:request
                                                      onComplete:nilObjectComplete
                                                         onError:error
                                                 responseHandler:(^id(id JSON) {
        return nil;
    })];
    return operation;
}

@end
