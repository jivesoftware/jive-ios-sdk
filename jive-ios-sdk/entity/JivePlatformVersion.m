//
//  JivePlatformVersion.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JivePlatformVersion.h"
#import "JiveObject_internal.h"
#import "JiveCoreVersion.h"

struct JivePlatformVersionAttributes const JivePlatformVersionAttributes = {
	.major = @"major",
	.minor = @"minor",
	.maintenance = @"maintenance",
	.build = @"build",
	.releaseID = @"releaseID",
	.coreURI = @"coreURI",
    .ssoEnabled = @"ssoEnabled"
};

static NSString * const JiveVersionKey = @"jiveVersion";
static NSString * const JiveCoreVersionsKey = @"jiveCoreVersions";

typedef NS_ENUM(NSInteger, JiveVersionString) {
    JiveVersionStringVersionComponents = 0,
    JiveVersionStringReleaseID
};

typedef NS_ENUM(NSInteger, JiveVersionComponents) {
    JiveVersionComponentsMajor = 0,
    JiveVersionComponentsMinor,
    JiveVersionComponentsMaintenance,
    JiveVersionComponentsBuild
};

@implementation JivePlatformVersion

@synthesize ssoEnabled;

- (void)parseVersion:(NSString *)versionString {
    NSArray *components = [versionString componentsSeparatedByString:@" "];
    
    if ([components count] == 2)
        [self setValue:components[JiveVersionStringReleaseID] forKey:JivePlatformVersionAttributes.releaseID];
    
    components = [components[JiveVersionStringVersionComponents] componentsSeparatedByString:@"."];
    [self setValue:@([components[JiveVersionComponentsMajor] integerValue])
            forKey:JivePlatformVersionAttributes.major];
    [self setValue:@([components[JiveVersionComponentsMinor] integerValue])
            forKey:JivePlatformVersionAttributes.minor];
    if ([components count] > JiveVersionComponentsMaintenance) {
        [self setValue:@([components[JiveVersionComponentsMaintenance] integerValue])
                forKey:JivePlatformVersionAttributes.maintenance];
        if ([components count] > JiveVersionComponentsBuild)
            [self setValue:@([components[JiveVersionComponentsBuild] integerValue])
                    forKey:JivePlatformVersionAttributes.build];
    }
}

+ (JivePlatformVersion*) instanceFromJSON:(NSDictionary*) JSON {
    JivePlatformVersion *instance = [JivePlatformVersion new];
    NSInteger requiredElementsFound = 0;
    
    for (NSString *key in JSON) {
        if ([JiveVersionKey isEqualToString:key]) {
            [instance parseVersion:JSON[key]];
            ++requiredElementsFound;
        }
        else if ([JiveCoreVersionsKey isEqualToString:key]) {
            NSArray *coreURIs = [JiveCoreVersion instancesFromJSONList:JSON[key]];
            
            [instance setValue:coreURIs forKey:JivePlatformVersionAttributes.coreURI];
            ++requiredElementsFound;
        }
        else
            [instance deserializeKey:key fromJSON:JSON];
    }
    
    return requiredElementsFound == 2 ? instance : nil;
}

@end
