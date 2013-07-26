//
//  JiveUploadMIMEStream.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 7/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveUploadMIMEStream.h"
#import "JiveAttachment.h"
#import "NSString+Jive.h"

struct JiveUploadMIMEStreamElements {
    __unsafe_unretained NSString *boundary;
    __unsafe_unretained NSString *JSONType;
    __unsafe_unretained NSString *boundaryFormat;
    __unsafe_unretained NSString *contentTypeFormat;
    __unsafe_unretained NSString *dispositionFormat;
    __unsafe_unretained NSString *fileDispositionFormat;
} const JiveUploadMIMEStreamElements;

struct JiveUploadMIMEStreamElements const JiveUploadMIMEStreamElements = {
    .boundary = @"0xJiveBoundary",
    .JSONType = @"application/json; charset=UTF-8",
    .boundaryFormat = @"\r\n--%@\r\n",
    .contentTypeFormat = @"Content-Type: %@\r\n\r\n",
    .dispositionFormat = @"--%@\r\nContent-Disposition: form-data; name=\"content\"\r\n",
    .fileDispositionFormat = @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n"
};

@interface JiveUploadMIMEStream ()

@property (nonatomic) NSInputStream *currentStream;
@property (nonatomic) NSInputStream *boundaryStream;
@property (nonatomic) NSInputStream *headerStream;
@property (nonatomic) NSInteger fileIndex;

@end

@implementation JiveUploadMIMEStream

- (NSInputStream *)boundaryStream {
    if (!_boundaryStream) {
        NSData *boundaryData = [[NSString stringWithFormat:JiveUploadMIMEStreamElements.boundaryFormat,
                                 JiveUploadMIMEStreamElements.boundary] dataUsingEncoding:NSUTF8StringEncoding];
        
        _boundaryStream = [[NSInputStream alloc] initWithData:boundaryData];
    }
    
    return _boundaryStream;
}

- (void)open {
    NSMutableData *contentData = [NSMutableData new];
    
    [contentData appendData:[[NSString stringWithFormat:JiveUploadMIMEStreamElements.dispositionFormat,
                              JiveUploadMIMEStreamElements.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [contentData appendData:[[NSString stringWithFormat:JiveUploadMIMEStreamElements.contentTypeFormat,
                              JiveUploadMIMEStreamElements.JSONType] dataUsingEncoding:NSUTF8StringEncoding]];
    [contentData appendData:self.JSONBody];
    self.currentStream = [[NSInputStream alloc] initWithData:contentData];
    [self.currentStream open];
    self.fileIndex = -1;
}

- (void)close {
    [self.currentStream close];
    self.currentStream = nil;
}

- (BOOL)hasBytesAvailable {
    return self.currentStream.hasBytesAvailable;
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len {
    NSInteger bytesRead = [self.currentStream read:buffer maxLength:len];
    const NSInteger readErrorFlag = -1;
    
    if (bytesRead != readErrorFlag) {
        while (!self.hasBytesAvailable && self.fileIndex < (NSInteger)self.attachments.count) {
            [self.currentStream close];
            if (self.currentStream == self.headerStream) {
                self.currentStream = [NSInputStream inputStreamWithURL:[self.attachments[self.fileIndex] url]];
            } else if (self.currentStream != self.boundaryStream) {
                self.currentStream = self.boundaryStream;
            } else {
                ++self.fileIndex;
                if (self.fileIndex >= (NSInteger)self.attachments.count) {
                    break;
                }
                
                NSMutableData *contentData = [NSMutableData new];
                JiveAttachment *file = self.attachments[(NSUInteger)self.fileIndex];
                
                [contentData appendData:[[NSString stringWithFormat:JiveUploadMIMEStreamElements.fileDispositionFormat,
                                          file.name, [file.url lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
                [contentData appendData:[[NSString stringWithFormat:JiveUploadMIMEStreamElements.contentTypeFormat,
                                          [[file.url pathExtension] mimeTypeFromExtension]] dataUsingEncoding:NSUTF8StringEncoding]];
                self.headerStream = [[NSInputStream alloc] initWithData:contentData];
                self.currentStream = self.headerStream;
            }
            
            [self.currentStream open];
            
            NSInteger moreBytesRead = [self.currentStream read:&buffer[bytesRead]
                                                     maxLength:len - (NSUInteger)bytesRead];
            
            if (moreBytesRead == readErrorFlag) {
                bytesRead = moreBytesRead;
                break;
            }
            
            bytesRead += moreBytesRead;
        }
    }
    
    return bytesRead;
}

- (NSStreamStatus)streamStatus {
    return self.currentStream.streamStatus;
}

- (NSError *)streamError {
    return self.currentStream.streamError;
}

//NSString *boundary = @"0xJiveBoundary";
//NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//NSMutableData *body = [NSMutableData data];
//NSData *boundaryData = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
//NSData *contentData = [NSJSONSerialization dataWithJSONObject:content.toJSONDictionary
//                                                      options:0
//                                                        error:nil];
//NSString * const typeFormat = @"Content-Type: %@\r\n\r\n";
//
//[request setValue:contentType forHTTPHeaderField: @"Content-Type"];
//
//[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//[body appendData:[@"Content-Disposition: form-data; name=\"content\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//[body appendData:[[NSString stringWithFormat:typeFormat, @"application/json; charset=UTF-8"] dataUsingEncoding:NSUTF8StringEncoding]];
//[body appendData:contentData];
//for (JiveAttachment *attachment in attachmentURLs) {
//    NSString *formDataString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
//                                attachment.name, [attachment.url lastPathComponent]];
//    NSString *fileTypeDataString = [NSString stringWithFormat:typeFormat, [[attachment.url pathExtension] mimeTypeFromExtension]];
//    
//    [body appendData:boundaryData];
//    [body appendData:[formDataString dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[fileTypeDataString dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithContentsOfURL:attachment.url]];
//}
//
//[body appendData:boundaryData];

@end
