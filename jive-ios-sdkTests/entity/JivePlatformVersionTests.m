//
//  JivePlatformVersionTest.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
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

#import "JivePlatformVersionTests.h"
#import "JivePlatformVersion.h"
#import "JiveCoreVersion.h"
#import <OCMock/OCMock.h>

@interface JivePlatformVersion (TestSupport)
- (BOOL)supportsFeatureAvailableWithMajorVersion:(NSUInteger)majorVersion
                                    minorVersion:(NSUInteger)minorVersion
                              maintenanceVersion:(NSUInteger)maintenanceVersion
                                    buildVersion:(NSUInteger)buildVersion;
@end

@implementation JivePlatformVersionTests

- (void)setUp {
    [super setUp];
    self.object = [JivePlatformVersion new];
}

- (void)testVersionParsing {
    NSNumber *apiVersion2 = @2;
    NSNumber *apiVersion2Revision = @3;
    NSString *coreVersion2URI = @"/api/core/v2";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v2/rest"
                                    };
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v3/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *sdkVersion = [JivePlatformVersion new].sdk;
    NSString *releaseID = @"7c2";
    NSString *instanceURL = @"https://dummy.com/";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"instanceURL" : instanceURL
                            };
    
    STAssertNotNil(sdkVersion, @"PRECONDITION: Invalid sdk version");
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                          withInstance:self.instance];
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertNil(version.ssoEnabled, @"Invalid ssoEnabled result");
    STAssertEqualObjects(version.sdk, sdkVersion, @"Invalid sdk version number");
    STAssertEqualObjects([version.instanceURL absoluteString], instanceURL, @"Invalid instance URL");
    STAssertEquals(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
    if (version.coreURI.count == 2) {
        JiveCoreVersion *version2 = version.coreURI[0];
        
        STAssertEquals([version2 class], [JiveCoreVersion class], @"Wrong sub-item class");
        STAssertEqualObjects(version2.version, apiVersion2, @"Wrong version number");
        STAssertEqualObjects(version2.revision, apiVersion2Revision, @"Wrong revision number");
        STAssertEqualObjects(version2.uri, coreVersion2URI, @"Wrong uri number");
        
        JiveCoreVersion *version3 = version.coreURI[1];
        
        STAssertEquals([version3 class], [JiveCoreVersion class], @"Wrong sub-item class");
        STAssertEqualObjects(version3.version, apiVersion3, @"Wrong version number");
        STAssertEqualObjects(version3.revision, apiVersion3Revision, @"Wrong revision number");
        STAssertEqualObjects(version3.uri, coreVersion3URI, @"Wrong uri number");
    }
}

- (void)testVersionParsing_preLogin {
    NSNumber *apiVersion2 = @2;
    NSNumber *apiVersion2Revision = @3;
    NSString *coreVersion2URI = @"/api/core/v2";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v2/rest"
                                    };
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v3/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *sdkVersion = [JivePlatformVersion new].sdk;
    NSString *releaseID = @"7c2";
    NSString *instanceURL = @"https://dummy.com/";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"instanceURL" : instanceURL
                            };
    
    STAssertNotNil(sdkVersion, @"PRECONDITION: Invalid sdk version");
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                          withInstance:[Jive new]];
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertNil(version.ssoEnabled, @"Invalid ssoEnabled result");
    STAssertEqualObjects(version.sdk, sdkVersion, @"Invalid sdk version number");
    STAssertEqualObjects([version.instanceURL absoluteString], instanceURL, @"Invalid instance URL");
    STAssertEquals(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
    if (version.coreURI.count == 2) {
        JiveCoreVersion *version2 = version.coreURI[0];
        
        STAssertEquals([version2 class], [JiveCoreVersion class], @"Wrong sub-item class");
        STAssertEqualObjects(version2.version, apiVersion2, @"Wrong version number");
        STAssertEqualObjects(version2.revision, apiVersion2Revision, @"Wrong revision number");
        STAssertEqualObjects(version2.uri, coreVersion2URI, @"Wrong uri number");
        
        JiveCoreVersion *version3 = version.coreURI[1];
        
        STAssertEquals([version3 class], [JiveCoreVersion class], @"Wrong sub-item class");
        STAssertEqualObjects(version3.version, apiVersion3, @"Wrong version number");
        STAssertEqualObjects(version3.revision, apiVersion3Revision, @"Wrong revision number");
        STAssertEqualObjects(version3.uri, coreVersion3URI, @"Wrong uri number");
    }
}

- (void)testVersionParsingAlternate {
    NSNumber *apiVersion2 = @1;
    NSNumber *apiVersion2Revision = @2;
    NSString *coreVersion2URI = @"/api/core/v1";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v1/rest"
                                    };
    NSNumber *apiVersion3 = @4;
    NSNumber *apiVersion3Revision = @6;
    NSString *coreVersion3URI = @"/api/core/v4";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v4/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @6;
    NSNumber *minor = @1;
    NSNumber *maintenance = @2;
    NSNumber *build = @3;
    NSString *releaseID = @"6c5";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertNil(version.instanceURL, @"There should be no instance URL here");
    STAssertEquals(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
    if (version.coreURI.count == 2) {
        JiveCoreVersion *version2 = version.coreURI[0];
        
        STAssertEquals([version2 class], [JiveCoreVersion class], @"Wrong sub-item class");
        STAssertEqualObjects(version2.version, apiVersion2, @"Wrong version number");
        STAssertEqualObjects(version2.revision, apiVersion2Revision, @"Wrong revision number");
        STAssertEqualObjects(version2.uri, coreVersion2URI, @"Wrong uri number");
        
        JiveCoreVersion *version3 = version.coreURI[1];
        
        STAssertEquals([version3 class], [JiveCoreVersion class], @"Wrong sub-item class");
        STAssertEqualObjects(version3.version, apiVersion3, @"Wrong version number");
        STAssertEqualObjects(version3.revision, apiVersion3Revision, @"Wrong revision number");
        STAssertEqualObjects(version3.uri, coreVersion3URI, @"Wrong uri number");
    }
}

- (void)testVersionParsing_NoReleaseID {
    NSNumber *apiVersion2 = @1;
    NSNumber *apiVersion2Revision = @2;
    NSString *coreVersion2URI = @"/api/core/v1";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v1/rest"
                                    };
    NSNumber *apiVersion3 = @4;
    NSNumber *apiVersion3Revision = @6;
    NSString *coreVersion3URI = @"/api/core/v4";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v4/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @6;
    NSNumber *minor = @1;
    NSNumber *maintenance = @2;
    NSNumber *build = @3;
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@",
                                              major, minor, maintenance, build],
                            @"jiveCoreVersions" : versionsArray
                            };
    JivePlatformVersion *version;
    
    STAssertNoThrow(version = [JivePlatformVersion objectFromJSON:JSON
                                                       withInstance:self.instance], @"Should not throw");
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertNil(version.releaseID, @"Wrong releaseID version");
    STAssertEquals(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
}

- (void)testVersionParsing_NoBuild {
    NSNumber *apiVersion2 = @1;
    NSNumber *apiVersion2Revision = @2;
    NSString *coreVersion2URI = @"/api/core/v1";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v1/rest"
                                    };
    NSNumber *apiVersion3 = @4;
    NSNumber *apiVersion3Revision = @6;
    NSString *coreVersion3URI = @"/api/core/v4";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v4/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @6;
    NSNumber *minor = @1;
    NSNumber *maintenance = @2;
    NSString *releaseID = @"6c5";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@ %@",
                                              major, minor, maintenance, releaseID],
                            @"jiveCoreVersions" : versionsArray
                            };
    JivePlatformVersion *version;
    
    STAssertNoThrow(version = [JivePlatformVersion objectFromJSON:JSON
                                                       withInstance:self.instance], @"Should not throw");
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertNil(version.build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertEquals(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
}

- (void)testVersionParsing_NoMaintenance {
    NSNumber *apiVersion2 = @1;
    NSNumber *apiVersion2Revision = @2;
    NSString *coreVersion2URI = @"/api/core/v1";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v1/rest"
                                    };
    NSNumber *apiVersion3 = @4;
    NSNumber *apiVersion3Revision = @6;
    NSString *coreVersion3URI = @"/api/core/v4";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v4/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @6;
    NSNumber *minor = @1;
    NSString *releaseID = @"6c5";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@ %@",
                                              major, minor, releaseID],
                            @"jiveCoreVersions" : versionsArray
                            };
    JivePlatformVersion *version;
    
    STAssertNoThrow(version = [JivePlatformVersion objectFromJSON:JSON
                                                       withInstance:self.instance], @"Should not throw");
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertNil(version.maintenance, @"Wrong maintenance version");
    STAssertNil(version.build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertEquals(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
}

- (void)testVersionParsingInvalidJSON_WrongTags {
    NSNumber *apiVersion2 = @2;
    NSNumber *apiVersion2Revision = @3;
    NSString *coreVersion2URI = @"/api/core/v2";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v2/rest"
                                    };
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v3/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSDictionary *JSON = @{ @"version" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"versions" : versionsArray
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    STAssertNil(version, @"Invalid JSON parsed");
}

- (void)testVersionParsingInvalidJSON_MissingVersion {
    NSNumber *apiVersion2 = @2;
    NSNumber *apiVersion2Revision = @3;
    NSString *coreVersion2URI = @"/api/core/v2";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v2/rest"
                                    };
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v3/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSDictionary *JSON = @{ @"versions" : versionsArray
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    STAssertNil(version, @"Invalid JSON parsed");
}

- (void)testVersionParsingInvalidJSON_MissingCoreVersions {
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSDictionary *JSON = @{ @"version" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                          major, minor, maintenance, build, releaseID],
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    STAssertNil(version, @"Invalid JSON parsed");
}

- (void)testVersionParsing_SingleVersion {
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v3/rest"
                                    };
    NSArray *versionsArray = @[version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertEquals(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
    if (version.coreURI.count == 1) {
        JiveCoreVersion *version3 = version.coreURI[0];
        
        STAssertEquals([version3 class], [JiveCoreVersion class], @"Wrong sub-item class");
        STAssertEqualObjects(version3.version, apiVersion3, @"Wrong version number");
        STAssertEqualObjects(version3.revision, apiVersion3Revision, @"Wrong revision number");
        STAssertEqualObjects(version3.uri, coreVersion3URI, @"Wrong uri number");
    }
}

- (void)testSSOEnabledParsing {
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v3/rest"
                                    };
    NSArray *versionsArray = @[version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSArray *ssoTypes = @[@"sso"];
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"ssoEnabled" : ssoTypes
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertEquals(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
    STAssertEquals(version.ssoEnabled.count, (NSUInteger)1, @"Wrong number of ssoEnabled entries");
    if (version.ssoEnabled.count > 0) {
        STAssertEquals(version.ssoEnabled[0], ssoTypes[0], @"Wrong sso type");
    }
}

- (void)testInstanceURL {
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v3/rest"
                                    };
    NSArray *versionsArray = @[version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSString *instanceURL = @"http://alternate.net/";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"instanceURL" : instanceURL
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                          withInstance:self.instance];
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertEqualObjects([version.instanceURL absoluteString], instanceURL, @"Wrong instance URL");
    STAssertEquals(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
}

- (void)testInstanceURLWithoutTrailingSlash {
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v3/rest"
                                    };
    NSArray *versionsArray = @[version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSString *instanceURLWithoutSlash = @"http://alternate.net";
    NSString *instanceURLWithSlash = @"http://alternate.net/";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"instanceURL" : instanceURLWithoutSlash
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                          withInstance:self.instance];
    
    STAssertEquals([version class], [JivePlatformVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertEqualObjects([version.instanceURL absoluteString], instanceURLWithSlash, @"Wrong instance URL");
    STAssertEquals(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
}

- (void)test_supportsFeatureAvailableWithMajorVersion_minorVersion_maintenanceVersion_valid {
    JivePlatformVersion *version = [JivePlatformVersionTests jivePlatformVersionWithMajorVersion:6 minorVersion:5 maintenanceVersion:3 buildVersion:0];
    
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:0 minorVersion:0 maintenanceVersion:1 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:5 minorVersion:8 maintenanceVersion:8 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:2 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:5 maintenanceVersion:2 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:5 maintenanceVersion:3 buildVersion:0], @"Feature should be supported for platform version");
    
    version = [JivePlatformVersionTests jivePlatformVersionWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:0 minorVersion:0 maintenanceVersion:1 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:5 minorVersion:8 maintenanceVersion:8 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:2 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:5 maintenanceVersion:2 buildVersion:0], @"Feature should be supported for platform version");
    STAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:5 maintenanceVersion:3 buildVersion:0], @"Feature should be supported for platform version");
}

- (void)test_supportsDraftPostCreation {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertFalse([version supportsDraftPostCreation], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertTrue([version supportsDraftPostCreation], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsDraftPostContentFilter {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertFalse([version supportsDraftPostContentFilter], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertTrue([version supportsDraftPostContentFilter], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsExplicitSSO {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:2 buildVersion:0];
    STAssertFalse([version supportsExplicitSSO], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:2 buildVersion:0];
    STAssertTrue([version supportsExplicitSSO], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsFollowing {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:4 buildVersion:0];
    STAssertFalse([version supportsFollowing], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:4 buildVersion:0];
    STAssertTrue([version supportsFollowing], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsStatusUpdateInPlace {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertFalse([version supportsStatusUpdateInPlace], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertTrue([version supportsStatusUpdateInPlace], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsBookmarkInboxEntries {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertFalse([version supportsBookmarkInboxEntries], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertTrue([version supportsBookmarkInboxEntries], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsCorrectAndHelpfulReplies {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertFalse([version supportsCorrectAndHelpfulReplies], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertTrue([version supportsCorrectAndHelpfulReplies], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsStructuredOutcomes {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertFalse([version supportsStructuredOutcomes], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertTrue([version supportsStructuredOutcomes], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsUnmarkAsCorrectAnswer {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertFalse([version supportsUnmarkAsCorrectAnswer], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertTrue([version supportsUnmarkAsCorrectAnswer], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsExplicitCorrectAnswerAPI {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertFalse([version supportsExplicitCorrectAnswerAPI], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertTrue([version supportsExplicitCorrectAnswerAPI], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsDiscussionLikesInActivityObjects {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertFalse([version supportsDiscussionLikesInActivityObjects], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertTrue([version supportsDiscussionLikesInActivityObjects], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsInboxTypeFiltering {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertFalse([version supportsInboxTypeFiltering], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertTrue([version supportsInboxTypeFiltering], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsCommentAndReplyPermissions {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertFalse([version supportsCommentAndReplyPermissions], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertTrue([version supportsCommentAndReplyPermissions], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportedIPhoneVersion {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertFalse([version supportedIPhoneVersion], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertTrue([version supportedIPhoneVersion], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsOAuth {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertFalse([version supportsOAuth], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertTrue([version supportsOAuth], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsOAuthSessionGrant {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0];
    STAssertFalse([version supportsOAuthSessionGrant], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0];
    STAssertTrue([version supportsOAuthSessionGrant], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsFeatureModuleVideoProperty {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0];
    STAssertFalse([version supportsFeatureModuleVideoProperty], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0];
    STAssertTrue([version supportsFeatureModuleVideoProperty], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsContentEditingAPI {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertFalse([version supportsContentEditingAPI], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    STAssertTrue([version supportsContentEditingAPI], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsLikeCountInStreams {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertFalse([version supportsLikeCountInStreams], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    STAssertTrue([version supportsLikeCountInStreams], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsNativeAppAllowed {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:2];
    STAssertFalse([version supportsNativeAppAllowed], @"should not support this feature");
    STAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:2];
    STAssertTrue([version supportsNativeAppAllowed], @"should support this feature");
    STAssertNoThrow([version verify], @"verify failure");
}

#pragma mark - Factory methods

+ (JivePlatformVersion *)jivePlatformVersionWithMajorVersion:(NSUInteger)majorVersion minorVersion:(NSUInteger)minorVersion maintenanceVersion:(NSUInteger)maintenanceVersion buildVersion:(NSUInteger)buildVersion {
    JivePlatformVersion *version = [[JivePlatformVersion alloc] init];
    
    [version setValue:@(majorVersion) forKey:JivePlatformVersionAttributes.major];
    [version setValue:@(minorVersion) forKey:JivePlatformVersionAttributes.minor];
    [version setValue:@(maintenanceVersion) forKey:JivePlatformVersionAttributes.maintenance];
    [version setValue:@(buildVersion) forKey:JivePlatformVersionAttributes.build];
    
    return version;
}

@end
