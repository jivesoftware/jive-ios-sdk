//
//  JiveUploadMIMEStream.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 7/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

struct JiveUploadMIMEStreamElements {
    __unsafe_unretained NSString *boundary;
    __unsafe_unretained NSString *JSONType;
    __unsafe_unretained NSString *boundaryFormat;
    __unsafe_unretained NSString *contentTypeFormat;
    __unsafe_unretained NSString *dispositionFormat;
    __unsafe_unretained NSString *fileDispositionFormat;
} const JiveUploadMIMEStreamElements;

@interface JiveUploadMIMEStream : NSInputStream

@property (weak, nonatomic) id<NSStreamDelegate> delegate;
@property (copy, nonatomic) NSData *JSONBody; // The JSON portion of the MIME stream
@property (copy, nonatomic) NSArray *attachments; // The JiveAttachments to be uploaded

@end
