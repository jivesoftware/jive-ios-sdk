//
//  JiveReturnFieldsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveReturnFieldsRequestOptions.h"

@implementation JiveReturnFieldsRequestOptions

@synthesize field;

- (NSString *)optionsInURLFormat
{
    return field ? [NSString stringWithFormat:@"fields=%@", field] : @"";
}

- (void)addField:(NSString *)newField
{
    field = newField;
}

@end
