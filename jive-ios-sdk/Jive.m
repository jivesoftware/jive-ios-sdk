//
//  Jive.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "Jive.h"
#import "JAPIRequestOperation.h"


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

- (RACAsyncSubject*) me:(void(^)(id)) complete onError:(void(^)(NSError*)) error {
    
    RACAsyncSubject *subject = [RACAsyncSubject subject];
    
    NSURLRequest* request = [self requestWithTemplate:@"/api/core/v3/people/@me" andArgs:nil];
    
     JAPIRequestOperation *operation = [JAPIRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [subject sendNext:JSON];
        [subject sendCompleted];
        complete(JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err, id JSON) {
        [subject sendError:err];
        error(err);
    }];
    
    [operation start];
    
    return subject;
    
}

#pragma mark -
#pragma mark Utility Methods
- (NSURLRequest*) requestWithTemplate:(NSString*) template andArgs:(NSString*) args,...{
    
    NSString* requestString = [NSString stringWithFormat:template, args];
    
    NSURL* requestURL = [_jiveInstance URLByAppendingPathComponent:requestString];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    if(_delegate && [_delegate respondsToSelector:@selector(credentialsForJiveInstance:)]) {
        JiveCredentials *credentials = [_delegate credentialsForJiveInstance:requestURL];
        [credentials applyToRequest:request];
    } 
    
    return request;
}

@end
