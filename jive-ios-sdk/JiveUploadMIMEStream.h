//
//  JiveUploadMIMEStream.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 7/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiveUploadMIMEStream : NSInputStream

@property (copy, nonatomic) NSData *JSONBody; // The JSON portion of the MIME stream
@property (copy, nonatomic) NSArray *attachments; // The JiveAttachments to be uploaded

@end
