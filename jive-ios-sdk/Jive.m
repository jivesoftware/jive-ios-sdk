//
//  Jive.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "Jive.h"
#import "JAPIRequestOperation.h"
#import "JiveCredentials.h"
#import "JiveInboxOptions.h"
#import "JiveInboxEntry.h"
#import "JiveSearchParams.h"
#import "JiveSearchContentParams.h"
#import "JiveContent.h"
#import "JivePerson.h"
#import "JivePlace.h"
#import "JivePagedRequestOptions.h"

@interface Jive() {
    
@private
    __weak id<JiveAuthorizationDelegate> _delegate;
    __strong NSURL* _jiveInstance;
}

@property(nonatomic, strong) NSURL* jiveInstance;

@end

@implementation Jive

@synthesize jiveInstance = _jiveInstance;


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

#pragma mark -
#pragma Core API Methods

// Inbox
- (void) inbox:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error {
    [self inbox:nil onComplete:complete onError:error];
}

- (void) inbox: (JiveInboxOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error {
    
    
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/inbox" options:options andArgs:nil];
    
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^id(id JSON) {
        return [JiveInboxEntry instancesFromJSONList:[JSON objectForKey:@"list"]];
    }];
    
    [operation start];
   
}



- (void) me:(void(^)(id)) complete onError:(void(^)(NSError*)) error {
    
    
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/@me" options:nil andArgs:nil];
    
     JAPIRequestOperation *operation = [self operationWithRequest:request  onComplete:complete onError:error responseHandler:^id(id JSON) {
         return JSON;
     }];
    
    [operation start];
  
    
}

- (void) collegues:(NSString*) personId onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error {
    
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/@colleagues" options:nil andArgs:personId,nil];
    
    JAPIRequestOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        complete(JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err, id JSON) {
        error(err);
    }];
    
    [operation start];
     
}

- (void) followers:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(id))complete onError:(void (^)(NSError *))error
{
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/%@/@followers" options:options andArgs:personId,nil];
    
    JAPIRequestOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        complete(JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err, id JSON) {
        error(err);
    }];
    
    [operation start];
}

- (void) followers:(NSString *)personId onComplete:(void (^)(id))complete onError:(void (^)(NSError *))error
{
    [self followers:personId withOptions:nil onComplete:complete onError:error];
}

- (void) search:(JiveSearchParams*)params onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error {
    
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/search/%@?%@" options:nil andArgs:[params facet],[params toQueryString],nil];
    
    
    JAPIRequestOperation *operation = [self operationWithRequest:request onComplete:complete onError:error responseHandler:^id(id JSON) {
        if (params.facet == @"contents") {
            return [JiveContent instancesFromJSONList:[JSON objectForKey:@"list"]];
        } else if (params.facet == @"people") {
            return [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
        } else if (params.facet == @"places") {
            return [JivePlace instancesFromJSONList:[JSON objectForKey:@"list"]];
        } else {
            return nil;
        }
    }];
    
    [operation start];
}


#pragma mark -
#pragma mark Utility Methods
- (NSURLRequest*) requestWithTemplate:(NSString*) template options:(NSObject<JiveRequestOptions>*) options andArgs:(NSString*) args,...{
    
    NSMutableString* requestString = [NSMutableString stringWithFormat:template, args];
    NSString *queryString = [options toQueryString];

    if (queryString)
        [requestString appendFormat:@"?%@", queryString];

    NSURL* requestURL = [_jiveInstance URLByAppendingPathComponent:requestString];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    if(_delegate && [_delegate respondsToSelector:@selector(credentialsForJiveInstance:)]) {
        JiveCredentials *credentials = [_delegate credentialsForJiveInstance:requestURL];
        [credentials applyToRequest:request];
    } 
    
    return request;
}


- (JAPIRequestOperation*) operationWithRequest:(NSURLRequest*) request onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error responseHandler: (id(^)(id)) handler {
    
    JAPIRequestOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id entity = handler(JSON);
        complete(entity);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err, id JSON) {
        error(err);
    }];
    
    return operation;
}

@end
