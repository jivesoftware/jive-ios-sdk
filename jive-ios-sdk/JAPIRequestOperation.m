//
//  JAPIRequestOperation.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JAPIRequestOperation.h"

@implementation JAPIRequestOperation

+ (JAPIRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    JAPIRequestOperation *requestOperation = [[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(AFJSONRequestOperation *)operation responseJSON]);
        }
    }];
    
    return requestOperation;
}

- (id)responseJSON {
    
    // Handle cases where API call is to Jive, by removing "throw 'allowIllegalResourceCall is false.';"
    NSData* header = [@"throw 'allowIllegalResourceCall is false.'" dataUsingEncoding:NSUTF8StringEncoding];
    NSRange headerRange = [self.responseData rangeOfData:header options:0 range:NSMakeRange(0, header.length)];
    if(headerRange.location != NSNotFound) {
        NSData *cleanData = [self.responseData subdataWithRange:NSMakeRange(headerRange.length+1, self.responseData.length - headerRange.length - 1)];
        
        // Use KVO as a hack to set this property
        // make sure to avoid  +(BOOL) accessInstanceVariablesDirectly { return NO; } 
        [self setValue:cleanData forKey:@"responseData"];
    }

    return [super responseJSON];
    
}

@end
