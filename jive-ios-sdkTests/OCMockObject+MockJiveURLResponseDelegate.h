//
//  OCMockObject+MockJiveURLProtocol.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "MockJiveURLProtocol.h"

@interface OCMockObject (MockJiveURLResponseDelegate2)

+ (id<MockJiveURLResponseDelegate2>)mockJiveURLResponseDelegate2;

- (void)expectResponseWithContentsOfJSONFileNamed:(NSString *)JSONFileName
                             bundledWithTestClass:(Class)testClass
                                forRequestWithURL:(NSURL *)URL;
- (void)expectNoResponseForRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL;
- (void)expectError:(NSError *)error forRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL;

@end
