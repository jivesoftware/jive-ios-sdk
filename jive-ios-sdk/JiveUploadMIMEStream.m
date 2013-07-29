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

struct JiveUploadMIMEStreamElements const JiveUploadMIMEStreamElements = {
    .boundary = @"0xJiveBoundary",
    .JSONType = @"application/json; charset=UTF-8",
    .boundaryFormat = @"\r\n--%@\r\n",
    .contentTypeFormat = @"Content-Type: %@\r\n\r\n",
    .dispositionFormat = @"--%@\r\nContent-Disposition: form-data; name=\"content\"\r\n",
    .fileDispositionFormat = @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n"
};

@interface JiveUploadMIMEStream () <NSStreamDelegate>

@property (nonatomic) NSInputStream *currentStream;
@property (nonatomic) NSInputStream *boundaryStream;
@property (nonatomic) NSInputStream *headerStream;
@property (nonatomic) NSInteger fileIndex;
@property (nonatomic) BOOL reading;
@property (weak, nonatomic) NSRunLoop *currentRunLoop;
@property (nonatomic) NSString *runLoopMode;

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

- (void)setCurrentStream:(NSInputStream *)currentStream {
    if (currentStream != _currentStream) {
        _currentStream.delegate = nil;
        [_currentStream close];
        [_currentStream removeFromRunLoop:self.currentRunLoop forMode:self.runLoopMode];
        _currentStream = currentStream;
        _currentStream.delegate = self;
        [_currentStream scheduleInRunLoop:self.currentRunLoop forMode:self.runLoopMode];
        [_currentStream open];
    }
}

- (void)open {
    NSMutableData *contentData = [NSMutableData new];
    
    [contentData appendData:[[NSString stringWithFormat:JiveUploadMIMEStreamElements.dispositionFormat,
                              JiveUploadMIMEStreamElements.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [contentData appendData:[[NSString stringWithFormat:JiveUploadMIMEStreamElements.contentTypeFormat,
                              JiveUploadMIMEStreamElements.JSONType] dataUsingEncoding:NSUTF8StringEncoding]];
    [contentData appendData:self.JSONBody];
    self.fileIndex = -1;
    self.reading = NO;
    self.currentStream = [[NSInputStream alloc] initWithData:contentData];
}

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
    [self.currentStream removeFromRunLoop:self.currentRunLoop forMode:self.runLoopMode];
    self.currentRunLoop = aRunLoop;
    self.runLoopMode = mode;
    [self.currentStream scheduleInRunLoop:aRunLoop forMode:mode];
}

- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
    [self.currentStream removeFromRunLoop:aRunLoop forMode:mode];
    self.currentRunLoop = nil;
}

- (void)close {
    self.currentStream = nil;
}

- (BOOL)hasBytesAvailable {
    return self.currentStream.hasBytesAvailable;
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len {
    return [self.currentStream read:buffer maxLength:len];
}

- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len {
    return [self.currentStream getBuffer:buffer length:len];
}

- (NSStreamStatus)streamStatus {
    return self.currentStream.streamStatus;
}

- (NSError *)streamError {
    return self.currentStream.streamError;
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            if (self.reading) {
                return;
            }
            
            self.reading = YES;
            break;
            
        case NSStreamEventEndEncountered:
            if (self.currentStream == self.headerStream) {
                self.currentStream = [NSInputStream inputStreamWithURL:[self.attachments[self.fileIndex] url]];
            } else if (self.currentStream != self.boundaryStream) {
                self.boundaryStream = nil; // Remove previous boundary stream as it is in an invalid state.
                self.currentStream = self.boundaryStream;
                ++self.fileIndex;
            } else if (self.fileIndex < (NSInteger)self.attachments.count) {
                NSMutableData *contentData = [NSMutableData new];
                JiveAttachment *file = self.attachments[(NSUInteger)self.fileIndex];
                
                [contentData appendData:[[NSString stringWithFormat:JiveUploadMIMEStreamElements.fileDispositionFormat,
                                          file.name, [file.url lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
                [contentData appendData:[[NSString stringWithFormat:JiveUploadMIMEStreamElements.contentTypeFormat,
                                          [[file.url pathExtension] mimeTypeFromExtension]] dataUsingEncoding:NSUTF8StringEncoding]];
                self.headerStream = [[NSInputStream alloc] initWithData:contentData];
                self.currentStream = self.headerStream;
            } else {
                self.reading = NO;
                break;
            }
            
            return;
            
        default:
            break;
    }
    
    [self.delegate stream:self handleEvent:eventCode];
}

@end
