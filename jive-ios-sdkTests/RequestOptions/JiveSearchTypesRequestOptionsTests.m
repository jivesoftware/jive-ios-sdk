//
//  JiveSearchTypesRequestOptionsTests.m
//  
//
//  Created by Orson Bushnell on 12/4/12.
//
//

#import "JiveSearchTypesRequestOptionsTests.h"

@implementation JiveSearchTypesRequestOptionsTests

- (JiveSearchTypesRequestOptions *)typesOptions {
    
    return (JiveSearchTypesRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveSearchTypesRequestOptions alloc] init];
}

- (void)testCollapse {
    
    self.typesOptions.collapse = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"collapse", asString, @"Wrong string contents");
}

- (void)testCollapseWithOtherFields {
    
    [self.typesOptions addField:@"name"];
    self.typesOptions.collapse = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&collapse", asString, @"Wrong string contents");
    
    [self.typesOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&collapse", asString, @"Wrong string contents");
}

- (void)testTypes {
    
    [self.typesOptions addType:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=type(dm)", asString, @"Wrong string contents");
    
    [self.typesOptions addType:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=type(dm,mention)", asString, @"Wrong string contents");
    
    [self.typesOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=type(dm,mention,share)", asString, @"Wrong string contents");
}

- (void)testTypeWithFields {
    
    [self.typesOptions addType:@"dm"];
    [self.typesOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=type(dm)", asString, @"Wrong string contents");
    
    [self.typesOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)", asString, @"Wrong string contents");
    
    self.typesOptions.collapse = YES;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&collapse", asString, @"Wrong string contents");
}

@end
