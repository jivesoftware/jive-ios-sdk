//
//  JVLoginOAuthCredentials.m
//  jive-ios-auth
//
//  Created by Ben Oberkfell on 11/24/13.
//  Copyright (c) 2013 Jive Software, Inc. All rights reserved.
//

#import "JiveOAuthCredentials.h"

static NSString * const JiveOAuthCredentialsAccessTokenKey = @"accessToken";
static NSString * const JiveOAuthCredentialsRefreshTokenKey = @"refreshToken";
static NSString * const JiveOAuthCredentialsExpiryDateKey = @"expiryDate";

@implementation JiveOAuthCredentials

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
               expiryDate:(NSDate*)expiryDate {
    
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _refreshToken = refreshToken;
        _expiryDate = expiryDate;
    }
    return self;
}

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
           expiryInterval:(NSTimeInterval)expiryInterval {
    
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _refreshToken = refreshToken;
        _expiryDate = [[NSDate date] dateByAddingTimeInterval:expiryInterval];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _accessToken = [coder decodeObjectForKey:JiveOAuthCredentialsAccessTokenKey];
        _refreshToken = [coder decodeObjectForKey:JiveOAuthCredentialsRefreshTokenKey];
        _expiryDate = [coder decodeObjectForKey:JiveOAuthCredentialsExpiryDateKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.accessToken forKey:JiveOAuthCredentialsAccessTokenKey];
    [coder encodeObject:self.refreshToken forKey:JiveOAuthCredentialsRefreshTokenKey];
    [coder encodeObject:self.expiryDate forKey:JiveOAuthCredentialsExpiryDateKey];
}

#pragma mark - JiveCredentials

- (void)applyToRequest:(NSMutableURLRequest *)request {
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPShouldHandleCookies:NO];
}


@end
