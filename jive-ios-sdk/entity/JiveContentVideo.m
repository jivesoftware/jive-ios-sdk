//
//  JiveContentVideo.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 5/22/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveContentVideo.h"

struct JiveContentVideoAttributes const JiveContentVideoAttributes = {
    .height = @"height",
    .stillImageURL = @"stillImageURL",
    .videoSourceURL = @"videoSourceURL",
    .width = @"width",
};


@implementation JiveContentVideo

@synthesize height, width, stillImageURL, videoSourceURL;

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:width forKey:JiveContentVideoAttributes.width];
    [dictionary setValue:height forKey:JiveContentVideoAttributes.height];
    [dictionary setValue:[stillImageURL absoluteString] forKey:JiveContentVideoAttributes.stillImageURL];
    [dictionary setValue:[videoSourceURL absoluteString] forKey:JiveContentVideoAttributes.videoSourceURL];
    
    return dictionary;
}

@end
