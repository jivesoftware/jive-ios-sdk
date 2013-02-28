//
//  JiveErrorTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/28/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveErrorTests.h"

@implementation JiveErrorTests

- (void)testNoJSON {
    NSError *nativeError = [[NSError alloc] initWithDomain:@"AFNetworkingErrorDomain"
                                                      code:404
                                                  userInfo:nil];
    JiveError *jiveError = [[JiveError alloc] initWithNSError:nativeError withJSON:nil];
    
    STAssertEqualObjects((NSError *)jiveError, nativeError, @"Native error not duplicated");
    STAssertNil(jiveError.localizedRecoverySuggestion, @"Missing message found");
    STAssertNil(jiveError.jiveStatus, @"Missing status found");
}

- (void)testBasicJSONError {
    NSString *message = @"'The specified name is too long. 18 is the max length permitted.'";
    NSNumber *status = [NSNumber numberWithInt:409];
    NSString *description = [NSString stringWithFormat:@"Expected status code in (200-299), got %@", status];
    NSDictionary *JSONError = @{@"error": @{@"message":message, @"status":status}};
    NSDictionary *userInfo = @{@"NSLocalizedRecoverySuggestion":[NSString stringWithFormat:@"{\"error\":{\"message\":%@,\"status\":%@}}", message, status],
                                @"NSLocalizedDescription":description};
    NSError *nativeError = [[NSError alloc] initWithDomain:@"AFNetworkingErrorDomain"
                                                      code:404
                                                  userInfo:userInfo];
    JiveError *jiveError = [[JiveError alloc] initWithNSError:nativeError withJSON:JSONError];
    
    STAssertEqualObjects(jiveError.domain, nativeError.domain, @"Native error not duplicated");
    STAssertEquals(jiveError.code, nativeError.code, @"Native error not duplicated");
    STAssertEqualObjects(jiveError.localizedDescription, nativeError.localizedDescription, @"Native error not duplicated");
    STAssertEqualObjects(jiveError.localizedFailureReason, nativeError.localizedFailureReason, @"Native error not duplicated");
    STAssertEqualObjects(jiveError.localizedRecoveryOptions, nativeError.localizedRecoveryOptions, @"Native error not duplicated");
    STAssertEqualObjects(jiveError.helpAnchor, nativeError.helpAnchor, @"Native error not duplicated");
    STAssertEqualObjects(jiveError.localizedRecoverySuggestion, message, @"Wrong message found");
    STAssertEqualObjects(jiveError.jiveStatus, status, @"Wrong status found");
}

@end
