//
//  JiveMetadataTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 8/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveMetadata_internal.h"
#import <OCMock/OCMock.h>
#import "Jive_internal.h"
#import "JiveRetryingJAPIRequestOperation.h"
#import "NSError+Jive.h"
#import "JivePlatformVersionTests.h"


#import <SenTestingKit/SenTestingKit.h>


typedef void(^internalCallbackBlock)(JiveProperty *);

@interface JiveMetadataTests : SenTestCase

@end

@interface JiveMetadataTestCases : SenTestCase

@property(nonatomic) id mockJive;
@property(nonatomic) id mockOperation;
@property(nonatomic) JiveMetadata *testObject;
@property(nonatomic) NSString *metadataPropertyName;

// Call this to setup the mock objects
- (void)setUpMockObjects;

// Override this method to setup additional mock expect methods.
- (void)setupExpects;

// Real test classes must override this method.
- (void)runTestExpectingError:(NSError *)expectedError;

// Real test classes must override this method.
- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError;

@end


@interface JiveMetadataBoolPropertyTestCases : JiveMetadataTestCases

// Real test classes must override this method.
- (void)runTestExpectingValue:(BOOL)expectedValue;

@end

@interface JiveMetadataHasVideoPropertyTests : JiveMetadataBoolPropertyTestCases

@end

@interface JiveMetadataBlogsEnabledPropertyTests : JiveMetadataBoolPropertyTestCases

@end

@interface JiveMetadataRTCEnabledPropertyTests : JiveMetadataBoolPropertyTestCases

@end

@interface JiveMetadataImagesEnabledPropertyTests : JiveMetadataBoolPropertyTestCases

@end

@interface JiveMetadataStatusUpdatesEnabledPropertyTests : JiveMetadataBoolPropertyTestCases

@end

@interface JiveMetadataPersonalStatusUpdatesEnabledPropertyTests : JiveMetadataBoolPropertyTestCases

@end

@interface JiveMetadataPlaceStatusUpdatesEnabledPropertyTests : JiveMetadataBoolPropertyTestCases

@end

@interface JiveMetadataRepostStatusUpdatesEnabledPropertyTests : JiveMetadataBoolPropertyTestCases

@end

@interface JiveMetadataBinaryDownloadsDisabledPropertyTests : JiveMetadataBoolPropertyTestCases

@end

@interface JiveMetadataShareEnabledPropertyTests : JiveMetadataBoolPropertyTestCases

@end


@interface JiveMetadataIntegerPropertyTestCases : JiveMetadataTestCases

@end

@interface JiveMetadataStatusUpdateMaxCharactersTests : JiveMetadataIntegerPropertyTestCases

@end

@interface JiveMetadataMaxAttachementSizeInKBTests : JiveMetadataIntegerPropertyTestCases

@end


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

@end


#pragma mark Property test classes

@implementation JiveMetadataHasVideoPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.videoModuleEnabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject hasVideo:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                      onError:^(NSError *error) {
                          STFail(@"There should be no errors");
                      }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject hasVideo:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                      onError:^(NSError *error) {
                          STAssertEqualObjects(error, expectedError,
                                               @"Wrong error passed to the errorBlock");
                      }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject hasVideoOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                      onError:^(NSError *error) {
                                          STAssertEqualObjects(error, expectedError,
                                                               @"Wrong error passed to the errorBlock");
                                      }];
}

- (void)setupExpects {
    [[[self.mockJive expect] andReturn:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0]] platformVersion];
}

- (void)testHasVideo_noVideo_withVideoModuleProperty {
    __block void (^internalCallback)(JiveProperty *);
    
    [[[self.mockJive expect] andReturn:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0]] platformVersion];
    [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [JivePropertyNames.videoModuleEnabled isEqual:obj];
    }] onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                             onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        return YES;
    }]];
    
    [self.testObject hasVideo:^(BOOL flagValue) {
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
}

- (void)testHasVideo_hasVideo_withVideoModuleProperty {
    __block void (^internalCallback)(JiveProperty *);
    
    [[[self.mockJive expect] andReturn:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0]] platformVersion];
    [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [JivePropertyNames.videoModuleEnabled isEqual:obj];
    }] onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                             onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        return YES;
    }]];
    
    [self.testObject hasVideo:^(BOOL flagValue) {
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
}

- (void)testHasVideo_noVideo {
    NSDictionary *objects = @{@"carousel" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/carousel",
                              @"contentVersion" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/contentVersion"
                              };
    __block void (^internalCallback)(NSDictionary *);
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STAssertTrue(false, @"There should be no errors");
    };
    
    [[[self.mockJive expect] andReturn:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:6 minorVersion:0 maintenanceVersion:1 buildVersion:0]] platformVersion];
    [[[self.mockJive expect] andReturn:self.mockOperation] objectsOperationOnComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                              onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEquals(obj, (id)errorBlock, @"Wrong error block passed");
        return obj != nil;
    }]];
    
    [self.testObject hasVideo:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback(objects);
    }
}

- (void)testHasVideo_hasVideo {
    NSDictionary *objects = @{@"carousel" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/carousel",
                              @"video" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/video",
                              @"contentVersion" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/contentVersion"
                              };
    __block void (^internalCallback)(NSDictionary *);
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STAssertTrue(false, @"There should be no errors");
    };
    
    [[[self.mockJive expect] andReturn:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0]] platformVersion];
    [[[self.mockJive expect] andReturn:self.mockOperation] objectsOperationOnComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                              onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEquals(obj, (id)errorBlock, @"Wrong error block passed");
        return obj != nil;
    }]];
    
    [self.testObject hasVideo:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback(objects);
    }
}

@end

@implementation JiveMetadataBlogsEnabledPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.blogsEnabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject blogsEnabled:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                                 onError:^(NSError *error) {
                                     STFail(@"There should be no errors");
                                 }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject blogsEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                 onError:^(NSError *error) {
                                     STAssertEqualObjects(error, expectedError,
                                                          @"Wrong error passed to the errorBlock");
                                 }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject blogsEnabledOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                                 onError:^(NSError *error) {
                                                     STAssertEqualObjects(error, expectedError,
                                                                          @"Wrong error passed to the errorBlock");
                                                 }];
}

@end

@implementation JiveMetadataRTCEnabledPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.realTimeChatEnabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject realTimeChatEnabled:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                                 onError:^(NSError *error) {
                                     STFail(@"There should be no errors");
                                 }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject realTimeChatEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                 onError:^(NSError *error) {
                                     STAssertEqualObjects(error, expectedError,
                                                          @"Wrong error passed to the errorBlock");
                                 }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject realTimeChatEnabledOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                                 onError:^(NSError *error) {
                                                     STAssertEqualObjects(error, expectedError,
                                                                          @"Wrong error passed to the errorBlock");
                                                 }];
}

@end

@implementation JiveMetadataImagesEnabledPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.imagesEnabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject imagesEnabled:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                           onError:^(NSError *error) {
                               STFail(@"There should be no errors");
                           }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject imagesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                           onError:^(NSError *error) {
                               STAssertEqualObjects(error, expectedError,
                                                    @"Wrong error passed to the errorBlock");
                           }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject imagesEnabledOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                           onError:^(NSError *error) {
                                               STAssertEqualObjects(error, expectedError,
                                                                    @"Wrong error passed to the errorBlock");
                                           }];
}

@end

@implementation JiveMetadataStatusUpdatesEnabledPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.statusUpdatesEnabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject statusUpdatesEnabled:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                                  onError:^(NSError *error) {
                                      STFail(@"There should be no errors");
                                  }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject statusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                  onError:^(NSError *error) {
                                      STAssertEqualObjects(error, expectedError,
                                                           @"Wrong error passed to the errorBlock");
                                  }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject statusUpdatesEnabledOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                                  onError:^(NSError *error) {
                                                      STAssertEqualObjects(error, expectedError,
                                                                           @"Wrong error passed to the errorBlock");
                                                  }];
}

@end

@implementation JiveMetadataPersonalStatusUpdatesEnabledPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.personalStatusUpdatesEnabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject personalStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                                          onError:^(NSError *error) {
                                              STFail(@"There should be no errors");
                                          }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject personalStatusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                          onError:^(NSError *error) {
                                              STAssertEqualObjects(error, expectedError,
                                                                   @"Wrong error passed to the errorBlock");
                                          }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject personalStatusUpdatesEnabledOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                                          onError:^(NSError *error) {
                                                              STAssertEqualObjects(error, expectedError,
                                                                                   @"Wrong error passed to the errorBlock");
                                                          }];
}

@end

@implementation JiveMetadataPlaceStatusUpdatesEnabledPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.placeStatusUpdatesEnabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject placeStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                                       onError:^(NSError *error) {
                                           STFail(@"There should be no errors");
                                       }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject placeStatusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                       onError:^(NSError *error) {
                                           STAssertEqualObjects(error, expectedError,
                                                                @"Wrong error passed to the errorBlock");
                                       }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject placeStatusUpdatesEnabledOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                                       onError:^(NSError *error) {
                                                           STAssertEqualObjects(error, expectedError,
                                                                                @"Wrong error passed to the errorBlock");
                                                       }];
}

@end

@implementation JiveMetadataRepostStatusUpdatesEnabledPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.repostStatusUpdatesEnabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject repostStatusUpdatesEnabled:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                                        onError:^(NSError *error) {
                                            STFail(@"There should be no errors");
                                        }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject repostStatusUpdatesEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                        onError:^(NSError *error) {
                                            STAssertEqualObjects(error, expectedError,
                                                                 @"Wrong error passed to the errorBlock");
                                        }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject repostStatusUpdatesEnabledOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                                        onError:^(NSError *error) {
                                                            STAssertEqualObjects(error, expectedError,
                                                                                 @"Wrong error passed to the errorBlock");
                                                        }];
}

@end

@implementation JiveMetadataStatusUpdateMaxCharactersTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.statusUpdateMaxCharacters;
    [super setUpMockObjects];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject statusUpdateMaxCharacters:^(NSNumber *maxCharacters) {
        STFail(@"A value should not be generated");
    }
                                       onError:^(NSError *error) {
                                           STAssertEqualObjects(error, expectedError,
                                                                @"Wrong error passed to the errorBlock");
                                       }];
}

- (void)runTestExpectingValue:(NSNumber *)expectedValue {
    [self.testObject statusUpdateMaxCharacters:^(NSNumber *value) {
        STAssertEqualObjects(value, expectedValue, @"Wrong value returned");
    }
                                       onError:^(NSError *error) {
                                           STFail(@"There should be no errors");
                                       }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject statusUpdateMaxCharactersOperation:^(NSNumber *value) {
        STFail(@"A value should not be generated");
    }
                                              onError:^(NSError *error) {
                                                  STAssertEqualObjects(error, expectedError,
                                                                       @"Wrong error passed to the errorBlock");
                                              }];
}

@end

@implementation JiveMetadataBinaryDownloadsDisabledPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.mobileBinaryDownloadsDisabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject binaryDownloadsDisabled:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                                     onError:^(NSError *error) {
                                         STFail(@"There should be no errors");
                                     }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject binaryDownloadsDisabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                     onError:^(NSError *error) {
                                         STAssertEqualObjects(error, expectedError,
                                                              @"Wrong error passed to the errorBlock");
                                     }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject binaryDownloadsDisabledOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                                     onError:^(NSError *error) {
                                                         STAssertEqualObjects(error, expectedError,
                                                                              @"Wrong error passed to the errorBlock");
                                                     }];
}

@end

@implementation JiveMetadataShareEnabledPropertyTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.shareEnabled;
    [super setUpMockObjects];
}

- (void)runTestExpectingValue:(BOOL)expectedValue {
    [self.testObject shareEnabled:^(BOOL flagValue) {
        STAssertEquals(flagValue, expectedValue, @"Wrong value returned");
    }
                                     onError:^(NSError *error) {
                                         STFail(@"There should be no errors");
                                     }];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject shareEnabled:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                     onError:^(NSError *error) {
                                         STAssertEqualObjects(error, expectedError,
                                                              @"Wrong error passed to the errorBlock");
                                     }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject shareEnabledOperation:^(BOOL flagValue) {
        STFail(@"A value should not be generated");
    }
                                                     onError:^(NSError *error) {
                                                         STAssertEqualObjects(error, expectedError,
                                                                              @"Wrong error passed to the errorBlock");
                                                     }];
}

@end


@implementation JiveMetadataMaxAttachementSizeInKBTests

- (void)setUp {
    self.metadataPropertyName = JivePropertyNames.maxAttachmentSize;
    [super setUpMockObjects];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    [self.testObject maxAttachmentSizeInKB:^(NSNumber *maxCharacters) {
        STFail(@"A value should not be generated");
    }
                                   onError:^(NSError *error) {
                                       STAssertEqualObjects(error, expectedError,
                                                            @"Wrong error passed to the errorBlock");
                                   }];
}

- (void)runTestExpectingValue:(NSNumber *)expectedValue {
    [self.testObject maxAttachmentSizeInKB:^(NSNumber *value) {
        STAssertEqualObjects(value, expectedValue, @"Wrong value returned");
    }
                                   onError:^(NSError *error) {
                                       STFail(@"There should be no errors");
                                   }];
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    return [self.testObject maxAttachmentSizeInKBOperation:^(NSNumber *value) {
        STFail(@"A value should not be generated");
    }
                                                   onError:^(NSError *error) {
                                                       STAssertEqualObjects(error, expectedError,
                                                                            @"Wrong error passed to the errorBlock");
                                                   }];
}

@end


#pragma mark Value type test classes

@implementation JiveMetadataTestCases

- (void)setUpMockObjects {
    [super setUp];
    self.mockJive = [OCMockObject mockForClass:[Jive class]];
    self.mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    [(JiveRetryingJAPIRequestOperation *)[self.mockOperation expect] start];
    self.testObject = [[JiveMetadata alloc] initWithInstance:self.mockJive];
}

- (void)tearDown {
    STAssertNoThrow([self.mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([self.mockJive verify], @"The operation was not created.");
    self.testObject = nil;
    self.mockOperation = nil;
    self.mockJive = nil;
    [super tearDown];
}

- (void)runTestExpectingError:(NSError *)expectedError {
    STFail(@"Error test not run. Please override this method in your test class.");
}

- (NSOperation *)runTestOperationExpectingError:(NSError *)expectedError {
    STFail(@"Error test not run. Please override this method in your test class.");
    return nil;
}

- (void)setupExpects {
}

- (void)testForbiddenOperationJSONError {
    if (self.testObject) {
        __block JiveErrorBlock internalErrorBlock;
        NSError *otherError = [NSError jive_errorWithUnderlyingError:nil
                                                                JSON:@{@"error":@{@"message":@"Test failure that is not a 404",
                                                                                  @"status":@403,
                                                                                  @"code":@"Not a 404"}}];
        
        [self setupExpects];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalErrorBlock = [obj copy];
            return obj != nil;
        }]];
        
        [self runTestExpectingError:otherError];
        
        STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
        if (internalErrorBlock) {
            internalErrorBlock(otherError);
        }
    }
}

- (void)testBadRequestError {
    if (self.testObject) {
        __block JiveErrorBlock internalErrorBlock;
        NSError *otherError = [NSError jive_errorWithUnderlyingError:[NSError errorWithDomain:@"Invalid request"
                                                                                         code:400
                                                                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid request 400"}]];
        
        [self setupExpects];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalErrorBlock = [obj copy];
            return obj != nil;
        }]];
        
        [self runTestExpectingError:otherError];
        
        STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
        if (internalErrorBlock) {
            internalErrorBlock(otherError);
        }
    }
}

- (void)testOperationBadRequestError {
    if (self.testObject) {
        __block JiveErrorBlock internalErrorBlock;
        NSError *otherError = [NSError jive_errorWithUnderlyingError:[NSError errorWithDomain:@"Invalid request"
                                                                                         code:400
                                                                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid request 400"}]];
        
        [self setupExpects];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalErrorBlock = [obj copy];
            return obj != nil;
        }]];
        
        NSOperation *operation = [self runTestOperationExpectingError:otherError];
        
        STAssertNotNil(operation, @"Operation method must return an operation.");
        [operation start];
        STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
        if (internalErrorBlock) {
            internalErrorBlock(otherError);
        }
    }
}

@end

@implementation JiveMetadataBoolPropertyTestCases

- (void)runTestExpectingValue:(BOOL)expectedValue {
    STFail(@"Error test not run. Please override this method in your test class.");
}

- (void)testPropertyIsNo {
    if (self.testObject) {
        __block internalCallbackBlock internalCallback;
        OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
        
        [self setupExpects];
        [(JiveProperty *)[[mockProperty expect] andReturn:JivePropertyTypes.boolean] type];
        [(JiveProperty *)[[mockProperty expect] andReturn:@NO] value];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalCallback = [obj copy];
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]];
        
        [self runTestExpectingValue:NO];
        
        STAssertNotNil(internalCallback, @"A callback should have been set.");
        if (internalCallback) {
            internalCallback((JiveProperty *)mockProperty);
        }
        
        STAssertNoThrow([mockProperty verify], @"The property was not processed correctly");
    }
}

- (void)testPropertyIsYes {
    if (self.testObject) {
        __block internalCallbackBlock internalCallback;
        OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
        
        [self setupExpects];
        [(JiveProperty *)[[mockProperty expect] andReturn:JivePropertyTypes.boolean] type];
        [(JiveProperty *)[[mockProperty expect] andReturn:@YES] value];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalCallback = [obj copy];
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]];
        
        [self runTestExpectingValue:YES];
        
        STAssertNotNil(internalCallback, @"A callback should have been set.");
        if (internalCallback) {
            internalCallback((JiveProperty *)mockProperty);
        }
        
        STAssertNoThrow([mockProperty verify], @"The property was not processed correctly");
    }
}

- (void)testInvalidMetadataJSONError {
    if (self.testObject) {
        __block JiveErrorBlock internalErrorBlock;
        OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
        NSError *invalidPropertyError = [NSError jive_errorWithUnderlyingError:nil
                                                                          JSON:@{@"error":@{@"message":@"Invalid property name feature.ctr.enabled",
                                                                                            @"status":@404,
                                                                                            @"code":@"objectInvalidPropertyName"}}];
        
        [self setupExpects];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalErrorBlock = [obj copy];
            return obj != nil;
        }]];
        
        [self runTestExpectingValue:NO];
        
        STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
        if (internalErrorBlock) {
            internalErrorBlock(invalidPropertyError);
        }
        
        STAssertNoThrow([mockProperty verify], @"The property was not processed correctly");
    }
}

- (void)testInvalidMetadataError {
    if (self.testObject) {
        __block JiveErrorBlock internalErrorBlock;
        OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
        NSError *invalidPropertyError = [NSError jive_errorWithUnderlyingError:[NSError errorWithDomain:@"Invalid property name"
                                                                                                   code:404
                                                                                               userInfo:@{NSLocalizedDescriptionKey: @"Invalid property name 404"}]];
        
        [self setupExpects];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalErrorBlock = [obj copy];
            return obj != nil;
        }]];
        
        [self runTestExpectingValue:NO];
        
        STAssertNotNil(internalErrorBlock, @"A callback should have been set.");
        if (internalErrorBlock) {
            internalErrorBlock(invalidPropertyError);
        }
        
        STAssertNoThrow([mockProperty verify], @"The property was not processed correctly");
    }
}

@end

@implementation JiveMetadataIntegerPropertyTestCases


- (void)runTestExpectingValue:(NSNumber *)expectedValue {
    STFail(@"Error test not run. Please override this method in your test class.");
}

- (void)testPropertySmallNumber {
    if (self.testObject) {
        __block internalCallbackBlock internalCallback;
        NSNumber *expectedValue = @200;
        OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
        
        [self setupExpects];
        [(JiveProperty *)[[mockProperty expect] andReturn:JivePropertyTypes.number] type];
        [(JiveProperty *)[[mockProperty expect] andReturn:expectedValue] value];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalCallback = [obj copy];
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]];
        
        [self runTestExpectingValue:expectedValue];
        
        STAssertNotNil(internalCallback, @"A callback should have been set.");
        if (internalCallback) {
            internalCallback((JiveProperty *)mockProperty);
        }
        
        STAssertNoThrow([mockProperty verify], @"The property was not processed correctly");
    }
}

- (void)testPropertyLargeNumber {
    if (self.testObject) {
        __block internalCallbackBlock internalCallback;
        NSNumber *expectedValue = @3000000;
        OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
        
        [self setupExpects];
        [(JiveProperty *)[[mockProperty expect] andReturn:JivePropertyTypes.number] type];
        [(JiveProperty *)[[mockProperty expect] andReturn:expectedValue] value];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalCallback = [obj copy];
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]];
        
        [self runTestExpectingValue:expectedValue];
        
        STAssertNotNil(internalCallback, @"A callback should have been set.");
        if (internalCallback) {
            internalCallback((JiveProperty *)mockProperty);
        }
        
        STAssertNoThrow([mockProperty verify], @"The property was not processed correctly");
    }
}

- (void)testPropertySmallInteger {
    if (self.testObject) {
        __block internalCallbackBlock internalCallback;
        NSNumber *expectedValue = @200;
        OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
        
        [self setupExpects];
        [(JiveProperty *)[[mockProperty stub] andReturn:JivePropertyTypes.integer] type];
        [(JiveProperty *)[[mockProperty expect] andReturn:expectedValue] value];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalCallback = [obj copy];
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]];
        
        [self runTestExpectingValue:expectedValue];
        
        STAssertNotNil(internalCallback, @"A callback should have been set.");
        if (internalCallback) {
            internalCallback((JiveProperty *)mockProperty);
        }
        
        STAssertNoThrow([mockProperty verify], @"The property was not processed correctly");
    }
}

- (void)testPropertyLargeInteger {
    if (self.testObject) {
        __block internalCallbackBlock internalCallback;
        NSNumber *expectedValue = @3000000;
        OCMockObject *mockProperty = [OCMockObject partialMockForObject:[JiveProperty new]];
        
        [self setupExpects];
        [(JiveProperty *)[[mockProperty stub] andReturn:JivePropertyTypes.integer] type];
        [(JiveProperty *)[[mockProperty expect] andReturn:expectedValue] value];
        [[[self.mockJive expect] andReturn:self.mockOperation] propertyWithNameOperation:[OCMArg checkWithBlock:^BOOL(id obj) {
            STAssertEqualObjects(obj, self.metadataPropertyName, @"Wrong property requested.");
            return obj != nil;
        }]
                                                                              onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
            internalCallback = [obj copy];
            return obj != nil;
        }]
                                                                                 onError:[OCMArg checkWithBlock:^BOOL(id obj) {
            return obj != nil;
        }]];
        
        [self runTestExpectingValue:expectedValue];
        
        STAssertNotNil(internalCallback, @"A callback should have been set.");
        if (internalCallback) {
            internalCallback((JiveProperty *)mockProperty);
        }
        
        STAssertNoThrow([mockProperty verify], @"The property was not processed correctly");
    }
}

@end
