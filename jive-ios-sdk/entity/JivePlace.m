//
//  JivePlace.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlace.h"

#import "JiveBlog.h"
#import "JiveGroup.h"
#import "JiveProject.h"
#import "JiveSpace.h"
#import "JiveSummary.h"

@implementation JivePlace

+ (Class) entityClass:(NSDictionary*) obj {
    NSString* type = [obj objectForKey:@"type"];
    if (type == @"blog") {
        return [JiveBlog class];
    } else if (type == @"group") {
        return [JiveGroup class];
    } else if (type == @"project") {
        return [JiveProject class];
    } else if (type == @"space") {
        return [JiveSpace class];
    } else {
        return [self class];
    }
}
@end
