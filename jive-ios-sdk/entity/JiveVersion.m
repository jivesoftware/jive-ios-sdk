//
//  JiveVersion.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveVersion.h"
#import "JiveObject_internal.h"
#import "JiveVersionCoreURI.h"

struct JiveVersionAttributes const JiveVersionAttributes = {
	.major = @"major",
	.minor = @"minor",
	.maintenance = @"maintenance",
	.build = @"build",
	.releaseID = @"releaseID",
	.coreURI = @"coreURI",
    .ssoEnabled = @"ssoEnabled",
};

@implementation JiveVersion

@synthesize ssoEnabled;

- (void)parseVersion:(NSString *)versionString {
    NSArray *components = [versionString componentsSeparatedByString:@" "];
    
    if (components.count == 2)
        [self setValue:components[1] forKey:JiveVersionAttributes.releaseID];
    
    components = [components[0] componentsSeparatedByString:@"."];
    [self setValue:[NSNumber numberWithInteger:[components[0] integerValue]]
            forKey:JiveVersionAttributes.major];
    [self setValue:[NSNumber numberWithInteger:[components[1] integerValue]]
            forKey:JiveVersionAttributes.minor];
    if (components.count > 2) {
        [self setValue:[NSNumber numberWithInteger:[components[2] integerValue]]
                forKey:JiveVersionAttributes.maintenance];
        if (components.count > 3)
            [self setValue:[NSNumber numberWithInteger:[components[3] integerValue]]
                    forKey:JiveVersionAttributes.build];
    }
}

+ (JiveVersion*) instanceFromJSON:(NSDictionary*) JSON {
    JiveVersion *instance = [JiveVersion new];
    NSInteger requiredElementsFound = 0;
    
    for (NSString *key in JSON) {
        if ([@"jiveVersion" isEqualToString:key]) {
            [instance parseVersion:JSON[key]];
            ++requiredElementsFound;
        }
        else if ([@"jiveCoreVersions" isEqualToString:key]) {
            NSArray *coreURIs = [JiveVersionCoreURI instancesFromJSONList:JSON[key]];
            
            [instance setValue:coreURIs forKey:JiveVersionAttributes.coreURI];
            ++requiredElementsFound;
        }
        else
            [instance deserializeKey:key fromJSON:JSON];
    }
    
    return requiredElementsFound == 2 ? instance : nil;
}

@end
