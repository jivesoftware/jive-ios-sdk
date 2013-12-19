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
@property (nonatomic, strong, readwrite) Jive *jive;
@property (nonatomic) id<JiveCredentials> credentials;
@property (nonatomic) JiveMobileAnalyticsHeader *mobileAnalyticsHeader;

@end

static JVJiveFactory *currentInstance;

@implementation JVJiveFactory

+(JVJiveFactory *)instance {
    return currentInstance;
}

+ (void)setInstance:(JVJiveFactory *)instance {
    currentInstance = instance;
}

- (id)initWithInstanceURL:(NSURL *)instanceURL
                 complete:(JivePlatformVersionBlock)completeBlock
                    error:(JiveErrorBlock)errorBlock {
    self = [super init];
    if (self) {
        self.jive = [[Jive alloc] initWithJiveInstance:instanceURL
                                 authorizationDelegate:self];
        [self.jive versionForInstance:instanceURL
                           onComplete:completeBlock
                              onError:errorBlock];
    }
    
    return self;
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

- (void)loginWithNewInstanceURL:(NSURL *)instanceURL me:(JivePerson *)me completeBlock:(JivePersonCompleteBlock)completeBlock
{
    // Make sure we have the correct me object.
    Jive *oldJive = self.jive;
    
    self.jive = [[Jive alloc] initWithJiveInstance:instanceURL
                             authorizationDelegate:self];
    [self.jive me:completeBlock
          onError:^(NSError *error) {
              // Fall back to what works.
              self.jive = oldJive;
              if (completeBlock) {
                  completeBlock(me);
              }
          }];
}

- (void)doubleCheckInstanceURLForMe:(JivePerson *)me
                         onComplete:(JivePersonCompleteBlock)completeBlock {
    [self.jive propertyWithName:JivePropertyNames.instanceURL
                     onComplete:^(JiveProperty *property) {
                         NSString *instanceString = property.valueAsString;
                         
                         // The SDK assumes the URL has a / at the end. So make sure it does.
                         if (![instanceString hasSuffix:@"/"]) {
                             instanceString = [instanceString stringByAppendingString:@"/"];
                         }
                         
                         NSURL *instanceURL = [NSURL URLWithString:instanceString];
                         
                         // Yes! We have a server url.
                         if ([instanceString isEqualToString:self.jive.jiveInstanceURL.absoluteString]) {
                             // Everything matches up.
                             if (completeBlock) {
                                 completeBlock(me);
                             }
                         } else {
                             [self loginWithNewInstanceURL:instanceURL me:me completeBlock:completeBlock];
                         }
                     } onError:^(NSError *error) {
                         // No! We are stuck with what works.
                         if (completeBlock) {
                             completeBlock(me);
                         }
                     }];
}

- (void)loginWithName:(NSString *)userName
             password:(NSString *)password
             complete:(JivePersonCompleteBlock)completeBlock
                error:(JiveErrorBlock)errorBlock {
    JiveErrorBlock errorBlockCopy = [errorBlock copy];
    
    self.userName = userName;
    self.password = password;
    self.credentials = nil;
    [self.jive me:^(JivePerson *me) {
        JivePlatformVersion *platformVersion = self.jive.platformVersion;
        
        // url check.
        if (platformVersion.instanceURL) {
            // It's all good.
            if (completeBlock) {
                completeBlock(me);
            }
        } else {
            // NO!!! We have to make sure we have the right URL.
            [self doubleCheckInstanceURLForMe:me onComplete:completeBlock];
        }
    }
          onError:^(NSError *error) {
              [self handleLoginError:error withErrorBlock:errorBlockCopy];
          }];
}

+ (void)loginWithName:(NSString *)userName
             password:(NSString *)password
             complete:(JivePersonCompleteBlock)completeBlock
                error:(JiveErrorBlock)errorBlock {
    [currentInstance loginWithName:userName password:password complete:completeBlock error:errorBlock];
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
