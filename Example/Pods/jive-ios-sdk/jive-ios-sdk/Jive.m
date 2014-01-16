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

#import "Jive_internal.h"
#import "JiveRetryingJAPIRequestOperation.h"
#import "NSData+JiveBase64.h"
#import "NSError+Jive.h"
#import "JiveTargetList_internal.h"
#import "JiveAssociationTargetList_internal.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "NSData+JiveBase64.h"
#import "JiveTypedObject_internal.h"
#import "NSString+Jive.h"
#import "JiveRetryingHTTPRequestOperation.h"
#import "JiveRetryingImageRequestOperation.h"
#import "JiveMetadata_internal.h"
#import "JiveHTTPBasicAuthCredentials.h"
#import "TFHpple.h"

typedef NS_ENUM(NSInteger, JVPushRegistrationFeatureFlag) {
    JVPushRegistrationFeatureFlagPush = 0x01,
    JVPushRegistrationFeatureFlagAnnouncement = 0x02,
    JVPushRegistrationFeatureFlagLatestAcclaim = 0x04,
    JVPushRegistrationFeatureFlagVideo = 0x08,
    JVPushRegistrationFeatureFlagIdea = 0x010,
    JVPushRegistrationFeatureFlagPoll = 0x020,
    JVPushRegistrationFeatureFlagTask = 0x040,
};

static NSString* const JiveOAuthGrantTypeKey = @"grant_type";
static NSString* const JiveOAuthUserNameKey = @"username";
static NSString* const JiveOAuthPasswordKey = @"password";
static NSString* const JiveOAuthClientIDKey = @"client_id";
static NSString* const JiveOAuthClientSecretKey = @"client_secret";
static NSString* const JiveOAuthAccessTokenKey = @"access_token";
static NSString* const JiveOAuthRefreshTokenKey = @"refresh_token";
static NSString* const JiveOAuthExpiresInKey = @"expires_in";

struct JiveHTTPMethodTypes const JiveHTTPMethodTypes = {
    .POST = @"POST",
    .PUT = @"PUT",
    .DELETE = @"DELETE"
};

struct JiveRequestPathComponents const JiveRequestPathComponents = {
    .pushNotification = @"api/core/mobile/v1/pushNotification",
    .oauthToken = @"oauth2/token",
    .inbox = @"inbox",
    .people = @"people",
    .places = @"places",
    .contents = @"contents",
    .recommended = @"recommended",
    .trending = @"trending",
    .activities = @"activities",
    .frequent = @"frequent",
    .content = @"content",
    .recent = @"recent",
    .outcomes = @"outcomes",
    .metadata = @"metadata",
    .metadataProperties = @"metadata/properties",
    .me = @"@me",
    .search = @"search",
    .editable = @"editable"
};


int const JivePushDeviceType = 3;

@interface JiveInvite (internal)

+ (NSString *) jsonForState:(enum JiveInviteState)state;

@end

@interface NSURL (JiveDateParameterValue)

- (NSDate *)jive_dateFromValueOfParameterWithName:(NSString *)parameterName;

@end

@implementation Jive

- (AFJSONRequestOperation<JiveRetryingOperation> *) versionOperationForInstance:(NSURL *)jiveInstanceURL
                                                                     onComplete:(JivePlatformVersionBlock)completeBlock
                                                                        onError:(JiveErrorBlock)errorBlock {
    NSURL* requestURL = [NSURL URLWithString:@"api/version"
                               relativeToURL:jiveInstanceURL];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setHTTPShouldHandleCookies:NO];
    JAPIRequestOperation<JiveRetryingOperation> *operation = [self operationWithRequest:request
                                                                                 onJSON:(^(id JSON) {
        self.platformVersion = [self parseObjectOfClass:[JivePlatformVersion class] fromJSON:JSON];
        if (_platformVersion) {
            BOOL foundValidCoreVersion = NO;
            for (JiveCoreVersion *coreURI in self.platformVersion.coreURI) {
                if ([coreURI.version isEqualToNumber:@3]) {
                    foundValidCoreVersion = YES;
                    self.baseURI = [coreURI.uri stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
                    break;
                }
            }
            
            if (foundValidCoreVersion) {
                if (completeBlock) {
                    completeBlock(self.platformVersion);
                }
            } else {
                if (errorBlock) {
                    errorBlock([NSError jive_errorWithUnsupportedJivePlatformVersion:self.platformVersion]);
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

- (void) versionForInstance:(NSURL *)jiveInstanceURL
                 onComplete:(JivePlatformVersionBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock {
    [[self versionOperationForInstance:jiveInstanceURL
                            onComplete:completeBlock
                               onError:errorBlock] start];
}

+ (void)initialize {
	if([[NSData class] instanceMethodSignatureForSelector:@selector(jive_base64EncodedString:)] == NULL)
		[NSException raise:NSInternalInconsistencyException format:@"** Expected method not present; the method jive_base64EncodedString: is not implemented by NSData. If you see this exception it is likely that you are using the static library version of Jive and your project is not configured correctly to load categories from static libraries. Did you forget to add the -ObjC and -all_load linker flags?"];
}


- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL
      authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate {
    self = [super init];
    if(self) {
        _jiveInstanceURL = jiveInstanceURL;
        self.delegate = delegate;
    }
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return self;
}

- (NSString *)baseURI {
    if (!_baseURI) {
        _baseURI = @"api/core/v3";
    }
    
    return _baseURI;
}

- (JiveMetadata *)instanceMetadata {
    if (!_instanceMetadata) {
        _instanceMetadata = [[JiveMetadata alloc] initWithInstance:self];
    }
    
    return _instanceMetadata;
}

#pragma mark - helper methods

- (NSString *)appendPathToBaseURI:(NSString *)path {
    return [self.baseURI stringByAppendingPathComponent:path];
}

- (id)parseObjectOfClass:(Class)clazz fromJSON:(id)JSON {
    self.badInstanceURL = nil;
    return [clazz objectFromJSON:JSON withInstance:self];
}

- (NSArray *)parseObjectsOfClass:(Class)clazz FromJSONList:(id)JSON {
    self.badInstanceURL = nil;
    return [clazz objectsFromJSONList:JSON withInstance:self];
}

- (NSString *)validateURLString:(NSString *)sourceString {
    NSString *instanceURL = self.jiveInstanceURL.absoluteString;
    
    if (instanceURL && ![sourceString hasPrefix:instanceURL]) {
        if (!self.badInstanceURL) {
            NSRange baseURIRange = [sourceString rangeOfString:self.baseURI];
            
            if (baseURIRange.location == NSNotFound) {
                return sourceString;
            }
            
            self.badInstanceURL = [sourceString substringToIndex:baseURIRange.location];
        }
        
        sourceString = [sourceString stringByReplacingOccurrencesOfString:self.badInstanceURL
                                                               withString:instanceURL];
    }
    
    return sourceString;
}

- (NSString *)createStringWithInstanceURLValidation:(NSString *)sourceString {
    if ([sourceString hasPrefix:@"http"]) {
        sourceString = [self validateURLString:sourceString];
    } else if ([sourceString hasPrefix:@"<body>"] && self.badInstanceURL) {
        TFHpple *htmlParser = [TFHpple hppleWithHTMLData:[sourceString dataUsingEncoding:NSUTF8StringEncoding]];
        NSArray *linkArray = [htmlParser searchWithXPathQuery:@"//a"];
        
        for (TFHppleElement *anchor in linkArray) {
            NSString *objectID = [anchor objectForKey:@"data-objectid"];
            NSString *href = [anchor objectForKey:@"href"];
            NSString *extendedHref = [NSString stringWithFormat:@"href=\"%@\"", href];
            
            if (objectID) {
                NSString *newHrefURL = [href stringByReplacingOccurrencesOfString:self.badInstanceURL
                                                                       withString:self.jiveInstanceURL.absoluteString];
                NSString *newHrefString = [NSString stringWithFormat:@"href=\"%@\"", newHrefURL];
                
                sourceString = [sourceString stringByReplacingOccurrencesOfString:extendedHref
                                                                       withString:newHrefString];
            } else {
                TFHppleElement *imageElement = [anchor firstChildWithTagName:@"img"];
                NSString *src = [imageElement objectForKey:@"src"];
                
                if (src && [src rangeOfString:@"servlet/JiveServlet/"].length > 0) {
                    NSString *sourceLink = [NSString stringWithFormat:@"src=\"%@\"", src];
                    NSString *newHrefURL = [href stringByReplacingOccurrencesOfString:self.badInstanceURL
                                                                           withString:self.jiveInstanceURL.absoluteString];
                    NSString *newSourceURL = [src stringByReplacingOccurrencesOfString:self.badInstanceURL
                                                                            withString:self.jiveInstanceURL.absoluteString];
                    NSString *newHrefString = [NSString stringWithFormat:@"href=\"%@\"", newHrefURL];
                    NSString *newSourceLink = [NSString stringWithFormat:@"src=\"%@\"", newSourceURL];
                    
                    sourceString = [sourceString stringByReplacingOccurrencesOfString:extendedHref
                                                                           withString:newHrefString];
                    sourceString = [sourceString stringByReplacingOccurrencesOfString:sourceLink
                                                                           withString:newSourceLink];
                }
            }
        }
    }
    
    return [NSString stringWithString:sourceString];
}

- (NSURL *)createURLWithInstanceValidation:(NSString *)urlString {
    return [NSURL URLWithString:[self validateURLString:urlString]];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)pushRegistrationInfoForDevice:(NSString *)deviceToken onComplete:(JiveArrayCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:nil
                                                     andTemplate:@"%@/info?deviceToken=%@",
                             JiveRequestPathComponents.pushNotification, deviceToken, nil];
    return [self operationWithRequest:request onComplete:completeBlock onError:errorBlock responseHandler:^NSArray *(id JSON) {
        return JSON;
    }];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)registerDeviceForJivePushNotifications:(NSString *)deviceToken onComplete:(JiveCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:@"%@/register",
                                    JiveRequestPathComponents.pushNotification, nil];
    NSString *postString = [NSString stringWithFormat:@"deviceToken=%@&deviceType=%i&activated=true&featureFlags=%i", deviceToken, JivePushDeviceType, JVPushRegistrationFeatureFlagPush | JVPushRegistrationFeatureFlagVideo];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    
    return [self emptyOperationWithRequest:request onComplete:completeBlock onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)unRegisterDeviceForJivePushNotifications:(NSString *)deviceToken onComplete:(JiveCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:@"%@/unregister",
                                    JiveRequestPathComponents.pushNotification, nil];
    NSString *postString = [NSString stringWithFormat:@"deviceToken=%@", deviceToken];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    
    return [self emptyOperationWithRequest:request onComplete:completeBlock onError:errorBlock];
}

-(AFJSONRequestOperation*)OAuthTokenOperationWithOAuthID:(NSString*)oauthID OAuthSecret:(NSString*)oauthSecret username:(NSString*)username password:(NSString*)password onComplete:(void(^)(JiveOAuthCredentials*))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    NSDictionary *postParams = @{JiveOAuthGrantTypeKey: JiveOAuthPasswordKey,
                                 JiveOAuthUserNameKey: username,
                                 JiveOAuthPasswordKey: password};
    
    AFHTTPClient *HTTPClient = [[AFHTTPClient alloc] initWithBaseURL:self.jiveInstanceURL];
    NSMutableURLRequest* request = [HTTPClient requestWithMethod:JiveHTTPMethodTypes.POST
                                                            path:JiveRequestPathComponents.oauthToken
                                                      parameters:postParams];
    
    [request setHTTPShouldHandleCookies:NO];
    
    return [self OAuthTokenRequestOperationWithHTTPRequest:request OAuthID:oauthID OAuthSecret:oauthSecret onComplete:completeBlock onError:errorBlock];
}

-(void)OAuthTokenWithOAuthID:(NSString*)oauthID OAuthSecret:(NSString*)oauthSecret username:(NSString*)username password:(NSString*)password onComplete:(void(^)(JiveOAuthCredentials*))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    [[self OAuthTokenOperationWithOAuthID:oauthID OAuthSecret:oauthSecret username:username password:password onComplete:completeBlock onError:errorBlock] start];
}

-(AFJSONRequestOperation*)OAuthTokenOperationWithOAuthID:(NSString*)oauthID OAuthSecret:(NSString*)oauthSecret onComplete:(void(^)(JiveOAuthCredentials*))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    NSMutableURLRequest * request = [self credentialedRequestWithOptions:nil andTemplate:JiveRequestPathComponents.oauthToken, nil];
    
    NSString *postParams = @"grant_type=session";
    [request setHTTPBody:[postParams dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    
    return [self OAuthTokenRequestOperationWithHTTPRequest:request OAuthID:oauthID OAuthSecret:oauthSecret onComplete:completeBlock onError:errorBlock];
}


-(void)OAuthTokenWithOAuthID:(NSString*)oauthID OAuthSecret:(NSString*)oauthSecret onComplete:(void(^)(JiveOAuthCredentials*))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    [[self OAuthTokenOperationWithOAuthID:oauthID OAuthSecret:oauthSecret onComplete:completeBlock onError:errorBlock] start];
}

-(AFJSONRequestOperation*)OAuthTokenRequestOperationWithHTTPRequest:(NSMutableURLRequest*)request OAuthID:(NSString*)oauthID OAuthSecret:(NSString*)oauthSecret onComplete:(void(^)(JiveOAuthCredentials*))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    // apply the client ID / secret
    JiveHTTPBasicAuthCredentials *authSecrets = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:oauthID password:oauthSecret];
    [authSecrets applyToRequest:request];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            JiveOAuthCredentials * creds = [[JiveOAuthCredentials alloc] initWithAccessToken:[JSON objectForKey:JiveOAuthAccessTokenKey]
                                                                                                                                                                refreshToken:[JSON objectForKey:JiveOAuthRefreshTokenKey]
                                                                                                                                                                  expiryDate:[NSDate dateWithTimeIntervalSinceNow:[[JSON objectForKey:JiveOAuthExpiresInKey] doubleValue] ]];
                                                                                            
                                                                                            completeBlock(creds);
                                                                                            
                                                                                        }
                                                                                        failure:^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            errorBlock(error);
                                                                                        }];
    
    return operation;
    
}



-(AFJSONRequestOperation*)OAuthTokenRefreshOperationWithOAuthID:(NSString*)oauthID OAuthSecret:(NSString*)oauthSecret refreshToken:(NSString*)refreshToken onComplete:(void(^)(JiveOAuthCredentials*))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    NSDictionary *postParams = @{JiveOAuthGrantTypeKey: JiveOAuthRefreshTokenKey,
                                 JiveOAuthRefreshTokenKey: refreshToken,
                                 JiveOAuthClientIDKey: oauthID,
                                 JiveOAuthClientSecretKey: oauthSecret};
    
    AFHTTPClient *HTTPClient = [[AFHTTPClient alloc] initWithBaseURL:self.jiveInstanceURL];
    NSMutableURLRequest* request = [HTTPClient requestWithMethod:JiveHTTPMethodTypes.POST
                                                            path:JiveRequestPathComponents.oauthToken
                                                      parameters:postParams];
    [request setHTTPShouldHandleCookies:NO];
    
    JiveHTTPBasicAuthCredentials *authSecrets = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:oauthID password:oauthSecret];
    [authSecrets applyToRequest:request];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            JiveOAuthCredentials * creds = [[JiveOAuthCredentials alloc] initWithAccessToken:[JSON objectForKey:JiveOAuthAccessTokenKey]
                                                                                                                                                                refreshToken:[JSON objectForKey:JiveOAuthRefreshTokenKey]
                                                                                                                                                                  expiryDate:[NSDate dateWithTimeIntervalSinceNow:[[JSON objectForKey:JiveOAuthExpiresInKey] doubleValue] ]];
                                                                                            
                                                                                            completeBlock(creds);
                                                                                            
                                                                                        }
                                                                                        failure:^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            errorBlock(error);
                                                                                        }];
    
    return operation;
}

-(void)OAuthTokenRefreshWithOAuthID:(NSString*)oauthID OAuthSecret:(NSString*)oauthSecret refreshToken:(NSString*)refreshToken onComplete:(void(^)(JiveOAuthCredentials*))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    [[self OAuthTokenRefreshOperationWithOAuthID:oauthID OAuthSecret:oauthSecret refreshToken:refreshToken onComplete:completeBlock onError:errorBlock] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)OAuthRevocationOperationWithOAuthCredentials:(JiveOAuthCredentials*)credentials onComplete:(void(^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    AFHTTPClient *HTTPClient = [[AFHTTPClient alloc] initWithBaseURL:self.jiveInstanceURL];
    NSMutableURLRequest* request = [HTTPClient requestWithMethod:JiveHTTPMethodTypes.POST
                                                            path:@"/oauth2/revoke"
                                                      parameters:nil];
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    [credentials applyToRequest:request];
    return [self emptyOperationWithRequest:request onComplete:completeBlock onError:errorBlock];
    
}

-(void)OAuthRevocationWithOAuthCredentials:(JiveOAuthCredentials*)credentials onComplete:(void(^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    [[self OAuthRevocationOperationWithOAuthCredentials:credentials onComplete:completeBlock onError:errorBlock] start];
}

-(AFJSONRequestOperation*)mobileQuestCompletionOperationWithOnComplete:(void(^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:@"/api/core/mobile/v1/quest/form_login", nil];
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    return [self emptyOperationWithRequest:request onComplete:completeBlock onError:errorBlock];
}

-(void)mobileQuestCompletionWithOnComplete:(void(^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self mobileQuestCompletionOperationWithOnComplete:completeBlock onError:errorBlock] start];
}



- (AFJSONRequestOperation<JiveRetryingOperation> *) getPeopleArray:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[self appendPathToBaseURI:callName],
                             nil];
    
    return [self listOperationForClass:[JivePerson class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) peopleResourceOperation:(NSURL *)url withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[url path],
                             nil];
    
    return [self listOperationForClass:[JivePerson class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)personResourceOperation:(NSURL *)url withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[url path],
                             nil];
    
    return [self entityOperationForClass:[JivePerson class]
                                 request:request
                              onComplete:completeBlock
                                 onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)activitiesResourceOperation:(NSURL *)url withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[url path],
                             nil];
    
    return [self listOperationForClass:[JiveActivity class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)streamsResourceOperation:(NSURL *)url withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[url path],
                             nil];
    
    return [self listOperationForClass:[JiveStream class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)contentsResourceOperation:(NSURL *)url withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[url path],
                             nil];
    
    return [self listOperationForClass:[JiveContent class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)personByOperation:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSString *pathComponents = [JiveRequestPathComponents.people stringByAppendingPathComponent:personId];
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[self appendPathToBaseURI:pathComponents],
                             nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self entityOperationForClass:[JivePerson class]
                                                                                     request:request
                                                                                  onComplete:completeBlock
                                                                                     onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) contentsListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[self appendPathToBaseURI:callName],
                             nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self listOperationForClass:[JiveContent class]
                                                                                   request:request
                                                                                onComplete:completeBlock
                                                                                   onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) placeListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[self appendPathToBaseURI:callName],
                             nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self listOperationForClass:[JivePlace class]
                                                                                   request:request
                                                                                onComplete:completeBlock
                                                                                   onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) activityListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions> *)options onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[self appendPathToBaseURI:callName],
                             nil];
    
    return [self listOperationForClass:[JiveActivity class]
                               request:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) activityDateLimitedListOperation:(NSString *)callName withOptions:(NSObject<JiveRequestOptions> *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
                                                     andTemplate:[self appendPathToBaseURI:callName],
                             nil];
    
    return [self dateLimitedListOperationForClass:[JiveActivity class]
                                          request:request
                                       onComplete:!completeBlock ? nil :
            ^(NSArray *objects, NSDate *earliestDate, NSDate *latestDate, NSNumber *unreadCount) {
                completeBlock(objects, earliestDate, latestDate);
            }
                                          onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createContentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options andTemplate:(NSString *)template onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:content
                                                     options:options
                                                 andTemplate:template, nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (AFImageRequestOperation<JiveRetryingOperation> *) imageOperationForPath:(NSString *)path
                                                                   options:(JiveDefinedSizeRequestOptions *)options
                                                                onComplete:(JiveImageCompleteBlock)completeBlock
                                                                   onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [self credentialedRequestWithOptions:options andTemplate:path, nil];
    void (^heapCompleteBlock)(UIImage *) = [completeBlock copy];
    void (^heapErrorBlock)(NSError *) = [errorBlock copy];
    AFImageRequestOperation<JiveRetryingOperation> *avatarOperation = [[JiveRetryingImageRequestOperation alloc] initWithRequest:mutableURLRequest];
    [avatarOperation setCompletionBlockWithSuccess:(^(AFHTTPRequestOperation *operation, id image) {
        if (heapCompleteBlock) {
            heapCompleteBlock(image); // AFImageRequestOperation guarantees that this is a UIImage.
        }
    })
                                           failure:(^(AFHTTPRequestOperation *operation, NSError *error) {
        if (heapErrorBlock) {
            heapErrorBlock(error);
        }
    })];
    [self setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:avatarOperation];
    return avatarOperation;
}

#pragma mark - public API
#pragma mark - generic

// Activities
- (void) activitiesWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self activitiesOperationWithOptions:options
                                                                                         onComplete:completeBlock
                                                                                            onError:errorBlock];
    [operation start];
}

- (void) actions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self actionsOperation:options onComplete:complete onError:error] start];
}

- (void) frequentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self frequentContentOperationWithOptions:options
                                                                       onComplete:completeBlock
                                                                          onError:errorBlock];
    [operation start];
}

- (void) frequentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self frequentPeopleOperationWithOptions:options
                                                                      onComplete:completeBlock
                                                                         onError:errorBlock];
    [operation start];
}

- (void) frequentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self frequentPlacesOperationWithOptions:options
                                                                      onComplete:completeBlock
                                                                         onError:errorBlock];
    [operation start];
}

- (void) recentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self recentContentOperationWithOptions:options
                                                                     onComplete:completeBlock
                                                                        onError:errorBlock];
    [operation start];
}

- (void) recentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self recentPeopleOperationWithOptions:options
                                                                    onComplete:completeBlock
                                                                       onError:errorBlock];
    [operation start];
}

- (void) recentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self recentPlacesOperationWithOptions:options
                                                                    onComplete:completeBlock
                                                                       onError:errorBlock];
    [operation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) activitiesOperationWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self activityDateLimitedListOperation:JiveRequestPathComponents.activities
                                      withOptions:options
                                       onComplete:completeBlock
                                          onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) activitiesOperationWithURL:(NSURL *)activitiesURL onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:activitiesURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:activitiesURL];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self dateLimitedListOperationForClass:[JiveActivity class]
                                                                                              request:mutableURLRequest
                                                                                           onComplete:!completeBlock ? nil :
                                                                ^(NSArray *objects, NSDate *earliestDate, NSDate *latestDate, NSNumber *unreadCount) {
                                                                    completeBlock(objects, earliestDate, latestDate);
                                                                }
                                                                                              onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) actionsOperation:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activityListOperation:@"actions" withOptions:options onComplete:complete onError:error];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) frequentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:  (JiveErrorBlock)errorBlock {
    NSString *path = [JiveRequestPathComponents.activities stringByAppendingPathComponent:JiveRequestPathComponents.frequent];
    
    path = [path stringByAppendingPathComponent:JiveRequestPathComponents.content];
    return [self contentsListOperation:path
                           withOptions:options
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) frequentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSString *path = [JiveRequestPathComponents.activities stringByAppendingPathComponent:JiveRequestPathComponents.frequent];
    
    path = [path stringByAppendingPathComponent:JiveRequestPathComponents.people];
    return [self getPeopleArray:path withOptions:options onComplete:completeBlock onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) frequentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSString *path = [JiveRequestPathComponents.activities stringByAppendingPathComponent:JiveRequestPathComponents.frequent];
    
    path = [path stringByAppendingPathComponent:JiveRequestPathComponents.places];
    return [self placeListOperation:path
                        withOptions:options
                         onComplete:completeBlock
                            onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) recentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSString *path = [JiveRequestPathComponents.activities stringByAppendingPathComponent:JiveRequestPathComponents.recent];
    
    path = [path stringByAppendingPathComponent:JiveRequestPathComponents.content];
    return [self contentsListOperation:path
                           withOptions:options
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) recentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSString *path = [JiveRequestPathComponents.activities stringByAppendingPathComponent:JiveRequestPathComponents.recent];
    
    path = [path stringByAppendingPathComponent:JiveRequestPathComponents.people];
    return [self getPeopleArray:path withOptions:options onComplete:completeBlock onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) recentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSString *path = [JiveRequestPathComponents.activities stringByAppendingPathComponent:JiveRequestPathComponents.recent];
    
    path = [path stringByAppendingPathComponent:JiveRequestPathComponents.places];
    return [self placeListOperation:path
                        withOptions:options
                         onComplete:completeBlock
                            onError:errorBlock];
}

#pragma mark - Announcements

- (void) announcementsWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self announcementsOperationWithOptions:options
                                                                     onComplete:completeBlock
                                                                        onError:errorBlock];
    [operation start];
}

- (void) announcementWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self announcementOperationWithAnnouncement:announcement
                                                                            options:options
                                                                         onComplete:completeBlock
                                                                            onError:errorBlock];
    [operation start];
}

- (void) deleteAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self deleteAnnouncementOperationWithAnnouncement:announcement
                                                                               onComplete:completeBlock
                                                                                  onError:errorBlock];
    [operation start];
}

- (void) markAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self markAnnouncementOperationWithAnnouncement:announcement
                                                                                 asRead:read
                                                                             onComplete:completeBlock
                                                                                onError:errorBlock];
    [operation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) announcementsOperationWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self contentsListOperation:@"announcements"
                           withOptions:options
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) announcementOperationWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[announcement.selfRef path], nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self entityOperationForClass:[JiveAnnouncement class]
                                                                                     request:request
                                                                                  onComplete:completeBlock
                                                                                     onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deleteAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[announcement.selfRef path], nil];
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self emptyOperationWithRequest:request
                                                                                    onComplete:completeBlock
                                                                                       onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) markAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[announcement.readRef path], nil];
    if (read) {
        [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    } else {
        [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    }
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self emptyOperationWithRequest:request
                                                                                    onComplete:completeBlock
                                                                                       onError:errorBlock];
    return operation;
}

#pragma mark - Inbox

- (void) inbox:(JiveInboxOptions*) options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self inboxOperation:options
                                                  onComplete:completeBlock
                                                     onError:errorBlock];
    [operation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)inboxOperation:(JiveInboxOptions *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options
                                                            andTemplate:@"%@/%@",
                                    self.baseURI, JiveRequestPathComponents.inbox, nil];
    
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self dateLimitedListOperationForClass:[JiveInboxEntry class]
                                                                                              request:request
                                                                                           onComplete:!completeBlock ? nil :
                                                                ^(NSArray *objects, NSDate *earliestDate, NSDate *latestDate, NSNumber *unreadCount) {
                                                                    completeBlock(objects, earliestDate, latestDate);
                                                                }
                                                                                              onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)inboxWithUnreadCountOperation:(JiveInboxOptions *)options
                                                                      onComplete:(JiveInboxObjectsCompleteBlock)completeBlock
                                                                         onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options
                                                            andTemplate:@"%@/%@",
                                    self.baseURI, JiveRequestPathComponents.inbox, nil];
    
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self dateLimitedListOperationForClass:[JiveInboxEntry class]
                                                                                              request:request
                                                                                           onComplete:completeBlock
                                                                                              onError:errorBlock];
    return operation;
}

- (void)inboxWithUnreadCount:(JiveInboxOptions *)options
                  onComplete:(JiveInboxObjectsCompleteBlock)completeBlock
                     onError:(JiveErrorBlock)errorBlock {
    [[self inboxWithUnreadCountOperation:options onComplete:completeBlock onError:errorBlock] start];
}

- (void) markInboxEntries:(NSArray *)inboxEntries asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableSet *inboxEntryUpdates = [NSMutableSet new];
    
    for (JiveInboxEntry *inboxEntry in inboxEntries) {
        if (inboxEntry.jive.update) {
            [inboxEntryUpdates addObject:inboxEntry.jive.update];
        } else if (inboxEntry.jive.updateCollection) { // Acclaim uses updateCollection instead of update.
            [inboxEntryUpdates addObject:inboxEntry.jive.updateCollection];
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
    
    NSString *HTTPMethod = read ? JiveHTTPMethodTypes.POST : JiveHTTPMethodTypes.DELETE;
    NSMutableArray *operations = [NSMutableArray new];
    for (NSURL *updateURL in incompleteOperationUpdateURLs) {
        NSMutableURLRequest *markRequest = [NSMutableURLRequest requestWithURL:updateURL];
        [markRequest setHTTPMethod:HTTPMethod];
        [self maybeApplyCredentialsToMutableURLRequest:markRequest
                                                forURL:updateURL];
        [self maybeLogMaybeBadRequest:markRequest];
        JiveRetryingJAPIRequestOperation *operation = [JiveRetryingJAPIRequestOperation JSONRequestOperationWithRequest:markRequest
                                                                                                                success:(^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            markOperationCompleteBlock(request, nil);
        })
                                                                                                                failure:(^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            markOperationCompleteBlock(request, error);
        })];
        [operations addObject:operation];
        [self setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:operation];
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
    AFJSONRequestOperation *operation = [self personOperationWithURL:personURL
                                                          onComplete:completeBlock
                                                             onError:errorBlock];
    
    [operation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)personOperationWithURL:(NSURL *)personURL onComplete:(void (^)(JivePerson *person))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:personURL];
    
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:personURL];
    
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self entityOperationForClass:[JivePerson class]
                                                                                     request:mutableURLRequest
                                                                                  onComplete:completeBlock
                                                                                     onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)peopleOperation:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self getPeopleArray:JiveRequestPathComponents.people
                    withOptions:options
                     onComplete:complete
                        onError:error];
}

- (void) people:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self peopleOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)recommendedPeopleOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self getPeopleArray:[JiveRequestPathComponents.people stringByAppendingPathComponent:JiveRequestPathComponents.recommended]
                    withOptions:options
                     onComplete:complete
                        onError:error];
}

- (void) recommendedPeople:(JiveCountRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(JiveErrorBlock) error {
    [[self recommendedPeopleOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)trendingOperation:(JiveTrendingPeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self getPeopleArray:[JiveRequestPathComponents.people stringByAppendingPathComponent:JiveRequestPathComponents.trending]
                    withOptions:options
                     onComplete:complete
                        onError:error];
}

- (void) trending:(JiveTrendingPeopleRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(JiveErrorBlock) error {
    [[self trendingOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)personOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personResourceOperation:person.selfRef
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) person:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self personOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)meOperation:(void(^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personByOperation:JiveRequestPathComponents.me
                       withOptions:nil
                        onComplete:complete
                           onError:error];
}

- (void) me:(void(^)(JivePerson *)) complete onError:(JiveErrorBlock) error {
    [[self meOperation:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)personByEmailOperation:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personByOperation:[NSString stringWithFormat:@"email/%@", email] withOptions:options onComplete:complete onError:error];
}

- (void) personByEmail:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self personByEmailOperation:email withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)personByUserNameOperation:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personByOperation:[NSString stringWithFormat:@"username/%@", userName] withOptions:options onComplete:complete onError:error];
}

- (void) personByUserName:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self personByUserNameOperation:userName withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)managerOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personResourceOperation:person.managerRef
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) manager:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self managerOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)person:(NSString *)personId reportsOperation:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    return [self personByOperation:[NSString stringWithFormat:@"%@/@reports/%@", personId, reportsPersonId] withOptions:options onComplete:complete onError:error];
}

- (void) person:(NSString *)personId reports:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self person:personId reportsOperation:reportsPersonId withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deletePersonOperation:(JivePerson *)person onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[person.selfRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deletePerson:(JivePerson *)person onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deletePersonOperation:person onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)activitiesOperation:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activitiesResourceOperation:person.activityRef
                                 withOptions:options
                                  onComplete:complete
                                     onError:error];
}

- (void) activities:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self activitiesOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) colleguesOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:person.colleaguesRef
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) collegues:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self colleguesOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) followersOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:person.followersRef
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) followersOperation:(JivePerson *)person onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self followersOperation:person withOptions:nil onComplete:complete onError:error];
}

- (void) followers:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self followersOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (void) followers:(JivePerson *)person onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [self followers:person withOptions:nil onComplete:complete onError:error];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)reportsOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:person.reportsRef
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) reports:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self reportsOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)followingOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:person.followingRef
                             withOptions:options
                              onComplete:complete
                                 onError:error];
}

- (void) following:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self followingOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)blogOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[person.blogRef path], nil];
    
    return [self entityOperationForClass:[JiveBlog class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) blog:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(JiveErrorBlock)errorBlock {
    [[self blogOperation:person withOptions:options onComplete:complete onError:errorBlock] start];
}

- (AFImageRequestOperation<JiveRetryingOperation> *) avatarForPersonOperation:(JivePerson *)person onComplete:(JiveImageCompleteBlock)complete onError:(JiveErrorBlock)errorBlock {
    return [self imageOperationForPath:[person.avatarRef path]
                               options:nil
                            onComplete:complete
                               onError:errorBlock];
}

- (void) avatarForPerson:(JivePerson *)person onComplete:(void (^)(UIImage *))complete onError:(JiveErrorBlock)error {
    [[self avatarForPersonOperation:person onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) followingInOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self streamsResourceOperation:person.followingInRef
                              withOptions:options
                               onComplete:complete
                                  onError:error];
}

- (void) followingIn:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self followingInOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)updateFollowingInOperation:(NSArray *)followingInStreams forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self followingInRequestWithStreams:followingInStreams options:options template:[person.followingInRef path], nil];
    return [self listOperationForClass:[JiveStream class] request:request onComplete:complete onError:error];
}

- (void)updateFollowingIn:(NSArray *)followingInStreams forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self updateFollowingInOperation:followingInStreams forPerson:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) streamsOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self streamsResourceOperation:person.streamsRef
                              withOptions:options
                               onComplete:complete
                                  onError:error];
}

- (void) streams:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self streamsOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) tasksOperation:(JivePerson *)person withOptions:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsResourceOperation:person.tasksRef
                               withOptions:options
                                onComplete:complete
                                   onError:error];
}

- (void) tasks:(JivePerson *)person withOptions:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self tasksOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) updatePersonOperation:(JivePerson *)person onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:person
                                                     options:nil
                                                 andTemplate:[person.selfRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.PUT];
    return [self entityOperationForClass:[JivePerson class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updatePerson:(JivePerson *)person onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self updatePersonOperation:person onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) personOperation:(JivePerson *)person follow:(JivePerson *)target onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSString *path = [[person.followingRef path] stringByAppendingPathComponent:target.jiveId];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:path, nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.PUT];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) person:(JivePerson *)person follow:(JivePerson *)target onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self personOperation:person follow:target onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) personOperation:(JivePerson *)person unFollow:(JivePerson *)target onComplete:(void (^)(void))complete onError:(JiveErrorBlock)errorBlock {
    NSString *path = [[person.followingRef path] stringByAppendingPathComponent:target.jiveId];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:path, nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request onComplete:complete onError:^(NSError *error) {
        if ([error.userInfo[JiveErrorKeyHTTPStatusCode] isEqualToNumber:@409]) { // 409 is conflict error returned when you try to delete a following relationship that doesn't exist.  We may have this situation
            complete();                                                          // with legacy data when following was done before this fix -TABDEV-2545
        } else {
            errorBlock(error);
        }
    }];
}

- (void) person:(JivePerson *)person unFollow:(JivePerson *)target onComplete:(void (^)(void))complete onError:(JiveErrorBlock)errorBlock {
    [[self personOperation:person unFollow:target onComplete:complete onError:errorBlock] start];
}


- (AFJSONRequestOperation<JiveRetryingOperation> *) createPersonOperation:(JivePerson *)person withOptions:(JiveWelcomeRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:person
                                                     options:options
                                                 andTemplate:[self appendPathToBaseURI:JiveRequestPathComponents.people], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    return [self entityOperationForClass:[JivePerson class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createPerson:(JivePerson *)person withOptions:(JiveWelcomeRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error {
    [[self createPersonOperation:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createTaskOperation:(JiveTask *)task forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:task
                                                     options:options
                                                 andTemplate:[person.tasksRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    return [self entityOperationForClass:[JiveTask class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createTask:(JiveTask *)task forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error {
    [[self createTaskOperation:task forPerson:person withOptions:options onComplete:complete onError:error] start];
}

#pragma mark - Search

- (AFJSONRequestOperation<JiveRetryingOperation> *) searchPeopleRequestOperation:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^) (NSArray *people))complete onError:(JiveErrorBlock)error {
    return [self getPeopleArray:[JiveRequestPathComponents.search stringByAppendingPathComponent:JiveRequestPathComponents.people]
                    withOptions:options
                     onComplete:complete
                        onError:error];
}

- (void) searchPeople:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^)(NSArray *people))complete onError:(JiveErrorBlock)error {
    AFJSONRequestOperation *operation = [self searchPeopleRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) searchPlacesRequestOperation:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(JiveErrorBlock)error {
    return [self placeListOperation:[JiveRequestPathComponents.search stringByAppendingPathComponent:JiveRequestPathComponents.places]
                        withOptions:options
                         onComplete:complete
                            onError:error];
}

- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(JiveErrorBlock)error {
    AFJSONRequestOperation * operation = [self searchPlacesRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) searchContentsRequestOperation:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:[JiveRequestPathComponents.search stringByAppendingPathComponent:JiveRequestPathComponents.contents]
                           withOptions:options
                            onComplete:complete
                               onError:error];
}

- (void) searchContents:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(JiveErrorBlock)error {
    
    AFJSONRequestOperation *operation = [self searchContentsRequestOperation:options onComplete:complete onError:error];
    
    [operation start];
}

#pragma mark - Environment

- (AFJSONRequestOperation<JiveRetryingOperation> *)filterableFieldsOperation:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSString *path = [JiveRequestPathComponents.people stringByAppendingPathComponent:@"@filterableFields"];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:[self appendPathToBaseURI:path], nil];
    
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return JSON;
    }];
}

- (void) filterableFields:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self filterableFieldsOperation:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)supportedFieldsOperation:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSString *path = [JiveRequestPathComponents.people stringByAppendingPathComponent:@"@supportedFields"];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:[self appendPathToBaseURI:path], nil];
    
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return JSON;
    }];
}

- (void) supportedFields:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self supportedFieldsOperation:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)resourcesOperation:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSString *path = [JiveRequestPathComponents.people stringByAppendingPathComponent:@"@resources"];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:[self appendPathToBaseURI:path], nil];
    
    return [self operationWithRequest:request onComplete:complete onError:error responseHandler:^NSArray *(id JSON) {
        return [self parseObjectsOfClass:[JiveResource class] FromJSONList:JSON];
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
    
    AFJSONRequestOperation *operation = nil;
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

- (AFJSONRequestOperation<JiveRetryingOperation> *) contentsOperationWithURL:(NSURL *)contentsURL onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:contentsURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:contentsURL];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self listOperationForClass:[JiveContent class]
                                                                                   request:mutableURLRequest
                                                                                onComplete:completeBlock
                                                                                   onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)contentsOperation:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:JiveRequestPathComponents.contents
                           withOptions:options
                            onComplete:complete
                               onError:error];
}

- (void) contents:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self contentsOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)popularContentsOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:[JiveRequestPathComponents.contents stringByAppendingPathComponent:@"popular"]
                           withOptions:options
                            onComplete:complete
                               onError:error];
}

- (void) popularContents:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self popularContentsOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)recommendedContentsOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:[JiveRequestPathComponents.contents stringByAppendingPathComponent:JiveRequestPathComponents.recommended]
                           withOptions:options
                            onComplete:complete
                               onError:error];
}

- (void) recommendedContents:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self recommendedContentsOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)trendingContentsOperation:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsListOperation:[JiveRequestPathComponents.contents stringByAppendingPathComponent:JiveRequestPathComponents.trending]
                           withOptions:options
                            onComplete:complete
                               onError:error];
}

- (void) trendingContents:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self trendingContentsOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)contentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[content.selfRef path], nil];
    
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) content:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [[self contentOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)commentsOperationForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsResourceOperation:content.commentsRef
                               withOptions:options
                                onComplete:complete
                                   onError:error];
}

- (void) commentsForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self commentsOperationForContent:content withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)contentLikedByOperation:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self peopleResourceOperation:content.likesRef withOptions:options onComplete:complete onError:error];
}

- (void) contentLikedBy:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self contentLikedByOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)activityObjectOperation:(JiveActivityObject *)activityObject onComplete:(void(^)(JiveContent *content))complete onError:(JiveErrorBlock)error {
    NSURL *contentURL = [NSURL URLWithString:activityObject.jiveId];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:contentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:contentURL];
    
    return [self entityOperationForClass:[JiveContent class]
                                 request:mutableURLRequest
                              onComplete:complete
                                 onError:error];
}

- (void) activityObject:(JiveActivityObject *) activityObject contentWithCompleteBlock:(void(^)(JiveContent *content))completeBlock errorBlock:(JiveErrorBlock)errorBlock {
    [[self activityObjectOperation:activityObject onComplete:completeBlock onError:errorBlock] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)commentRootContentOperation:(JiveComment *)comment onComplete:(void(^)(JiveContent *rootContent))complete onError:(JiveErrorBlock)error {
    NSURL *rootContentURL = [NSURL URLWithString:comment.rootURI];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:rootContentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:rootContentURL];
    
    return [self entityOperationForClass:[JiveContent class]
                                 request:mutableURLRequest
                              onComplete:complete
                                 onError:error];
}

- (void) comment:(JiveComment *) comment rootContentWithCompleteBlock:(void(^)(JiveContent *rootContent))completeBlock errorBlock:(JiveErrorBlock)errorBlock {
    [[self commentRootContentOperation:comment onComplete:completeBlock onError:errorBlock] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)messageDiscussionOperation:(JiveMessage *)message onComplete:(void(^)(JiveDiscussion *discussion))complete onError:(JiveErrorBlock)error {
    NSURL *discussionURL = [NSURL URLWithString:message.discussion];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:discussionURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:discussionURL];
    
    return [self entityOperationForClass:[JiveDiscussion class]
                                 request:mutableURLRequest
                              onComplete:complete
                                 onError:error];
}

- (void) message:(JiveMessage *) message discussionWithCompleteBlock:(void(^)(JiveDiscussion *discussion))completeBlock errorBlock:(void(^)(NSError *error))errorBlock {
    [[self messageDiscussionOperation:message onComplete:completeBlock onError:errorBlock] start];
}

- (void) createReplyMessage:(JiveMessage *)replyMessage forDiscussion:(JiveDiscussion *)discussion withOptions:(JiveReturnFieldsRequestOptions *)options completeBlock:(void (^)(JiveMessage *message))completeBlock errorBlock:(void (^)(NSError *error))errorBlock {
    AFJSONRequestOperation *createReplyMessageOperation = [self operationToCreateReplyMessage:replyMessage
                                                                                forDiscussion:discussion
                                                                                  withOptions:options
                                                                                completeBlock:completeBlock
                                                                                   errorBlock:errorBlock];
    [createReplyMessageOperation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) operationToCreateReplyMessage:(JiveMessage *)replyMessage forDiscussion:(JiveDiscussion *)discussion withOptions:(JiveReturnFieldsRequestOptions *)options completeBlock:(void (^)(JiveMessage *message))completeBlock errorBlock:(void (^)(NSError *error))errorBlock {
    AFJSONRequestOperation<JiveRetryingOperation> *createReplyMessageOperation = [self createContentOperation:replyMessage
                                                                                                  withOptions:options
                                                                                                  andTemplate:[discussion.messagesRef path]
                                                                                                   onComplete:(^(JiveContent *content) {
        completeBlock((JiveMessage *)content);
    })
                                                                                                      onError:errorBlock];
    return createReplyMessageOperation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) contentFollowingInOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error {
    return [self streamsResourceOperation:content.followingInRef
                              withOptions:options
                               onComplete:complete
                                  onError:error];
}

- (void) contentFollowingIn:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self contentFollowingInOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)updateFollowingInOperation:(NSArray *)followingInStreams forContent:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self followingInRequestWithStreams:followingInStreams options:options template:[content.followingInRef path], nil];
    return [self listOperationForClass:[JiveStream class] request:request onComplete:complete onError:error];
}

- (void)updateFollowingIn:(NSArray *)followingInStreams forContent:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self updateFollowingInOperation:followingInStreams forContent:content withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) contentOperation:(JiveContent *)content markAsRead:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[content.readRef path], nil];
    
    [request setHTTPMethod:read ? JiveHTTPMethodTypes.POST : JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) content:(JiveContent *)content markAsRead:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self contentOperation:content markAsRead:read onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) contentOperation:(JiveContent *)content likes:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[content.likesRef path], nil];
    
    [request setHTTPMethod:read ? JiveHTTPMethodTypes.POST : JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) content:(JiveContent *)content likes:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self contentOperation:content likes:read onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deleteContentOperation:(JiveContent *)content onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[content.selfRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deleteContent:(JiveContent *)content onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteContentOperation:content onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) updateContentOperation:(JiveContent *)content withOptions:(JiveMinorCommentRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:content
                                                     options:options
                                                 andTemplate:[content.selfRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.PUT];
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updateContent:(JiveContent *)content withOptions:(JiveMinorCommentRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [[self updateContentOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) getEditableContentOperation:(JiveContent *)content
                                                                    withOptions:(JiveReturnFieldsRequestOptions *)options
                                                                     onComplete:(JiveContentCompleteBlock)complete
                                                                        onError:(JiveErrorBlock)error {
    NSString *path = [[content.selfRef path] stringByAppendingPathComponent:JiveRequestPathComponents.editable];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options
                                                            andTemplate:path, nil];
    
    return [self updateJiveTypedObject:content
                           withRequest:request
                            onComplete:complete
                               onError:error];
}

- (void) getEditableContent:(JiveContent *)content
                withOptions:(JiveReturnFieldsRequestOptions *)options
                 onComplete:(JiveContentCompleteBlock)complete
                    onError:(JiveErrorBlock)error {
    [[self getEditableContentOperation:content
                           withOptions:options
                            onComplete:complete
                               onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) lockContentForEditingOperation:(JiveContent *)content
                                                                       withOptions:(JiveReturnFieldsRequestOptions *)options
                                                                        onComplete:(JiveContentCompleteBlock)complete
                                                                           onError:(JiveErrorBlock)error {
    NSString *path = [[content.selfRef path] stringByAppendingPathComponent:JiveRequestPathComponents.editable];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options
                                                            andTemplate:path, nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    return [self updateJiveTypedObject:content
                           withRequest:request
                            onComplete:complete
                               onError:error];
}

- (void) lockContentForEditing:(JiveContent *)content
                   withOptions:(JiveReturnFieldsRequestOptions *)options
                    onComplete:(JiveContentCompleteBlock)complete
                       onError:(JiveErrorBlock)error {
    [[self lockContentForEditingOperation:content
                              withOptions:options
                               onComplete:complete
                                  onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) saveContentWhileEditingOperation:(JiveContent *)content
                                                                         withOptions:(JiveMinorCommentRequestOptions *)options
                                                                          onComplete:(JiveContentCompleteBlock)complete
                                                                             onError:(JiveErrorBlock)error {
    NSString *path = [[content.selfRef path] stringByAppendingPathComponent:JiveRequestPathComponents.editable];
    NSMutableURLRequest *request = [self requestWithJSONBody:content
                                                     options:options
                                                 andTemplate:path, nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.PUT];
    return [self updateJiveTypedObject:content
                           withRequest:request
                            onComplete:complete
                               onError:error];
}

- (void) saveContentWhileEditing:(JiveContent *)content
                     withOptions:(JiveMinorCommentRequestOptions *)options
                      onComplete:(JiveContentCompleteBlock)complete
                         onError:(JiveErrorBlock)error {
    [[self saveContentWhileEditingOperation:content
                                withOptions:options
                                 onComplete:complete
                                    onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) saveDocumentWhileEditingOperation:(JiveDocument *)document
                                                                      withAttachments:(NSArray *)attachmentURLs
                                                                              options:(JiveMinorCommentRequestOptions *)options
                                                                           onComplete:(JiveContentCompleteBlock)complete
                                                                              onError:(JiveErrorBlock)error {
    return [self saveContentWhileEditingOperation:document
                                  withAttachments:attachmentURLs
                                          options:options
                                       onComplete:complete
                                          onError:error];
}

- (void) saveDocumentWhileEditing:(JiveDocument *)document
                  withAttachments:(NSArray *)attachmentURLs
                          options:(JiveMinorCommentRequestOptions *)options
                       onComplete:(JiveContentCompleteBlock)complete
                          onError:(JiveErrorBlock)error {
    [[self saveDocumentWhileEditingOperation:document
                             withAttachments:attachmentURLs
                                     options:options
                                  onComplete:complete
                                     onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) savePostWhileEditingOperation:(JivePost *)post
                                                                  withAttachments:(NSArray *)attachmentURLs
                                                                          options:(JiveMinorCommentRequestOptions *)options
                                                                       onComplete:(JiveContentCompleteBlock)complete
                                                                          onError:(JiveErrorBlock)error {
    return [self saveContentWhileEditingOperation:post
                                  withAttachments:attachmentURLs
                                          options:options
                                       onComplete:complete
                                          onError:error];
}

- (void) savePostWhileEditing:(JivePost *)post
              withAttachments:(NSArray *)attachmentURLs
                      options:(JiveMinorCommentRequestOptions *)options
                   onComplete:(JiveContentCompleteBlock)complete
                      onError:(JiveErrorBlock)error {
    [[self savePostWhileEditingOperation:post
                         withAttachments:attachmentURLs
                                 options:options
                              onComplete:complete
                                 onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) unlockContentOperation:(JiveContent *)content
                                                                onComplete:(JiveCompletedBlock)complete
                                                                   onError:(JiveErrorBlock)error {
    NSString *path = [[content.selfRef path] stringByAppendingPathComponent:JiveRequestPathComponents.editable];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:path, nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request
                                onComplete:complete
                                   onError:error];
}

- (void) unlockContent:(JiveContent *)content
            onComplete:(JiveCompletedBlock)complete
               onError:(JiveErrorBlock)error {
    [[self unlockContentOperation:content onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) messagesOperationForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self contentsResourceOperation:content.messagesRef
                               withOptions:options
                                onComplete:complete
                                   onError:error];
}

- (void) messagesForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self messagesOperationForContent:content withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createContentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:content
                            withOptions:options
                            andTemplate:[self appendPathToBaseURI:JiveRequestPathComponents.contents]
                             onComplete:complete
                                onError:error];
}

- (void) createContent:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [[self createContentOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createDirectMessageOperation:(JiveContent *)content withTargets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options
                                                            andTemplate:[self appendPathToBaseURI:@"dms"], nil];
    NSMutableDictionary *JSON = (NSMutableDictionary *)content.toJSONDictionary;
    [JSON setValue:[targets toJSONArray:YES] forKey:@"participants"];
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createDirectMessage:(JiveContent *)content withTargets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [[self createDirectMessageOperation:content withTargets:targets andOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createCommentOperation:(JiveComment *)comment withOptions:(JiveAuthorCommentRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:comment
                            withOptions:options
                            andTemplate:[self appendPathToBaseURI:@"comments"]
                             onComplete:complete
                                onError:error];
}

- (void) createComment:(JiveComment *)comment withOptions:(JiveAuthorCommentRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [[self createCommentOperation:comment withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createMessageOperation:(JiveMessage *)message withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:message
                            withOptions:options
                            andTemplate:[self appendPathToBaseURI:@"messages"]
                             onComplete:complete
                                onError:error];
}

- (void) createMessage:(JiveMessage *)message withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [[self createMessageOperation:message withOptions:options onComplete:complete onError:error] start];
}

- (NSMutableURLRequest *)createUploadRequestWithOptions:(JiveReturnFieldsRequestOptions *)options
                                         attachmentURLs:(NSArray *)attachmentURLs
                                                content:(JiveContent *)content
                                                   path:(NSString *)path
                                          requestMethod:(NSString *)requestMethod {
    AFHTTPClient *HTTPClient = [[AFHTTPClient alloc] initWithBaseURL:self.jiveInstanceURL];
    NSDictionary *parameters = [NSDictionary jive_dictionaryWithHttpArgumentsString:[options toQueryString]];
    NSMutableURLRequest *request = [HTTPClient multipartFormRequestWithMethod:requestMethod
                                                                         path:path
                                                                   parameters:parameters
                                                    constructingBodyWithBlock:(^(id<AFMultipartFormData> formData) {
        NSData *contentJSONData = [NSJSONSerialization dataWithJSONObject:content.toJSONDictionary
                                                                  options:0
                                                                    error:nil];
        [formData appendPartWithFileData:contentJSONData
                                    name:@"content"
                                fileName:@"content.json"
                                mimeType:@"application/json"];
        for (JiveAttachment *attachment in attachmentURLs) {
            NSURL *fileURL = attachment.url;
            NSString *fileName = [fileURL lastPathComponent];
            NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[fileURL pathExtension], NULL);
            NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
            
            if ([[contentType substringFromIndex:contentType.length - 4] isEqualToString:@"json"]) {
                contentType = @"application/octet-stream";
            }
            
            [formData appendPartWithFileURL:fileURL
                                       name:attachment.name
                                   fileName:fileName
                                   mimeType:contentType
                                      error:nil];
        }
    })];
    
    [self maybeApplyCredentialsToMutableURLRequest:request
                                            forURL:[request URL]];
    
    NSInteger uploadLength = [[request valueForHTTPHeaderField:@"Content-Length"] integerValue];
    
    int const halfMegaByte = 500000;
    int const thirtySeconds = 30;
    if (uploadLength > halfMegaByte) {
        [request setTimeoutInterval:uploadLength * thirtySeconds / halfMegaByte]; // 1 minute per MB assuming a slow connection
    }
    
    return request;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) saveContentWhileEditingOperation:(JiveContent *)content
                                                                     withAttachments:(NSArray *)attachmentURLs
                                                                             options:(JiveReturnFieldsRequestOptions *)options
                                                                          onComplete:(JiveContentCompleteBlock)complete
                                                                             onError:(JiveErrorBlock)error {
    NSString *path = [[content.selfRef path] stringByAppendingPathComponent:JiveRequestPathComponents.editable];
    NSMutableURLRequest *request = [self createUploadRequestWithOptions:options
                                                         attachmentURLs:attachmentURLs
                                                                content:content
                                                                   path:path
                                                          requestMethod:JiveHTTPMethodTypes.PUT];
    
    return [self updateJiveTypedObject:content withRequest:request onComplete:complete onError:error];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createContentOperation:(JiveContent *)content withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    NSString *path = [self appendPathToBaseURI:JiveRequestPathComponents.contents];
    NSMutableURLRequest *request = [self createUploadRequestWithOptions:options
                                                         attachmentURLs:attachmentURLs
                                                                content:content
                                                                   path:path
                                                          requestMethod:JiveHTTPMethodTypes.POST];
    JiveRetryingJAPIRequestOperation *operation = [self entityOperationForClass:[JiveContent class]
                                                                        request:request
                                                                     onComplete:complete
                                                                        onError:error];
    
    return operation;
}

- (void) createContent:(JiveContent *)content withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [[self createContentOperation:content withAttachments:attachmentURLs options:options onComplete:complete onError:error] start];
}

- (void)createDocument:(JiveDocument *)document withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [self createContent:document withAttachments:attachmentURLs options:options onComplete:complete onError:error];
}

- (void)createPost:(JivePost *)post withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [self createContent:post withAttachments:attachmentURLs options:options onComplete:complete onError:error];
}

- (void)createUpdate:(JiveUpdate *)update withAttachments:(NSArray *)attachments options:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    [self createContent:update withAttachments:attachments options:options onComplete:complete onError:error];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)createDocumentOperation:(JiveDocument *)document withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:document withAttachments:attachmentURLs options:options onComplete:complete onError:error];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)createPostOperation:(JivePost *)post withAttachments:(NSArray *)attachmentURLs options:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:post withAttachments:attachmentURLs options:options onComplete:complete onError:error];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)createUpdateOperation:(JiveUpdate *)update withAttachments:(NSArray *)attachments options:(JiveReturnFieldsRequestOptions *)options onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    return [self createContentOperation:update withAttachments:attachments options:options onComplete:complete onError:error];
}

- (void) createShare:(JiveContentBody *)shareMessage
          forContent:(JiveContent *)content
         withTargets:(JiveTargetList *)targets
          andOptions:(JiveReturnFieldsRequestOptions *)options
          onComplete:(void (^)(JiveShare *))completeBlock
             onError:(JiveErrorBlock)errorBlock {
    [[self createShareOperation:shareMessage
                     forContent:content
                    withTargets:targets
                     andOptions:options
                     onComplete:completeBlock
                        onError:errorBlock] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createShareOperation:(JiveContentBody *)shareMessage
                                                              forContent:(JiveContent *)content
                                                             withTargets:(JiveTargetList *)targets
                                                              andOptions:(JiveReturnFieldsRequestOptions *)options
                                                              onComplete:(void (^)(JiveShare *))completeBlock
                                                                 onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options
                                                            andTemplate:[self appendPathToBaseURI:@"shares"], nil];
    NSDictionary *JSON = @{JiveDirectMessageAttributes.participants: [targets toJSONArray:YES],
                           JiveContentAttributes.content: [shareMessage toJSONDictionary],
                           @"shared": [content.selfRef absoluteString]
                           };
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return [self entityOperationForClass:[JiveContent class]
                                 request:request
                              onComplete:completeBlock
                                 onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)toggleCorrectAnswerOperation:(JiveMessage *)message
                                                                     onComplete:(JiveCompletedBlock)completeBlock
                                                                        onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:[message.correctAnswerRef path], nil];
    
    if (message.canMarkAsCorrectAnswer) {
        [request setHTTPMethod:JiveHTTPMethodTypes.PUT];
    } else if (message.canClearMarkAsCorrectAnswer) {
        [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    } else {
        errorBlock([NSError jive_errorWithUnauthorizedActivityObjectType:JiveErrorMessageUnauthorizedUserMarkCorrectAnswer]);
        return nil;
    }
    
    return [self emptyOperationWithRequest:request
                                onComplete:completeBlock
                                   onError:errorBlock];
}

- (void)toggleCorrectAnswer:(JiveMessage *)message
                 onComplete:(JiveCompletedBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock {
    [[self toggleCorrectAnswerOperation:message onComplete:completeBlock onError:errorBlock] start];
}

#pragma mark - Places

- (AFJSONRequestOperation<JiveRetryingOperation> *)placesOperation:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self placeListOperation:JiveRequestPathComponents.places
                        withOptions:options
                         onComplete:complete
                            onError:error];
}

- (void) places:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self placesOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)recommendedPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self placeListOperation:[JiveRequestPathComponents.places stringByAppendingPathComponent:JiveRequestPathComponents.recommended]
                        withOptions:options
                         onComplete:complete
                            onError:error];
}

- (void) recommendedPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self recommendedPlacesOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)trendingPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self placeListOperation:[JiveRequestPathComponents.places stringByAppendingPathComponent:JiveRequestPathComponents.trending]
                        withOptions:options
                         onComplete:complete
                            onError:error];
}

- (void) trendingPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self trendingPlacesOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)placePlacesOperation:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[place.childPlacesRef path], nil];
    
    return [self listOperationForClass:[JivePlace class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) placePlaces:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self placePlacesOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)placeOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[place.selfRef path], nil];
    
    return [self entityOperationForClass:[JivePlace class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void)placeFromURL:(NSURL *)placeURL withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *place))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self placeOperationWithURL:placeURL withOptions:options onComplete:completeBlock onError:errorBlock];
    [operation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)placeOperationWithURL:(NSURL *)placeURL withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *person))completeBlock onError:(JiveErrorBlock)errorBlock {
    
    AFJSONRequestOperation<JiveRetryingOperation> *operation = nil;
    if(placeURL.query == nil || [placeURL.query rangeOfString:@"filter="].location == NSNotFound) {
        NSMutableURLRequest *mutableURLRequest = [self credentialedRequestWithOptions:options andTemplate:[placeURL absoluteString], nil];
        
        operation = [self entityOperationForClass:[JivePlace class]
                                          request:mutableURLRequest
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
    
    return operation;
}

- (void) place:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    [[self placeOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)placeActivitiesOperation:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activitiesResourceOperation:place.activityRef
                                 withOptions:options
                                  onComplete:complete
                                     onError:error];
}

- (void) placeActivities:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self placeActivitiesOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (void) deletePlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self deletePlaceOperationWithPlace:place
                                                                 onComplete:completeBlock
                                                                    onError:errorBlock];
    [operation start];
}

- (void) deleteAvatarForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self deleteAvatarOperationForPlace:place
                                                                 onComplete:completeBlock
                                                                    onError:errorBlock];
    [operation start];
}

- (void) announcementsForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self announcementsOperationForPlace:place
                                                                     options:options
                                                                  onComplete:completeBlock
                                                                     onError:errorBlock];
    [operation start];
}

- (void) avatarForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(void (^)(UIImage *avatarImage))completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self avatarOperationForPlace:place
                           options:options
                        onComplete:completeBlock
                           onError:errorBlock] start];
}

- (void) tasksForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self tasksOperationForPlace:place
                                                             options:options
                                                          onComplete:completeBlock
                                                             onError:errorBlock];
    [operation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deletePlaceOperationWithPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[place.selfRef path], nil];
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self emptyOperationWithRequest:request
                                                                                    onComplete:completeBlock
                                                                                       onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deleteAvatarOperationForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[place.avatarRef path], nil];
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self emptyOperationWithRequest:request
                                                                                    onComplete:completeBlock
                                                                                       onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) announcementsOperationForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self contentsResourceOperation:place.announcementsRef
                               withOptions:options
                                onComplete:completeBlock
                                   onError:errorBlock];
}

- (AFImageRequestOperation<JiveRetryingOperation> *) avatarOperationForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(JiveImageCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self imageOperationForPath:[place.avatarRef path]
                               options:options
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) tasksOperationForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(JiveErrorBlock)errorBlock {
    return [self contentsResourceOperation:place.tasksRef
                               withOptions:options
                                onComplete:completeBlock
                                   onError:errorBlock];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) placeFollowingInOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self streamsResourceOperation:place.followingInRef
                              withOptions:options
                               onComplete:complete
                                  onError:error];
}

- (void) placeFollowingIn:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self placeFollowingInOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)updateFollowingInOperation:(NSArray *)followingInStreams forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self followingInRequestWithStreams:followingInStreams options:options template:[place.followingInRef path], nil];
    
    return [self listOperationForClass:[JiveStream class] request:request onComplete:complete onError:error];
}

- (void)updateFollowingIn:(NSArray *)followingInStreams forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self updateFollowingInOperation:followingInStreams forPlace:place withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) updatePlaceOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:place
                                                     options:options
                                                 andTemplate:[place.selfRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.PUT];
    return [self entityOperationForClass:[JivePlace class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updatePlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    [[self updatePlaceOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) invitesOperation:(JivePlace *)place withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[place.invitesRef path], nil];
    
    return [self listOperationForClass:[JiveInvite class]
                               request:request
                            onComplete:complete
                               onError:error];
}

- (void) invites:(JivePlace *)place withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self invitesOperation:place withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createTaskOperation:(JiveTask *)task forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:task
                                                     options:options
                                                 andTemplate:[place.tasksRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    return [self entityOperationForClass:[JiveTask class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createTask:(JiveTask *)task forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error {
    [[self createTaskOperation:task forPlace:place withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createPlaceOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:place
                                                     options:options
                                                 andTemplate:[self appendPathToBaseURI:JiveRequestPathComponents.places], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
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
    AFJSONRequestOperation *operation = [self deleteMemberOperationWithMember:member
                                                                   onComplete:completeBlock
                                                                      onError:errorBlock];
    [operation start];
}

- (void) memberWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self memberOperationWithMember:member
                                                                options:options
                                                             onComplete:completeBlock
                                                                onError:errorBlock];
    [operation start];
}

- (void) membersForGroup:(JivePlace *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self membersOperationForGroup:group
                                                               options:options
                                                            onComplete:completeBlock
                                                               onError:errorBlock];
    [operation start];
}

- (void) membersForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock {
    AFJSONRequestOperation *operation = [self membersOperationForPerson:person
                                                                options:options
                                                             onComplete:completeBlock
                                                                onError:errorBlock];
    return [operation start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deleteMemberOperationWithMember:(JiveMember *)member onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[member.selfRef path], nil];
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self emptyOperationWithRequest:request
                                                                                    onComplete:completeBlock
                                                                                       onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)memberOperationWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[member.selfRef path], nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self entityOperationForClass:[JiveMember class]
                                                                                     request:request
                                                                                  onComplete:completeBlock
                                                                                     onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) membersOperationForGroup:(JivePlace *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[group.membersRef path], nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self listOperationForClass:[JiveMember class]
                                                                                   request:request
                                                                                onComplete:completeBlock
                                                                                   onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) membersOperationForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[person.membersRef path], nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self listOperationForClass:[JiveMember class]
                                                                                   request:request
                                                                                onComplete:completeBlock
                                                                                   onError:errorBlock];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) updateMemberOperation:(JiveMember *)member withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:member
                                                     options:options
                                                 andTemplate:[member.selfRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.PUT];
    return [self entityOperationForClass:[JiveMember class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updateMember:(JiveMember *)member withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *))complete onError:(JiveErrorBlock)error {
    [[self updateMemberOperation:member withOptions:options onComplete:complete onError:error] start];
}

#pragma mark - Streams

- (AFJSONRequestOperation<JiveRetryingOperation> *) streamOperation:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[stream.selfRef path], nil];
    
    return [self entityOperationForClass:[JiveStream class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) stream:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    [[self streamOperation:stream withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) streamActivitiesOperation:(JiveStream *)stream withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activitiesResourceOperation:stream.activityRef
                                 withOptions:options
                                  onComplete:complete
                                     onError:error];
}

- (void) streamActivities:(JiveStream *)stream withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self streamActivitiesOperation:stream withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) streamConnectionsActivitiesOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    return [self activityListOperation:[@"streams/connections" stringByAppendingPathComponent:JiveRequestPathComponents.activities]
                           withOptions:options
                            onComplete:complete
                               onError:error];
}

- (void) streamConnectionsActivities:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self streamConnectionsActivitiesOperation:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deleteStreamOperation:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[stream.selfRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deleteStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteStreamOperation:stream onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) streamAssociationsOperation:(JiveStream *)stream withOptions:(JiveAssociationsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSURLRequest *request = [self credentialedRequestWithOptions:options
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

- (AFJSONRequestOperation<JiveRetryingOperation> *) updateStreamOperation:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:stream
                                                     options:options
                                                 andTemplate:[stream.selfRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.PUT];
    return [self entityOperationForClass:[JiveStream class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) updateStream:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    [[self updateStreamOperation:stream withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createStreamOperation:(JiveStream *)stream forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self requestWithJSONBody:stream
                                                     options:options
                                                 andTemplate:[person.streamsRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    return [self entityOperationForClass:[JiveStream class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createStream:(JiveStream *)stream forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error {
    [[self createStreamOperation:stream forPerson:person withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deleteAssociationOperation:(JiveTypedObject *)association fromStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:@"%@/%@/%@", [stream.associationsRef path], association.type, [association.selfRef lastPathComponent], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deleteAssociation:(JiveTypedObject *)association fromStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteAssociationOperation:association fromStream:stream onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createAssociationsOperation:(JiveAssociationTargetList *)targets forStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[stream.associationsRef path], nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:[targets toJSONArray] options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) createAssociations:(JiveAssociationTargetList *)targets forStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self createAssociationsOperation:targets forStream:stream onComplete:complete onError:error] start];
}

#pragma mark - Invites

- (AFJSONRequestOperation<JiveRetryingOperation> *) inviteOperation:(JiveInvite *)invite withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[invite.selfRef path], nil];
    
    return [self entityOperationForClass:[JiveInvite class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) invite:(JiveInvite *)invite withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error {
    [[self inviteOperation:invite withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deleteInviteOperation:(JiveInvite *)invite onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil andTemplate:[invite.selfRef path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request onComplete:complete onError:error];
}

- (void) deleteInvite:(JiveInvite *)invite onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteInviteOperation:invite onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) updateInviteOperation:(JiveInvite *)invite withState:(enum JiveInviteState)state andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[invite.selfRef path], nil];
    NSDictionary *JSON = @{@"id" : invite.jiveId, @"state" : [JiveInvite jsonForState:state]};
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.PUT];
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

- (AFJSONRequestOperation<JiveRetryingOperation> *) createInviteToOperation:(JivePlace *)place withMessage:(NSString *)message targets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:[place.invitesRef path], nil];
    NSDictionary *JSON = @{@"body" : message, @"invitees" : [targets toJSONArray:NO]};
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
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

- (AFJSONRequestOperation<JiveRetryingOperation> *)imagesOperationFromURL:(NSURL *)imagesURL onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:imagesURL];
    
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:imagesURL];
    
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self listOperationForClass:[JiveImage class]
                                                                                   request:mutableURLRequest
                                                                                onComplete:complete
                                                                                   onError:error];
    return operation;
}

- (void)imagesFromURL:(NSURL *)imagesURL onComplete:(void (^)(NSArray *images))completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self imagesOperationFromURL:imagesURL onComplete:completeBlock onError:errorBlock] start];
}

- (AFHTTPRequestOperation<JiveRetryingOperation> *) uploadImageOperation:(UIImage *) image onComplete:(void (^)(JiveImage*))complete onError:(JiveErrorBlock) errorBlock {
    return [self uploadJPEGImageOperation:image onComplete:complete onError:errorBlock];
}

- (AFHTTPRequestOperation<JiveRetryingOperation> *)uploadJPEGImageOperation:(UIImage *)image onComplete:(void (^)(JiveImage*))complete onError:(JiveErrorBlock) errorBlock {
    NSString *mimeType = @"image/jpeg";
    NSString *fileName = @"image.jpeg";
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    return [self uploadImageDataOperation:imageData mimeType:mimeType fileName:fileName onComplete:complete onError:errorBlock];
}

- (AFHTTPRequestOperation<JiveRetryingOperation> *)uploadPNGImageOperation:(UIImage *)image onComplete:(void (^)(JiveImage*))complete onError:(JiveErrorBlock) errorBlock {
    NSString *mimeType = @"image/png";
    NSString *fileName = @"image.png";
    NSData *imageData = UIImagePNGRepresentation(image);
    return [self uploadImageDataOperation:imageData mimeType:mimeType fileName:fileName onComplete:complete onError:errorBlock];
}

- (AFHTTPRequestOperation<JiveRetryingOperation> *)uploadImageDataOperation:(NSData *)imageData mimeType:(NSString *)mimeType fileName:(NSString *)fileName onComplete:(void (^)(JiveImage*))complete onError:(JiveErrorBlock) errorBlock {
    AFHTTPClient *HTTPClient = [[AFHTTPClient alloc] initWithBaseURL:self.jiveInstanceURL];
    NSMutableURLRequest *request = [HTTPClient multipartFormRequestWithMethod:JiveHTTPMethodTypes.POST
                                                                         path:[self appendPathToBaseURI:@"images"]
                                                                   parameters:nil
                                                    constructingBodyWithBlock:(^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:mimeType];
    })];
    
    if (request) {
        [self maybeApplyCredentialsToMutableURLRequest:request
                                                forURL:self.jiveInstanceURL];
        
        AFHTTPRequestOperation<JiveRetryingOperation> *uploadImageOperation = [[JiveRetryingHTTPRequestOperation alloc] initWithRequest:request];
        [self setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:uploadImageOperation];
        
        [uploadImageOperation setCompletionBlockWithSuccess:(^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            JiveImage *jiveImage = [self parseObjectOfClass:[JiveImage class] fromJSON:json];
            complete(jiveImage);
        })
                                                    failure:(^(AFHTTPRequestOperation *operation, NSError *err) {
            if(errorBlock) {
                errorBlock(err);
            }
        })];
        
        return uploadImageOperation;
    } else {
        return nil;
    }
}

- (AFImageRequestOperation<JiveRetryingOperation> *)imageRequestOperationWithMutableURLRequest:(NSMutableURLRequest *)imageMutableURLRequest onComplete:(void (^)(UIImage *))complete onError:(JiveErrorBlock)errorBlock {
    [self maybeApplyCredentialsToMutableURLRequest:imageMutableURLRequest
                                            forURL:[imageMutableURLRequest URL]];
    JiveRetryingImageRequestOperation *retryingImageRequestOperation = [[JiveRetryingImageRequestOperation alloc] initWithRequest:imageMutableURLRequest];
    [retryingImageRequestOperation setCompletionBlockWithSuccess:(^(AFHTTPRequestOperation *operation, UIImage *responseImage) {
        if (complete) {
            complete(responseImage);
        }
    })
                                                         failure:(^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    })];
    [self setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:retryingImageRequestOperation];
    return retryingImageRequestOperation;
}

- (void) uploadImage:(UIImage*) image onComplete:(void (^)(JiveImage*))complete onError:(JiveErrorBlock) errorBlock {
    [[self uploadImageOperation:image onComplete:complete onError:errorBlock] start];
}

- (void)uploadJPEGImage:(UIImage *)image onComplete:(void (^)(JiveImage *))complete onError:(JiveErrorBlock) errorBlock {
    [[self uploadJPEGImageOperation:image onComplete:complete onError:errorBlock] start];
}

- (void)uploadPNGImage:(UIImage *)image onComplete:(void (^)(JiveImage *))complete onError:(JiveErrorBlock) errorBlock {
    [[self uploadPNGImageOperation:image onComplete:complete onError:errorBlock] start];
}

#pragma mark - Outcomes
- (AFJSONRequestOperation<JiveRetryingOperation> *) outcomesListOperation:(JiveContent *)content withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSString *path =[content.selfRef.path stringByAppendingPathComponent:JiveRequestPathComponents.outcomes];
    NSURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:path, nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self listOperationForClass:[JiveOutcome class]
                                                                                   request:request
                                                                                onComplete:complete
                                                                                   onError:error];
    return operation;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) outcomesOperation:(JiveContent *)content withOptions:(JiveOutcomeRequestOptions *)options onComplete:(void (^)(NSArray *outcomes))complete onError:(JiveErrorBlock) error {
    return [self outcomesListOperation:content
                           withOptions:options
                            onComplete:complete
                               onError:error];
}

- (void) outcomes:(JiveContent *)content withOptions:(JiveOutcomeRequestOptions *)options onComplete:(void (^)(NSArray *outcomes))complete onError:(JiveErrorBlock) error {
    [[self outcomesOperation:content withOptions:options onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) deleteOutcomeOperation:(JiveOutcome *)outcome onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    NSString *path = [JiveRequestPathComponents.outcomes stringByAppendingPathComponent:outcome.jiveId];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:[self appendPathToBaseURI:path],
                                    nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.DELETE];
    return [self emptyOperationWithRequest:request
                                onComplete:complete
                                   onError:error];
}

- (void) deleteOutcome:(JiveOutcome *)outcome onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error {
    [[self deleteOutcomeOperation:outcome onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) createOutcomeOperation:(JiveOutcome *)outcome forContent:(JiveContent *)content onComplete:(void (^)(JiveOutcome *))complete onError:(JiveErrorBlock)error {
    NSString *path = [content.selfRef.path stringByAppendingPathComponent:JiveRequestPathComponents.outcomes];
    NSMutableURLRequest *request = [self requestWithJSONBody:outcome
                                                     options:nil
                                                 andTemplate:path, nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    return [self entityOperationForClass:[JiveOutcome class]
                                 request:request
                              onComplete:complete
                                 onError:error];
}

- (void) createOutcome:(JiveOutcome *)outcome forContent:(JiveContent *)content onComplete:(void (^)(JiveOutcome *))complete onError:(JiveErrorBlock)error {
    [[self createOutcomeOperation:outcome forContent:content onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) outcomeRootContentOperation:(JiveOutcome *)outcome onComplete:(JiveContentCompleteBlock)complete onError:(JiveErrorBlock)error {
    NSURL * parentURL = [NSURL URLWithString:outcome.parent];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:parentURL];
    [self maybeApplyCredentialsToMutableURLRequest:mutableURLRequest
                                            forURL:parentURL];
    
    return  [self entityOperationForClass:[JiveContent class]
                                  request:mutableURLRequest
                               onComplete:complete
                                  onError:error];
}

- (void) outcome:(JiveOutcome *) outcome rootContentWithCompleteBlock:(void(^)(JiveContent *rootContent))completeBlock errorBlock:(JiveErrorBlock)errorBlock {
    [[self outcomeRootContentOperation:outcome onComplete:completeBlock onError:errorBlock] start];
}

#pragma mark - Properties

- (AFJSONRequestOperation<JiveRetryingOperation> *) propertyWithNameOperation:(NSString *)propertyName onComplete:(void (^)(JiveProperty *))complete onError:(JiveErrorBlock)error {
    NSString *path = [JiveRequestPathComponents.metadataProperties stringByAppendingPathComponent:propertyName];
    NSURLRequest *request = [self credentialedRequestWithOptions:nil
                                                     andTemplate:[self appendPathToBaseURI:path],
                             nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self entityOperationForClass:[JiveProperty class]
                                                                                     request:request
                                                                                  onComplete:complete
                                                                                     onError:error];
    
    return operation;
}

- (void) propertyWithName:(NSString *)propertyName onComplete:(void (^)(JiveProperty *))complete onError:(JiveErrorBlock)error {
    [[self propertyWithNameOperation:propertyName onComplete:complete onError:error] start];
}

# pragma mark - Public Properties (no authentication required)

- (void) publicPropertyWithName:(NSString *)propertyName onComplete:(void (^)(JiveProperty *))complete onError:(JiveErrorBlock)error {
    [[self publicPropertyWithNameOperation:propertyName onComplete:complete onError:error] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) publicPropertyWithNameOperation:(NSString *)propertyName onComplete:(void (^)(JiveProperty *))complete onError:(JiveErrorBlock)error {
    
    void (^processPropsBlock)(NSArray* properties) = ^(NSArray* properties) {
        NSArray* relevantProps = [properties filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", propertyName]];
        
        NSAssert([relevantProps count] < 2, @"Expected one or zero properties for %@, but we got %i", propertyName, [relevantProps count]);
        
        if ([relevantProps count] == 1) {
            complete([relevantProps objectAtIndex:0]);
        } else {
            complete(nil);
        }
    };
    
    return [self publicPropertiesListOperationWithOnComplete:processPropsBlock onError:error];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) publicPropertiesListOperationWithOnComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    NSString *path = [JiveRequestPathComponents.metadataProperties stringByAppendingPathComponent:@"public"];
    NSURL* requestURL = [NSURL URLWithString:[self appendPathToBaseURI:path]
                               relativeToURL:self.jiveInstanceURL];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setHTTPShouldHandleCookies:NO];
    
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self bareListOperationForClass:[JiveProperty class]
                                                                                       request:request
                                                                                    onComplete:complete
                                                                                       onError:error];
    
    // This should be publicly accessible without authentication, if the property is available on the instance.
    // In the event of an error, this should not attempt an auth & retry, just back off.
    operation.retrier = nil;
    
    return operation;
}

- (void) publicPropertiesListWithOnComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error {
    [[self publicPropertiesListOperationWithOnComplete:complete onError:error] start];
}

#pragma mark - Add-On Properties
- (AFJSONRequestOperation<JiveRetryingOperation>*)testBooleanAddOnPropertyOperationForName:(NSString*)propertyName forAddOnUUID:(NSString*)uuid onComplete:(void (^)(BOOL))complete onError:(JiveErrorBlock)error {
    
    NSURLRequest *request = [self credentialedRequestWithOptions:nil
                                                     andTemplate:@"/api/addons/%@/%@", uuid, propertyName, nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self operationWithRequest:request onJSON:^(id JSON) {
        NSNumber *statusValue = (NSNumber*)[JSON objectForKey:@"status"];
        complete([statusValue intValue] == 200);
    } onError:error];
    
    return operation;
    
}

- (void)testBooleanAddOnPropertyForName:(NSString*)propertyName forAddOnUUID:(NSString*)uuid onComplete:(void (^)(BOOL))complete onError:(JiveErrorBlock)error {
    
    [[self testBooleanAddOnPropertyOperationForName:propertyName forAddOnUUID:uuid onComplete:complete onError:error] start];
}



#pragma mark - Objects

- (AFJSONRequestOperation<JiveRetryingOperation> *) objectsOperationOnComplete:(void (^)(NSDictionary *))complete onError:(JiveErrorBlock)error {
    NSString *path = [JiveRequestPathComponents.metadata stringByAppendingPathComponent:@"objects"];
    NSURLRequest *request = [self credentialedRequestWithOptions:nil
                                                     andTemplate:@"%@/", [self appendPathToBaseURI:path], nil];
    AFJSONRequestOperation<JiveRetryingOperation> *operation = [self operationWithRequest:request
                                                                                   onJSON:complete
                                                                                  onError:error];
    
    return operation;
}

- (void) objectsOnComplete:(void (^)(NSDictionary *))complete onError:(JiveErrorBlock)error {
    [[self objectsOperationOnComplete:complete onError:error] start];
}

#pragma mark - Terms and Conditions

- (void) termsAndConditions:(JiveTermsAndConditionsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self termsAndConditionsOperation:completeBlock onError:errorBlock] start];
}

- (void) acceptTermsAndConditions:(JiveCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self acceptTermsAndConditionsOperation:completeBlock onError:errorBlock] start];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) termsAndConditionsOperation:(JiveTermsAndConditionsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSString *path = [[JiveRequestPathComponents.people stringByAppendingPathComponent:JiveRequestPathComponents.me]
                      stringByAppendingPathComponent:@"termsAndConditions"];
    NSURLRequest *request = [self credentialedRequestWithOptions:nil
                                                     andTemplate:[self appendPathToBaseURI:path], nil];
    
    return [self entityOperationForClass:[JiveTermsAndConditions class]
                                 request:request
                              onComplete:completeBlock
                                 onError:^(NSError *error) {
                                     if (error.code == 3) {
                                         if (completeBlock) {
                                             completeBlock([JiveTermsAndConditions new]);
                                         }
                                     } else if (errorBlock) {
                                         errorBlock(error);
                                     }
                                 }];
}

- (AFJSONRequestOperation<JiveRetryingOperation> *) acceptTermsAndConditionsOperation:(JiveCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    NSString *path = [[JiveRequestPathComponents.people stringByAppendingPathComponent:JiveRequestPathComponents.me]
                      stringByAppendingPathComponent:@"acceptTermsAndConditions"];
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:nil
                                                            andTemplate:[self appendPathToBaseURI:path], nil];
    
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    return [self emptyOperationWithRequest:request onComplete:completeBlock onError:errorBlock];
}

#pragma mark - private API

- (NSMutableURLRequest *)followingInRequestWithStreams:(NSArray *)streams options:(NSObject<JiveRequestOptions>*)options template:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION {
    NSString *targetURIKeyPath = [NSString stringWithFormat:@"%@.%@.%@.%@", NSStringFromSelector(@selector(resources)), JiveResourceAttributes.selfKey, NSStringFromSelector(@selector(ref)), NSStringFromSelector(@selector(absoluteString))];
    NSArray *targetURIs = [streams count] ? [streams valueForKeyPath:targetURIKeyPath] : [NSArray array];
    
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options andTemplate:template, nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:targetURIs options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:JiveHTTPMethodTypes.POST];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return request;
}

- (NSMutableURLRequest *) credentialedRequestWithOptions:(NSObject<JiveRequestOptions>*)options template:(NSString*)template andArguments:(va_list)args {
    if (!template || !self.jiveInstanceURL)
        return nil;
    
    NSMutableString* requestString = [[NSMutableString alloc] initWithFormat:template arguments:args];
    NSString *queryString = [options toQueryString];
    
    if (queryString) {
        [requestString appendFormat:@"?%@", queryString];
    }
    
    NSURL* requestURL = [NSURL URLWithString:requestString
                               relativeToURL:self.jiveInstanceURL];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    [self maybeApplyCredentialsToMutableURLRequest:request
                                            forURL:requestURL];
    
    return request;
}

- (NSMutableURLRequest *) credentialedRequestWithOptions:(NSObject<JiveRequestOptions>*)options andTemplate:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, template);
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options template:template andArguments:args];
    va_end(args);
    
    return request;
}

- (NSMutableURLRequest *) requestWithJSONBody:(JiveObject *)bodySource options:(NSObject<JiveRequestOptions>*)options andTemplate:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, template);
    NSMutableURLRequest *request = [self credentialedRequestWithOptions:options template:template andArguments:args];
    va_end(args);
    NSDictionary *JSON = bodySource.toJSONDictionary;
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    return request;
}

- (void) maybeApplyCredentialsToMutableURLRequest:(NSMutableURLRequest *)mutableURLRequest
                                           forURL:(NSURL *)URL {
    __typeof__(self.delegate) __strong strongDelegate = self.delegate;
    if(strongDelegate && [strongDelegate respondsToSelector:@selector(credentialsForJiveInstance:)]) {
        id<JiveCredentials> credentials = [strongDelegate credentialsForJiveInstance:URL];
        [credentials applyToRequest:mutableURLRequest];
    }
    if(strongDelegate && [strongDelegate respondsToSelector:@selector(mobileAnalyticsHeaderForJiveInstance:)]) {
        JiveMobileAnalyticsHeader *mobileAnalyticsHeader = [strongDelegate mobileAnalyticsHeaderForJiveInstance:URL];
        [mobileAnalyticsHeader applyToRequest:mutableURLRequest];
    }
    [mutableURLRequest addValue:@"true" forHTTPHeaderField:@"X-JIVE-TC-SUPPORT"];
}

- (JiveRetryingJAPIRequestOperation *)operationWithRequest:(NSURLRequest *)request onJSON:(void(^)(id))JSONBlock onError:(JiveErrorBlock)errorBlock {
    if (request) {
        [self maybeLogMaybeBadRequest:request];
        JiveRetryingJAPIRequestOperation *operation = [JiveRetryingJAPIRequestOperation JSONRequestOperationWithRequest:request
                                                                                                                success:(^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, id JSON) {
            if (JSONBlock) {
                JSONBlock(JSON);
            }
        })
                                                                                                                failure:(^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, NSError *err, id JSON) {
            if (errorBlock) {
                NSString *termsAndConditionsLink = response.allHeaderFields[@"X-JIVE-TC"];
                if (termsAndConditionsLink) {
                    errorBlock([NSError jive_errorRequiresTermsAndConditionsAcceptance:termsAndConditionsLink]);
                } else {
                    errorBlock([NSError jive_errorWithUnderlyingError:err
                                                                 JSON:JSON]);
                }
            }
        })];
        
        [self setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:operation];
        
        return operation;
    } else {
        return nil;
    }
}

- (JiveRetryingJAPIRequestOperation *)operationWithRequest:(NSURLRequest *)request onComplete:(void(^)(id))completeBlock onError:(JiveErrorBlock)errorBlock responseHandler:(id(^)(id JSON)) handler {
    __typeof__(completeBlock) heapCompleteBlock = [completeBlock copy];
    __typeof__(errorBlock) heapErrorBlock = [errorBlock copy];
    return [self operationWithRequest:request
                               onJSON:(^(id JSON) {
        if (heapCompleteBlock) {
            id entity = handler(JSON);
            if (entity) {
                if (entity == [NSNull null]) {
                    heapCompleteBlock(nil);
                } else {
                    heapCompleteBlock(entity);
                }
            } else {
                heapErrorBlock([NSError jive_errorWithInvalidJSON:JSON]);
            }
        }
    })
                              onError:heapErrorBlock];
}

- (JAPIRequestOperation<JiveRetryingOperation> *)dateLimitedListOperationForClass:(Class)clazz
                                                                          request:(NSURLRequest *)request
                                                                       onComplete:(JiveInboxObjectsCompleteBlock)completeBlock
                                                                          onError:(JiveErrorBlock)errorBlock {
    
    if (request) {
        [self maybeLogMaybeBadRequest:request];
        JiveRetryingJAPIRequestOperation *operation = [JiveRetryingJAPIRequestOperation JSONRequestOperationWithRequest:request
                                                                                                                success:(^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, id JSON) {
            if (completeBlock) {
                id entity = [self parseObjectsOfClass:clazz FromJSONList:JSON[@"list"]];
                
                // This is nil for non-inbox requests.
                NSNumber *unreadCount = JSON[@"unread"];
                
                NSDictionary *links = JSON[@"links"];
                NSURL *nextURL = [NSURL URLWithString:links[@"next"]];
                NSURL *previousURL = [NSURL URLWithString:links[@"previous"]];
                
                NSDate *earliestDate = [nextURL jive_dateFromValueOfParameterWithName:@"before"];
                NSDate *latestDate = [previousURL jive_dateFromValueOfParameterWithName:@"after"];
                
                completeBlock(entity, earliestDate, latestDate, unreadCount);
            }
        })
                                                                                                                failure:(^(NSURLRequest *operationRequest, NSHTTPURLResponse *response, NSError *err, id JSON) {
            if (errorBlock) {
                errorBlock([NSError jive_errorWithUnderlyingError:err
                                                             JSON:JSON]);
            }
        })];
        [self setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:operation];
        
        return operation;
    } else {
        return nil;
    }
}

- (JAPIRequestOperation<JiveRetryingOperation> *)listOperationForClass:(Class) clazz request:(NSURLRequest *)request onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    JAPIRequestOperation<JiveRetryingOperation> *operation = [self operationWithRequest:request
                                                                             onComplete:completeBlock
                                                                                onError:errorBlock
                                                                        responseHandler:(^id(id JSON) {
        return [self parseObjectsOfClass:clazz FromJSONList:JSON[@"list"]];
    })];
    return operation;
}

- (JAPIRequestOperation<JiveRetryingOperation> *)bareListOperationForClass:(Class) clazz request:(NSURLRequest *)request onComplete:(void (^)(NSArray *))completeBlock onError:(JiveErrorBlock)errorBlock {
    JAPIRequestOperation<JiveRetryingOperation> *operation = [self operationWithRequest:request
                                                                             onComplete:completeBlock
                                                                                onError:errorBlock
                                                                        responseHandler:(^id(id JSON) {
        return [clazz instancesFromJSONList:JSON withJive:self];
    })];
    return operation;
}

- (JiveRetryingJAPIRequestOperation *)entityOperationForClass:(Class) clazz request:(NSURLRequest *)request onComplete:(void (^)(id))completeBlock onError:(JiveErrorBlock)errorBlock {
    JiveRetryingJAPIRequestOperation *operation = [self operationWithRequest:request
                                                                  onComplete:completeBlock
                                                                     onError:errorBlock
                                                             responseHandler:(^id(id JSON) {
        return [self parseObjectOfClass:clazz fromJSON:JSON];
    })];
    return operation;
}

- (JAPIRequestOperation<JiveRetryingOperation> *)updateJiveTypedObject:(JiveTypedObject *)target
                                                           withRequest:(NSURLRequest *)request
                                                            onComplete:(void (^)(id))completeBlock
                                                               onError:(JiveErrorBlock)errorBlock
{
    return [self operationWithRequest:request
                           onComplete:completeBlock
                              onError:errorBlock
                      responseHandler:^id(id JSON) {
                          if ([target.type isEqualToString:JSON[JiveTypedObjectAttributes.type]]) {
                              self.badInstanceURL = nil;
                              [target deserialize:JSON fromInstance:self];
                              return target;
                          } else {
                              return nil;
                          }
                      }];
}

- (JAPIRequestOperation<JiveRetryingOperation> *)emptyOperationWithRequest:(NSURLRequest*) request onComplete:(void(^)(void)) complete onError:(JiveErrorBlock) error {
    void (^nilObjectComplete)(id);
    if (complete) {
        void (^heapComplete)(void) = [complete copy];
        // iOS7: this crashes in weird ways if we don't copy the block we assign to nilObjectComplete here.
        // it is supposed to be safe to pass a block down into another block, but maybe not.
        nilObjectComplete = [^(id nilObject) {
            heapComplete();
        } copy];
    } else {
        nilObjectComplete = NULL;
    }
    JAPIRequestOperation<JiveRetryingOperation> *operation = [self operationWithRequest:request
                                                                             onComplete:nilObjectComplete
                                                                                onError:error
                                                                        responseHandler:(^id(id JSON) {
        return [NSNull null];
    })];
    return operation;
}

- (void)setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:(AFURLConnectionOperation<JiveRetryingOperation> *)retryingURLConnectionOperation {
    [retryingURLConnectionOperation setAuthenticationAgainstProtectionSpaceBlock:^BOOL(NSURLConnection *connection, NSURLProtectionSpace *protectionSpace) {
        // don't need to weakify self here because Jive.m retains no references to the created operations.
        // thus there are no cycles
        __typeof__(self.delegate) __strong strongDelegate = self.delegate;
        if (self.verboseAuthenticationLoggerBlock) {
            self.verboseAuthenticationLoggerBlock(@"canAuthenticateAgainstProtectionSpace",
                                                  self,
                                                  strongDelegate,
                                                  nil,
                                                  protectionSpace);
        }
        if ([strongDelegate respondsToSelector:@selector(receivedServerTrustAuthenticationChallenge:)]) {
            if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                if (self.verboseAuthenticationLoggerBlock) {
                    self.verboseAuthenticationLoggerBlock(@"received serverTrust protectionSpace. returning YES",
                                                          self,
                                                          strongDelegate,
                                                          nil,
                                                          protectionSpace);
                }
                return YES;
            } else {
                if (self.warnAuthenticationLoggerBlock) {
                    self.warnAuthenticationLoggerBlock(@"Received non-serverTrust authenticationMethod. returning NO",
                                                       self,
                                                       strongDelegate,
                                                       nil,
                                                       protectionSpace);
                }
                return NO;
            }
        } else {
            if (self.warnAuthenticationLoggerBlock) {
                self.warnAuthenticationLoggerBlock([NSString stringWithFormat:@"Delegate doesn't respond to %@, returning NO",
                                                    NSStringFromSelector(@selector(receivedServerTrustAuthenticationChallenge:))],
                                                   self,
                                                   strongDelegate,
                                                   nil,
                                                   protectionSpace);
            }
            return NO;
        }
    }];
    [retryingURLConnectionOperation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
        // don't need to weakify self here because Jive.m retains no references to the created operations.
        // thus there are no cycles
        __typeof__(self.delegate) __strong strongDelegate = self.delegate;
        if (self.verboseAuthenticationLoggerBlock) {
            self.verboseAuthenticationLoggerBlock(@"Received AuthenticationChallenge.",
                                                  self,
                                                  strongDelegate,
                                                  challenge,
                                                  nil);
        }
        
        if ([strongDelegate respondsToSelector:@selector(receivedServerTrustAuthenticationChallenge:)]) {
            if (self.verboseAuthenticationLoggerBlock) {
                self.verboseAuthenticationLoggerBlock(@"Sending AuthenticationChallenge. to delegate",
                                                      self,
                                                      strongDelegate,
                                                      challenge,
                                                      nil);
            }
            [strongDelegate receivedServerTrustAuthenticationChallenge:challenge];
        } else {
            if (self.warnAuthenticationLoggerBlock) {
                self.warnAuthenticationLoggerBlock([NSString stringWithFormat:@"Delegate doesn't respond to %@, continuing without credential",
                                                    NSStringFromSelector(@selector(receivedServerTrustAuthenticationChallenge:))],
                                                   self,
                                                   strongDelegate,
                                                   challenge,
                                                   nil);
            }
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }];
    retryingURLConnectionOperation.retrier = self.defaultOperationRetrier;
}

- (void)maybeLogMaybeBadRequest:(NSURLRequest *)maybeBadRequest {
    if (![maybeBadRequest URL]) {
        if (self.badRequestLoggerBlock) {
            // we dont just want to return nil here because it's too drastic of a change for clients.
            self.badRequestLoggerBlock(@"nil URL", self, maybeBadRequest);
        }
    }
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
