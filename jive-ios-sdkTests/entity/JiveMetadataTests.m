//
//  JiveMetadataTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 8/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveMetadataTests.h"
#import "JiveMetadata_internal.h"
#import <OCMock/OCMock.h>
#import "Jive_internal.h"
#import "JiveRetryingJAPIRequestOperation.h"
#import "NSError+Jive.h"

@interface JiveTestOperation : AFJSONRequestOperation<JiveRetryingOperation>

@end

@implementation JiveMetadataTests

- (void)testNew {
    JiveMetadata *badInit = [JiveMetadata new];
    
    STAssertNil(badInit, @"Calling new on JiveMetadata should return nil.");
}

- (void)testHasVideo_noVideo {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    NSDictionary *objects = @{@"carousel" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/carousel",
                              @"contentVersion" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/contentVersion"
                              };
    __block void (^internalCallback)(NSDictionary *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STAssertTrue(false, @"There should be no errors");
    };
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] objectsOperationOnComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                    onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEquals(obj, (id)errorBlock, @"Wrong error block passed");
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject hasVideo:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback(objects);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testHasVideo_hasVideo {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    NSDictionary *objects = @{@"carousel" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/carousel",
                              @"video" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/video",
                              @"contentVersion" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/contentVersion"
                              };
    __block void (^internalCallback)(NSDictionary *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STAssertTrue(false, @"There should be no errors");
    };
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] objectsOperationOnComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                    onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEquals(obj, (id)errorBlock, @"Wrong error block passed");
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject hasVideo:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback(objects);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRTCEnabled_noRTC {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    __block void (^internalCallback)(JiveProperty *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STFail(@"There should be no errors");
    };
    OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
    
    [(JiveProperty *)[[mockProperty expect] andReturn:JivePropertyTypes.boolean] type];
    [(JiveProperty *)[[mockProperty expect] andReturn:@NO] value];
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, @"feature.rtc.enabled", @"Wrong property requested.");
        return obj != nil;
    }]
                                                                onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                   onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject realTimeChatEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRTCEnabled_withRTC {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    __block void (^internalCallback)(JiveProperty *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STFail(@"There should be no errors");
    };
    OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
    
    [(JiveProperty *)[[mockProperty expect] andReturn:JivePropertyTypes.boolean] type];
    [(JiveProperty *)[[mockProperty expect] andReturn:@YES] value];
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, @"feature.rtc.enabled", @"Wrong property requested.");
        return obj != nil;
    }]
                                                                onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                   onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject realTimeChatEnabled:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be YES");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRTCEnabled_invalidMetadataFlag {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    __block JiveErrorBlock internalErrorBlock;
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STFail(@"There should be no errors");
    };
    NSError *invalidPropertyError = [NSError jive_errorWithUnderlyingError:nil
                                                                      JSON:@{@"error":@{@"message":@"Invalid property name feature.ctr.enabled",
                                                                                        @"status":@404,
                                                                                        @"code":@"objectInvalidPropertyName"}}];
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, @"feature.rtc.enabled", @"Wrong property requested.");
        return obj != nil;
    }]
                                                                onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        return obj != nil;
    }]
                                                                   onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalErrorBlock = [obj copy];
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject realTimeChatEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRTCEnabled_invalidMetadataError {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    __block JiveErrorBlock internalErrorBlock;
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STFail(@"There should be no errors");
    };
    NSError *invalidPropertyError = [NSError jive_errorWithUnderlyingError:[NSError errorWithDomain:@"Invalid property name"
                                                                                               code:404
                                                                                           userInfo:@{NSLocalizedDescriptionKey: @"Invalid property name 404"}]];
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, @"feature.rtc.enabled", @"Wrong property requested.");
        return obj != nil;
    }]
                                                                onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        return obj != nil;
    }]
                                                                   onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalErrorBlock = [obj copy];
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject realTimeChatEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRTCEnabled_otherJSONError {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    __block JiveErrorBlock internalErrorBlock;
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    NSError *otherError = [NSError jive_errorWithUnderlyingError:nil
                                                            JSON:@{@"error":@{@"message":@"Test failure that is not a 404",
                                                                              @"status":@403,
                                                                              @"code":@"Not a 404"}}];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STAssertEqualObjects(error, otherError, @"Wrong error passed to the errorBlock");
    };
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, @"feature.rtc.enabled", @"Wrong property requested.");
        return obj != nil;
    }]
                                                                onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        return obj != nil;
    }]
                                                                   onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalErrorBlock = [obj copy];
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject realTimeChatEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRTCEnabled_otherError {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    __block JiveErrorBlock internalErrorBlock;
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    NSError *otherError = [NSError jive_errorWithUnderlyingError:[NSError errorWithDomain:@"Invalid request"
                                                                                     code:400
                                                                                 userInfo:@{NSLocalizedDescriptionKey: @"Invalid request 400"}]];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STAssertEqualObjects(error, otherError, @"Wrong error passed to the errorBlock");
    };
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, @"feature.rtc.enabled", @"Wrong property requested.");
        return obj != nil;
    }]
                                                                onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        return obj != nil;
    }]
                                                                   onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalErrorBlock = [obj copy];
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject realTimeChatEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

@end
