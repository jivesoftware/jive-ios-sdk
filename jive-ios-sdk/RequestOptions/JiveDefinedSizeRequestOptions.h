//
//  JiveDefinedSizeRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiveRequestOptions.h"

enum JiveImageSizeOption {
    JiveImageSizeOptionLargeImage,
    JiveImageSizeOptionMediumImage,
    JiveImageSizeOptionSmallImage
    };

@interface JiveDefinedSizeRequestOptions : NSObject<JiveRequestOptions>

@property (nonatomic) enum JiveImageSizeOption size; // Requested size, default is JiveImageSizeOptionLargeImage

- (NSString *)toQueryString;

@end
