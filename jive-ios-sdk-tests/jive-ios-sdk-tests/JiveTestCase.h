//
//  jive_ios_sdk_tests.h
//  jive-ios-sdk-tests
//
//  Created by Heath Borders on 1/17/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Jive/Jive.h>

typedef void (^JiveTestCaseAsyncFinishBlock)(void);
typedef void (^JiveTestCaseAsyncBlock)(JiveTestCaseAsyncFinishBlock finishBlock);

extern NSString * const JiveTestCaseNotAJiveObjectKey;

@interface NSArray (JiveTestCase)

- (NSArray *) arrayOfJiveObjectJSONDictionaries;

@end

@interface JiveTestCase : SenTestCase {
    Jive *jive1;
    Jive *jive2;
    Jive *jive3;
    
    NSString* server;
    NSString* userid1;
    NSString* pw1;
    NSString* userid2;
    NSString* pw2;
    NSString* userid3;
    NSString* pw3;
}

- (void)waitForTimeout:(JiveTestCaseAsyncBlock)asynchBlock;
- (void)unexpectedErrorInWaitForTimeOut:(NSError *)error
                            finishBlock:(JiveTestCaseAsyncFinishBlock)finishBlock;
- (void)runOperation:(NSOperation *)operation;

@end
