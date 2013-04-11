//
//  JiveVersionTest.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveVersionTest.h"
#import "JiveVersion.h"
#import "JiveVersionCoreURI.h"

@implementation JiveVersionTest

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
    NSString *releaseID = @"7c2";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray
                            };
    
    JiveVersion *version = [JiveVersion instanceFromJSON:JSON];
    
    STAssertEquals([version class], [JiveVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertNil(version.ssoEnabled, @"Invalid ssoEnabled result");
    STAssertEquals(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
    if (version.coreURI.count == 2) {
        JiveVersionCoreURI *version2 = version.coreURI[0];
        
        STAssertEquals([version2 class], [JiveVersionCoreURI class], @"Wrong sub-item class");
        STAssertEqualObjects(version2.version, apiVersion2, @"Wrong version number");
        STAssertEqualObjects(version2.revision, apiVersion2Revision, @"Wrong revision number");
        STAssertEqualObjects(version2.uri, coreVersion2URI, @"Wrong uri number");
        
        JiveVersionCoreURI *version3 = version.coreURI[1];
        
        STAssertEquals([version3 class], [JiveVersionCoreURI class], @"Wrong sub-item class");
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
    
    JiveVersion *version = [JiveVersion instanceFromJSON:JSON];
    
    STAssertEquals([version class], [JiveVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertEquals(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
    if (version.coreURI.count == 2) {
        JiveVersionCoreURI *version2 = version.coreURI[0];
        
        STAssertEquals([version2 class], [JiveVersionCoreURI class], @"Wrong sub-item class");
        STAssertEqualObjects(version2.version, apiVersion2, @"Wrong version number");
        STAssertEqualObjects(version2.revision, apiVersion2Revision, @"Wrong revision number");
        STAssertEqualObjects(version2.uri, coreVersion2URI, @"Wrong uri number");
        
        JiveVersionCoreURI *version3 = version.coreURI[1];
        
        STAssertEquals([version3 class], [JiveVersionCoreURI class], @"Wrong sub-item class");
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
    JiveVersion *version;
    
    STAssertNoThrow(version = [JiveVersion instanceFromJSON:JSON], @"Should not throw");
    
    STAssertEquals([version class], [JiveVersion class], @"Wrong item class");
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
    JiveVersion *version;
    
    STAssertNoThrow(version = [JiveVersion instanceFromJSON:JSON], @"Should not throw");
    
    STAssertEquals([version class], [JiveVersion class], @"Wrong item class");
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
    JiveVersion *version;
    
    STAssertNoThrow(version = [JiveVersion instanceFromJSON:JSON], @"Should not throw");
    
    STAssertEquals([version class], [JiveVersion class], @"Wrong item class");
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
    
    JiveVersion *version = [JiveVersion instanceFromJSON:JSON];
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
    
    JiveVersion *version = [JiveVersion instanceFromJSON:JSON];
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
    
    JiveVersion *version = [JiveVersion instanceFromJSON:JSON];
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
    
    JiveVersion *version = [JiveVersion instanceFromJSON:JSON];
    
    STAssertEquals([version class], [JiveVersion class], @"Wrong item class");
    STAssertEqualObjects(version.major, major, @"Wrong major version");
    STAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    STAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    STAssertEqualObjects(version.build, build, @"Wrong build version");
    STAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    STAssertEquals(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
    if (version.coreURI.count == 1) {
        JiveVersionCoreURI *version3 = version.coreURI[0];
        
        STAssertEquals([version3 class], [JiveVersionCoreURI class], @"Wrong sub-item class");
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
    
    JiveVersion *version = [JiveVersion instanceFromJSON:JSON];
    
    STAssertEquals([version class], [JiveVersion class], @"Wrong item class");
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

@end
