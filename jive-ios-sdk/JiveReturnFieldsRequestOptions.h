//
//  JiveReturnFieldsRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiveRequestOptions.h"

@interface JiveReturnFieldsRequestOptions : NSObject<JiveRequestOptions>

@property (nonatomic, strong) NSString *field;

- (NSString *)optionsInURLFormat;

- (void)addField:(NSString *)newField;

@end
