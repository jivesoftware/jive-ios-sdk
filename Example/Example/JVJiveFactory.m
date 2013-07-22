//
//  JVJiveFactory.m
//  Example
//
//  Created by Orson Bushnell on 7/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JVJiveFactory.h"
#import <Jive/JiveHTTPBasicAuthCredentials.h>

@interface JVJiveFactory () <JiveAuthorizationDelegate>

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *password;
@property (nonatomic) Jive *jive;
@property (nonatomic) id<JiveCredentials> credentials;
@property (nonatomic) JiveMobileAnalyticsHeader *mobileAnalyticsHeader;

@end

static JVJiveFactory *instance;

@implementation JVJiveFactory

+ (void)load {
    instance = [JVJiveFactory new]; // Create the singleton - not thread safe or anything
}

+ (void)loginWithName:(NSString *)userName
             password:(NSString *)password
             complete:(JivePersonCompleteBlock)completeBlock
                error:(JiveErrorBlock)errorBlock {
    [instance loginWithName:userName
                   password:password
                   complete:completeBlock
                      error:errorBlock];
}

+ (Jive *)jiveInstance {
    return instance.jive;
}

- (void)handleLoginError:(NSError *)error withErrorBlock:(JiveErrorBlock)errorBlockCopy
{
    self.userName = nil;
    self.password = nil;
    self.jive = nil;
    if (errorBlockCopy) {
        errorBlockCopy(error);
    }
}

- (void)loginWithName:(NSString *)userName
             password:(NSString *)password
             complete:(JivePersonCompleteBlock)completeBlock
                error:(JiveErrorBlock)errorBlock {
    JiveErrorBlock errorBlockCopy = [errorBlock copy];
    
    self.userName = userName;
    self.password = password;
    self.jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://community.jivesoftware.com"]
                             authorizationDelegate:self];
    self.credentials = nil;
    [self.jive me:completeBlock
          onError:^(NSError *error) {
              [self handleLoginError:error withErrorBlock:errorBlockCopy];
          }];
}

#pragma mark - JiveAuthorizationDelegate methods

- (id<JiveCredentials>)credentialsForJiveInstance:(NSURL *)url {
    if (!self.credentials) {
        self.credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:self.userName
                                                                         password:self.password];
    }
    
    return self.credentials;
}

- (JiveMobileAnalyticsHeader *)mobileAnalyticsHeaderForJiveInstance:(NSURL *)url {
    if (!self.mobileAnalyticsHeader) {
        self.mobileAnalyticsHeader = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"Example Jive iOS SDK app" // Your custome app id
                                                                           appVersion:[NSString stringWithFormat:@"%1$@ (%2$@)", // The version information from your .plist
                                                                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                                                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]
                                                                       connectionType:@"wifi" // This should be the connection type your device is currently using.
                                                                       devicePlatform:[UIDevice currentDevice].model
                                                                        deviceVersion:[UIDevice currentDevice].systemVersion];
    }
    
    return self.mobileAnalyticsHeader;
}

@end
