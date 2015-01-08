//
//  JivePlacesRequestOptionsTests.m
//  
//
//  Created by Orson Bushnell on 12/19/12.
//
//

#import "JivePlacesRequestOptionsTests.h"

@implementation JivePlacesRequestOptionsTests

- (JivePlacesRequestOptions *)placesOptions {
    
    return (JivePlacesRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JivePlacesRequestOptions alloc] init];
}

- (void)testEntityDescriptor {
    
    [self.placesOptions addEntityType:@"102" descriptor:@"1234"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=entityDescriptor(102,1234)", asString, @"Wrong string contents");
    
    [self.placesOptions addEntityType:@"37" descriptor:@"2345"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=entityDescriptor(102,1234,37,2345)", asString, @"Wrong string contents");
}

- (void)testEntityDescriptorWithOtherOptions {
    
    [self.placesOptions addEntityType:@"37" descriptor:@"2345"];
    [self.placesOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=entityDescriptor(37,2345)", asString, @"Wrong string contents");
    
    [self.placesOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=entityDescriptor(37,2345)", asString, @"Wrong string contents");
}

@end
