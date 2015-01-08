//
//  QEStreamsTests.h
//  jive-ios-sdk-tests
//
//  Created by Sherry Zhou on 5/21/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"

@interface QEStreamsTests : JiveTestCase

- (JivePerson*) getPerson:(NSString*)username;
- (JiveStream*) findCustomStream:(NSString*)customStreamName person:(JivePerson*)person;
- (JiveStream*) createCustomStream:(NSString*)customStreamName person:(JivePerson*)person;
- (void) followPerson:(JivePerson*)person inStream:(JiveStream*)stream;

@end


