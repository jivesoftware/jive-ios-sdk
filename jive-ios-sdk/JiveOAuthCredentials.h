//
//  JVLoginOAuthCredentials.h
//  jive-ios-auth
//
//  Created by Ben Oberkfell on 11/24/13.
//  Copyright (c) 2013 Jive Software, Inc. All rights reserved.
//

#import "JiveCredentials.h"
#import <Foundation/Foundation.h>

@interface JiveOAuthCredentials : NSObject<JiveCredentials,NSCoding>

@property (nonatomic, readonly) NSString* accessToken;
@property (nonatomic, readonly) NSString* refreshToken;
@property (nonatomic, readonly) NSDate* expiryDate;

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
               expiryDate:(NSDate*)expiryDate;

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
           expiryInterval:(NSTimeInterval)expiryInterval;

@end
