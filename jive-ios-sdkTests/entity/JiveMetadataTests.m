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
#import "JivePlatformVersionTests.h"

@interface JiveMetadata (TestSupport)
- (AFJSONRequestOperation<JiveRetryingOperation> *)boolPropertyOperation:(NSString *)propertySpecifier
                                                              onComplete:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                 onError:(JiveErrorBlock)errorBlock;
@end

@interface JiveTestOperation : AFJSONRequestOperation<JiveRetryingOperation>

@end

@implementation JiveMetadataTests

- (void)testNew {
    JiveMetadata *badInit = [JiveMetadata new];
    
    STAssertNil(badInit, @"Calling new on JiveMetadata should return nil.");
}

#pragma mark - Video tests

- (void)testHasVideo_noVideo_withVideoModuleProperty {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    
    __block void (^internalCallback)(JiveProperty *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:7 minorVersion:0 maintenanceVersion:1]] platformVersion];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [@"feature.module.video.enabled" isEqual:obj];
    }] onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
     onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        return YES;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject hasVideo:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:^(NSError *error) {
        STFail(@"There should be no errors.");
    }];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        JiveProperty *property = [[JiveProperty alloc] init];
        [property setValue:JivePropertyTypes.boolean forKey:JivePropertyAttributes.type];
        [property setValue:@NO forKey:JivePropertyAttributes.value];

        internalCallback(property);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testHasVideo_hasVideo_withVideoModuleProperty {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];

    __block void (^internalCallback)(JiveProperty *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:7 minorVersion:0 maintenanceVersion:1]] platformVersion];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [@"feature.module.video.enabled" isEqual:obj];
    }] onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                   onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        return YES;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject hasVideo:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be NO");
    } onError:^(NSError *error) {
        STFail(@"There should be no errors.");
    }];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        JiveProperty *property = [[JiveProperty alloc] init];
        [property setValue:JivePropertyTypes.boolean forKey:JivePropertyAttributes.type];
        [property setValue:@YES forKey:JivePropertyAttributes.value];
        
        internalCallback(property);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
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
    [[[mockJive expect] andReturn:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:6 minorVersion:0 maintenanceVersion:1]] platformVersion];
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
    [[[mockJive expect] andReturn:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:7 minorVersion:0 maintenanceVersion:0]] platformVersion];
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

#pragma mark - RTC enabled tests

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

#pragma mark - Images enabled tests

- (void)testImagesEnabled_noImages {
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
        STAssertEqualObjects(obj, @"feature.images.enabled", @"Wrong property requested.");
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
    
    [testObject imagesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testImagesEnabled_withImages {
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
        STAssertEqualObjects(obj, @"feature.images.enabled", @"Wrong property requested.");
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
    
    [testObject imagesEnabled:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be YES");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testImagesEnabled_invalidMetadataFlag {
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
        STAssertEqualObjects(obj, @"feature.images.enabled", @"Wrong property requested.");
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
    
    [testObject imagesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testImagesEnabled_invalidMetadataError {
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
        STAssertEqualObjects(obj, @"feature.images.enabled", @"Wrong property requested.");
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
    
    [testObject imagesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testImagesEnabled_otherJSONError {
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
        STAssertEqualObjects(obj, @"feature.images.enabled", @"Wrong property requested.");
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
    
    [testObject imagesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testImagesEnabled_otherError {
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
        STAssertEqualObjects(obj, @"feature.images.enabled", @"Wrong property requested.");
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
    
    [testObject imagesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

#pragma mark - Status Updates enabled tests

- (void)testStatusUpdatesEnabled_noUpdates {
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
        STAssertEqualObjects(obj, @"jive.coreapi.enable.statusupdates", @"Wrong property requested.");
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
    
    [testObject statusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testStatusUpdatesEnabled_withUpdates {
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
        STAssertEqualObjects(obj, @"jive.coreapi.enable.statusupdates", @"Wrong property requested.");
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
    
    [testObject statusUpdatesEnabled:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be YES");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testStatusUpdatesEnabled_invalidMetadataFlag {
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
        STAssertEqualObjects(obj, @"jive.coreapi.enable.statusupdates", @"Wrong property requested.");
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
    
    [testObject statusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testStatusUpdatesEnabled_invalidMetadataError {
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
        STAssertEqualObjects(obj, @"jive.coreapi.enable.statusupdates", @"Wrong property requested.");
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
    
    [testObject statusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testStatusUpdatesEnabled_otherJSONError {
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
        STAssertEqualObjects(obj, @"jive.coreapi.enable.statusupdates", @"Wrong property requested.");
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
    
    [testObject statusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testStatusUpdatesEnabled_otherError {
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
        STAssertEqualObjects(obj, @"jive.coreapi.enable.statusupdates", @"Wrong property requested.");
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
    
    [testObject statusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

#pragma mark - Personal Status Updates enabled tests

- (void)testPersonalStatusUpdatesEnabled_noUpdates {
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
        STAssertEqualObjects(obj, @"feature.status_update.enabled", @"Wrong property requested.");
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
    
    [testObject personalStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPersonalStatusUpdatesEnabled_withUpdates {
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
        STAssertEqualObjects(obj, @"feature.status_update.enabled", @"Wrong property requested.");
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
    
    [testObject personalStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be YES");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPersonalStatusUpdatesEnabled_invalidMetadataFlag {
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
        STAssertEqualObjects(obj, @"feature.status_update.enabled", @"Wrong property requested.");
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
    
    [testObject personalStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPersonalStatusUpdatesEnabled_invalidMetadataError {
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
        STAssertEqualObjects(obj, @"feature.status_update.enabled", @"Wrong property requested.");
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
    
    [testObject personalStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPersonalStatusUpdatesEnabled_otherJSONError {
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
        STAssertEqualObjects(obj, @"feature.status_update.enabled", @"Wrong property requested.");
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
    
    [testObject personalStatusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPersonalStatusUpdatesEnabled_otherError {
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
        STAssertEqualObjects(obj, @"feature.status_update.enabled", @"Wrong property requested.");
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
    
    [testObject personalStatusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

#pragma mark - Place Status Updates enabled tests

- (void)testPlaceStatusUpdatesEnabled_noUpdates {
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
        STAssertEqualObjects(obj, @"feature.status_update_place.enabled", @"Wrong property requested.");
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
    
    [testObject placeStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPlaceStatusUpdatesEnabled_withUpdates {
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
        STAssertEqualObjects(obj, @"feature.status_update_place.enabled", @"Wrong property requested.");
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
    
    [testObject placeStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be YES");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPlaceStatusUpdatesEnabled_invalidMetadataFlag {
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
        STAssertEqualObjects(obj, @"feature.status_update_place.enabled", @"Wrong property requested.");
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
    
    [testObject placeStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPlaceStatusUpdatesEnabled_invalidMetadataError {
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
        STAssertEqualObjects(obj, @"feature.status_update_place.enabled", @"Wrong property requested.");
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
    
    [testObject placeStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPlaceStatusUpdatesEnabled_otherJSONError {
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
        STAssertEqualObjects(obj, @"feature.status_update_place.enabled", @"Wrong property requested.");
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
    
    [testObject placeStatusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testPlaceStatusUpdatesEnabled_otherError {
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
        STAssertEqualObjects(obj, @"feature.status_update_place.enabled", @"Wrong property requested.");
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
    
    [testObject placeStatusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

#pragma mark - Repost Status Updates enabled tests

- (void)testRepostStatusUpdatesEnabled_noUpdates {
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
        STAssertEqualObjects(obj, @"feature.status_update_repost.enabled", @"Wrong property requested.");
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
    
    [testObject repostStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRepostStatusUpdatesEnabled_withUpdates {
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
        STAssertEqualObjects(obj, @"feature.status_update_repost.enabled", @"Wrong property requested.");
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
    
    [testObject repostStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be YES");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRepostStatusUpdatesEnabled_invalidMetadataFlag {
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
        STAssertEqualObjects(obj, @"feature.status_update_repost.enabled", @"Wrong property requested.");
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
    
    [testObject repostStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRepostStatusUpdatesEnabled_invalidMetadataError {
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
        STAssertEqualObjects(obj, @"feature.status_update_repost.enabled", @"Wrong property requested.");
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
    
    [testObject repostStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRepostStatusUpdatesEnabled_otherJSONError {
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
        STAssertEqualObjects(obj, @"feature.status_update_repost.enabled", @"Wrong property requested.");
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
    
    [testObject repostStatusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testRepostStatusUpdatesEnabled_otherError {
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
        STAssertEqualObjects(obj, @"feature.status_update_repost.enabled", @"Wrong property requested.");
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
    
    [testObject repostStatusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

#pragma mark - Status Update max character tests

- (void)testStatusUpdateMaxCharacters {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    __block void (^internalCallback)(JiveProperty *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    NSNumber *testMaxCharacters = @200;
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STFail(@"There should be no errors");
    };
    OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
    
    [(JiveProperty *)[[mockProperty expect] andReturn:JivePropertyTypes.number] type];
    [(JiveProperty *)[[mockProperty expect] andReturn:testMaxCharacters] value];
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, @"feature.status_update.characters", @"Wrong property requested.");
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
    
    [testObject statusUpdateMaxCharacters:^(NSNumber *maxCharacters) {
        STAssertEqualObjects(maxCharacters, testMaxCharacters, @"Reported the wrong number of characters");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testStatusUpdateMaxCharacters_alternateCount {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    __block void (^internalCallback)(JiveProperty *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    NSNumber *testMaxCharacters = @10000;
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STFail(@"There should be no errors");
    };
    OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
    
    [(JiveProperty *)[[mockProperty expect] andReturn:JivePropertyTypes.number] type];
    [(JiveProperty *)[[mockProperty expect] andReturn:testMaxCharacters] value];
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, @"feature.status_update.characters", @"Wrong property requested.");
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
    
    [testObject statusUpdateMaxCharacters:^(NSNumber *maxCharacters) {
        STAssertEqualObjects(maxCharacters, testMaxCharacters, @"Reported the wrong number of characters");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testStatusUpdateMaxCharacters_otherJSONError {
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
        STAssertEqualObjects(obj, @"feature.status_update.characters", @"Wrong property requested.");
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
    
    [testObject statusUpdateMaxCharacters:^(NSNumber *maxCharacters) {
        STFail(@"An error should have been reported");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testStatusUpdateMaxCharacters_otherError {
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
        STAssertEqualObjects(obj, @"feature.status_update.characters", @"Wrong property requested.");
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
    
    [testObject statusUpdateMaxCharacters:^(NSNumber *maxCharacters) {
        STFail(@"An error should have been reported");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

#pragma mark - Binary downloads disabled tests

- (void)testBinaryDownloadsDisabled_notDisabled {
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
        STAssertEqualObjects(obj, @"jive.coreapi.disable.binarydownloads.mobileonly", @"Wrong property requested.");
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
    
    [testObject binaryDownloadsDisabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testBinaryDownloadsDisabled_disabled {
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
        STAssertEqualObjects(obj, @"jive.coreapi.disable.binarydownloads.mobileonly", @"Wrong property requested.");
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
    
    [testObject binaryDownloadsDisabled:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be YES");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback((JiveProperty *)mockProperty);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testBinaryDownloadsDisabled_invalidMetadataFlag {
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
        STAssertEqualObjects(obj, @"jive.coreapi.disable.binarydownloads.mobileonly", @"Wrong property requested.");
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
    
    [testObject binaryDownloadsDisabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testBinaryDownloadsDisabled_invalidMetadataError {
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
        STAssertEqualObjects(obj, @"jive.coreapi.disable.binarydownloads.mobileonly", @"Wrong property requested.");
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
    
    [testObject binaryDownloadsDisabled:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(invalidPropertyError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testBinaryDownloadsDisabled_otherJSONError {
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
        STAssertEqualObjects(obj, @"jive.coreapi.disable.binarydownloads.mobileonly", @"Wrong property requested.");
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
    
    [testObject binaryDownloadsDisabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    } onError:errorBlock];
    
    STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
    if (internalErrorBlock) {
        internalErrorBlock(otherError);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testBinaryDownloadsDisabled_otherError {
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
        STAssertEqualObjects(obj, @"jive.coreapi.disable.binarydownloads.mobileonly", @"Wrong property requested.");
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
    
    [testObject binaryDownloadsDisabled:^(BOOL flagValue) {
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
