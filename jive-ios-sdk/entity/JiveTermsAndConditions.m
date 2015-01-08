//
//  JiveTermsAndConditions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTermsAndConditions.h"

struct JiveTermsAndConditionsAttributes const JiveTermsAndConditionsAttributes = {
    .acceptanceRequired = @"acceptanceRequired",
    .text = @"text",
    .url = @"url",
};

@implementation JiveTermsAndConditions

@synthesize acceptanceRequired, text, url;

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.acceptanceRequired
                  forKey:JiveTermsAndConditionsAttributes.acceptanceRequired];
    [dictionary setValue:self.text forKey:JiveTermsAndConditionsAttributes.text];
    [dictionary setValue:self.url.absoluteString forKey:JiveTermsAndConditionsAttributes.url];
    
    return dictionary;
}

@end
