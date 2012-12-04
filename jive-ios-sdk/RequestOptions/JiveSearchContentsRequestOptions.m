//
//  JiveSearchContentsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchContentsRequestOptions.h"

@implementation JiveSearchContentsRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = [super buildFilter];
    
    if (self.subjectOnly) {
        if (filter)
            filter = [filter stringByAppendingString:@",subjectonly"];
        else
            filter = @"subjectonly";
    }

    return filter;
}

@end
