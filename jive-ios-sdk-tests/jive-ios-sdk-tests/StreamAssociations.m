//
//  StreamAssociations.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 1/30/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//
#import "JiveTestCase.h"

@interface StreamAssociations : JiveTestCase

@end

@implementation StreamAssociations

- (void) testStreamAssociations{
    
JiveReturnFieldsRequestOptions *returnFieldOptions = [[JiveReturnFieldsRequestOptions alloc] init];

   [returnFieldOptions addField:@"jive"];
    
    [returnFieldOptions addField:@"followerCount"];
[returnFieldOptions addField:@"displayName"]; 
   
    
    __block JivePerson *returnedPerson = nil;
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 personByUserName:@"ios-sdk-testuser1"
                             withOptions:returnFieldOptions
         
            onComplete:^(JivePerson *results) {
                if (results!=nil)
                {returnedPerson = results;
                }
                else NSLog(@"nil");
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
   
    
    JiveReturnFieldsRequestOptions *returnFieldOptions2 = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [returnFieldOptions2 addField:@"id"];
    [returnFieldOptions2 addField:@"name"];
    [returnFieldOptions2 addField:@"source"];

    __block NSArray *returnedStreamsArray = nil;
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 streams:returnedPerson
                     withOptions:returnFieldOptions2
         
                     onComplete:^(NSArray *results) {
                        
                        returnedStreamsArray = results;
                        finishBlock2();
                     } onError:^(NSError *error) {
                         STFail([error localizedDescription]);
                         finishBlock2();
                     }];
    }];
    
    JiveStream *testCustomStream = nil;
    
    NSString *testStream = @"TestStream1";
    
    for (JiveStream *stream in returnedStreamsArray) {
       
        if ([stream.name isEqualToString:testStream])
        {
            testCustomStream = stream;
        }
    }
    


JiveAssociationsRequestOptions *streamAssociationOptions = [[JiveAssociationsRequestOptions alloc] init];

[streamAssociationOptions addField:@"id"];
[streamAssociationOptions addField:@"name"];
[streamAssociationOptions addField:@"source"];
    [streamAssociationOptions addField:@"displayName"];
    

__block NSArray *returnedAssociationsArray = nil;

[self waitForTimeout:^(dispatch_block_t finishBlock2) {
    [jive1 streamAssociations:testCustomStream 
       withOptions:streamAssociationOptions
     
        onComplete:^(NSArray *results) {
            
            returnedAssociationsArray = results;
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
}];
    

for (JiveTypedObject* associationObj in returnedAssociationsArray) {
    
    if ([associationObj isKindOfClass:[JivePerson class]])
    {
        JivePerson* p= ((JivePerson*)(associationObj));
        NSLog(@"Person name=%@", p.displayName);
    }
    
}
 
}
@end
