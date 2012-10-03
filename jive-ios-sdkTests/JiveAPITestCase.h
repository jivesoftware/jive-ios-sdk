//
//  JiveAPITestCase.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>

#import "Jive.h"
#import "JiveCredentials.h"
#import "JAPIRequestOperation.h"
#import "MockJiveURLProtocol.h"

@interface JiveAPITestCase : SenTestCase

- (void)waitForTimeout:(NSTimeInterval)timeout;

- (id) mockJiveURLDelegate:(NSURL*) url returningContentsOfFile:(NSString*) path;
- (id) mockJiveAuthenticationDelegate:(NSString*) username password:(NSString*) password;
- (id) mockJiveAuthenticationDelegate;

@end
