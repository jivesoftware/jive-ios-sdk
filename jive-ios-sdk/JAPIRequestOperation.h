//
//  JAPIRequestOperation.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "AFJSONRequestOperation.h"

@interface JAPIRequestOperation : AFJSONRequestOperation

+ (JAPIRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                  success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                  failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
