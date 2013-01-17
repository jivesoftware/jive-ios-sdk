//
//  JiveSearchRequestOptionsTests.m
//  
//
//  Created by Orson Bushnell on 12/4/12.
//
//

#import "JiveSearchRequestOptionsTests.h"

@implementation JiveSearchRequestOptionsTests

- (JiveSearchRequestOptions *)searchOptions {
    
    return (JiveSearchRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveSearchRequestOptions alloc] init];
}

- (void)testSearch {
    
    [self.searchOptions addSearchTerm:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=search(dm)", asString, @"Wrong string contents");
    
    [self.searchOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=search(dm,mention)", asString, @"Wrong string contents");
    
    [self.searchOptions addSearchTerm:@"share"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=search(dm,mention,share)", asString, @"Wrong string contents");
    
    [self.searchOptions addSearchTerm:@"h)e(j,m"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=search(dm,mention,share,h%29e%28j%2Cm)", asString, @"Wrong string contents");
}

- (void)testSearchWithFields {
    
    [self.searchOptions addSearchTerm:@"dm"];
    [self.searchOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=search(dm)", asString, @"Wrong string contents");
}

@end
