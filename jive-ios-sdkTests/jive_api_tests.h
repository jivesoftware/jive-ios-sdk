//
//  jive_api_tests.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAPITestCase.h"
#import "Jive.h"

@interface jive_api_tests : JiveAPITestCase
{
    id mockJiveURLResponseDelegate;
    id mockJiveURLResponseDelegate2;
    id mockAuthDelegate;
    Jive *jive;
}

- (Jive *)createJiveAPIObjectWithResponse:(NSString *)resourceName andAuthDelegate:(id)authDelegate;
- (Jive *)createJiveAPIObjectWithResponse:(NSString *)resourceName;

@end
