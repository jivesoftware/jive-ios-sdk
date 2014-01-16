//
//  TestObjectFactory.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/15/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JiveResourceEntry;

@interface TestObjectFactory : NSObject

+ (JiveResourceEntry *)createSelfResourceEntryForPerson:(NSString *)personID
                                               atServer:(NSURL *)serverURL;

@end
