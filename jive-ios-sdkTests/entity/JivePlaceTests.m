//
//  JivePlaceTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlaceTests.h"
#import "JivePlace.h"
#import "JiveBlog.h"
#import "JiveGroup.h"
#import "JiveProject.h"
#import "JiveSpace.h"

@implementation JivePlaceTests

- (void)testHandlePrimitivePropertyFromJSON {
    
    JivePlace *place = [[JivePlace alloc] init];
    
    STAssertFalse(place.visibleToExternalContributors, @"PRECONDITION: default is false");
    
    [place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanTrue];
    STAssertTrue(place.visibleToExternalContributors, @"Set to true");
    
    [place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanFalse];
    STAssertFalse(place.visibleToExternalContributors, @"Back to false");
}

- (void)testEntityClass {
    
    NSString *key = @"type";
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:@"blog" forKey:key];
    SEL selector = @selector(entityClass:);
    
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveBlog class], @"Blog");
    
    [typeSpecifier setValue:@"group" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveGroup class], @"Group");
    
    [typeSpecifier setValue:@"project" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveProject class], @"Project");
    
    [typeSpecifier setValue:@"space" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveSpace class], @"Space");
    
    [typeSpecifier setValue:@"random" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JivePlace class], @"Out of bounds");
    
    [typeSpecifier setValue:@"Not random" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JivePlace class], @"Different out of bounds");
}

@end
