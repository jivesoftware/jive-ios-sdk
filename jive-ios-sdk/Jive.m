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
#import "JiveRequestOptions.h"
#import "JiveInboxEntry.h"

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

- (void) inbox: (JiveRequestOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error {
    
    
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

- (void) search:(NSString*) type queryStr:(NSString*) query onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error {
    
    NSString *fields;
    NSString *startIndex = @"0";
    
    if (type == @"contents") {
        fields = @"&fields=rootType,type,subject,author,question,answer,parentPlace,parentContent,highlightSubject,highlightBody,highlightTags,published,updated,replyCount,likeCount,viewCount,visibleToExternalContributors,binaryURL";
    } else if (type == @"people") {
        fields = @"";
    } else if (type == @"places") {
        fields = @"";
    } else {
//        throw new error
    }
    
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/search/%@?q=%@&sort=relevanceDesc&count=20&startIndex=%@%@" options:nil andArgs:type,query,startIndex,fields,nil];
    
    JAPIRequestOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        complete(JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err, id JSON) {
        error(err);
    }];
    
    [operation start];
}


#pragma mark -
#pragma mark Utility Methods
- (NSURLRequest*) requestWithTemplate:(NSString*) template options:(JiveRequestOptions*) options andArgs:(NSString*) args,...{
    
    NSMutableString* requestString = [NSMutableString stringWithFormat:template, args];
    
    if([options isValid]) {
        
        [requestString appendString:@"?"];
        
        if(options.beforeDate) {
            [requestString appendFormat:@"before=%@&", options.beforeDate];
        }
        
        if(options.afterDate) {
             [requestString appendFormat:@"after=%@&", options.beforeDate];
        }
        
        // Limit how many can be used?
        if(options.count > 0) {
            [requestString appendFormat:@"count=%d&", options.count];
        }
        
        // Get rid of trailing ampersand
        [requestString deleteCharactersInRange:NSMakeRange([requestString length]-1, 1)];
    }
    
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
