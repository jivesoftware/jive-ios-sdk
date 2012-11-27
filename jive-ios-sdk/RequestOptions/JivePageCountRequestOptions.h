//
//  JivePageCountRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveReturnFieldsRequestOptions.h"

@interface JivePageCountRequestOptions : JiveReturnFieldsRequestOptions

@property (nonatomic) int count; // Maximum number of results to be returned

@end
