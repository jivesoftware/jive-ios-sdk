//
//  JiveError.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/28/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveError.h"

@implementation JiveError

- (id)initWithNSError:(NSError *)originalError withJSON:(NSDictionary *)json {
    if (!json) {
        self = [super initWithDomain:originalError.domain
                                code:originalError.code
                            userInfo:originalError.userInfo];
    } else {
        NSMutableDictionary *modifiedUserInfo = [originalError.userInfo mutableCopy];
        NSDictionary *errorJSON = [json objectForKey:@"error"];
        
        [modifiedUserInfo setValue:[errorJSON objectForKey:@"message"]
                            forKey:NSLocalizedRecoverySuggestionErrorKey];
        self = [super initWithDomain:originalError.domain
                                code:originalError.code
                            userInfo:modifiedUserInfo];
        if (self) {
            _jiveStatus = [errorJSON objectForKey:@"status"];
        }
    }
    
    return self;
}

@end
