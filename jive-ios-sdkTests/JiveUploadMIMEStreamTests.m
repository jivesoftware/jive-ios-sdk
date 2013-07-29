//
//  JiveUploadMIMEStreamTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 7/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveUploadMIMEStreamTests.h"
#import "JiveAttachment.h"
#import "NSString+Jive.h"

@interface UploadStreamDelegate : NSObject <NSStreamDelegate>

@property (strong, nonatomic) NSMutableData *readData;
@property (nonatomic) uint8_t *buffer;
@property (nonatomic) NSUInteger bufferSize;
@property (nonatomic) BOOL waiting;

-(void)runLoopUntilInputFinished;

@end

@interface JiveUploadMIMEStreamTests ()

@property (strong, nonatomic) UploadStreamDelegate *uploadDelegate;

@end

const int shortBufferSize = 256;
const int longBufferSize = 1024;

@implementation UploadStreamDelegate

- (void)setBufferSize:(NSUInteger)bufferSize {
    _bufferSize = bufferSize;
    if (self.buffer) {
        free(self.buffer);
        self.buffer = nil;
    }
    
    if (bufferSize > 0) {
        self.buffer = malloc(bufferSize);
    }
}

- (void)runLoopUntilInputFinished {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60];
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    self.waiting = YES;
    while (self.waiting) {
        [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:date];
    }
}

- (void)stream:(NSInputStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            NSUInteger bytesRead = (NSUInteger)[aStream read:self.buffer maxLength:self.bufferSize];
            
            if (bytesRead == (NSUInteger)(-1)) {
                self.waiting = NO;
            } else if (self.readData) {
                [self.readData appendBytes:self.buffer length:bytesRead];
            } else {
                self.readData = [NSMutableData dataWithBytes:self.buffer length:bytesRead];
            }
            break;
        }
            
        case NSStreamEventErrorOccurred:
        case NSStreamEventEndEncountered:
            self.waiting = NO;
            break;
            
        default:
            break;
    }
}

@end

@implementation JiveUploadMIMEStreamTests

- (void)setUp {
    self.stream = [JiveUploadMIMEStream new];
    [self.stream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
    self.uploadDelegate = [UploadStreamDelegate new];
    self.stream.delegate = self.uploadDelegate;
}

- (void)tearDown {
    [self.stream close];
    [self.stream removeFromRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
    self.stream = nil;
    self.uploadDelegate = nil;
}

- (void)testSimpleUse {
    self.uploadDelegate.bufferSize = shortBufferSize;
    
    NSString *dummyJSON = @"Invalid JSON data";
    NSData *testResult = [[NSString stringWithFormat:@"--0xJiveBoundary\r\n"
                           @"Content-Disposition: form-data; name=\"content\"\r\n"
                           @"Content-Type: application/json; charset=UTF-8\r\n\r\n"
                           @"%@\r\n--0xJiveBoundary\r\n", dummyJSON] dataUsingEncoding:NSUTF8StringEncoding];
    
    STAssertFalse(self.stream.hasBytesAvailable, @"An empty stream should not have bytes available");
    
    self.stream.JSONBody = [dummyJSON dataUsingEncoding:NSUTF8StringEncoding];
    [self.stream open];
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    STAssertNil(self.stream.streamError, @"Opening the stream should not report an error");
    STAssertEquals(self.stream.streamStatus, NSStreamStatusOpen, @"Wrong status after opening the stream");
    
    [self.uploadDelegate runLoopUntilInputFinished];
    STAssertEquals(self.uploadDelegate.readData.length, testResult.length, @"The wrong number of bytes were read");
    STAssertEqualObjects(self.uploadDelegate.readData, testResult, @"The wrong data was returned");
    STAssertFalse(self.stream.hasBytesAvailable, @"Once read, a stream should not have bytes available");
}

- (void)testSimpleUseWithLongData {
    self.uploadDelegate.bufferSize = shortBufferSize;
    
    NSString *dummyJSON = @"This is a really long invalid JSON data block, part 1."
    @"This is a really long invalid JSON data block, part 2."
    @"This is a really long invalid JSON data block, part 3."
    @"This is a really long invalid JSON data block, part 4."
    @"This is a really long invalid JSON data block, part 5."
    @"This is a really long invalid JSON data block, part 6.";
    NSData *testResult = [[NSString stringWithFormat:@"--0xJiveBoundary\r\n"
                           @"Content-Disposition: form-data; name=\"content\"\r\n"
                           @"Content-Type: application/json; charset=UTF-8\r\n\r\n"
                           @"%@\r\n--0xJiveBoundary\r\n", dummyJSON] dataUsingEncoding:NSUTF8StringEncoding];
    
    STAssertFalse(self.stream.hasBytesAvailable, @"An empty stream should not have bytes available");
    
    self.stream.JSONBody = [dummyJSON dataUsingEncoding:NSUTF8StringEncoding];
    [self.stream open];
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    STAssertNil(self.stream.streamError, @"Opening the stream should not report an error");
    STAssertEquals(self.stream.streamStatus, NSStreamStatusOpen, @"Wrong status after opening the stream");
    
    [self.uploadDelegate runLoopUntilInputFinished];
    STAssertEquals(self.uploadDelegate.readData.length, testResult.length, @"The wrong number of bytes were read");
    STAssertEqualObjects(self.uploadDelegate.readData, testResult, @"The wrong data was returned");
    STAssertFalse(self.stream.hasBytesAvailable, @"Once read, a stream should not have bytes available");
}

- (void)testSimpleUseWithPreBoundaryLengthEqualToBufferSize {
    self.uploadDelegate.bufferSize = shortBufferSize;
    
    NSString *dummyJSON = @"This is a really long invalid JSON data block, part 1."
    @"This is a really long invalid JSON data block, part 2."
    @"This is a really long invalid JSO";
    NSData *testResult = [[NSString stringWithFormat:@"--0xJiveBoundary\r\n"
                           @"Content-Disposition: form-data; name=\"content\"\r\n"
                           @"Content-Type: application/json; charset=UTF-8\r\n\r\n"
                           @"%@\r\n--0xJiveBoundary\r\n", dummyJSON] dataUsingEncoding:NSUTF8StringEncoding];
    
    STAssertFalse(self.stream.hasBytesAvailable, @"An empty stream should not have bytes available");
    
    self.stream.JSONBody = [dummyJSON dataUsingEncoding:NSUTF8StringEncoding];
    [self.stream open];
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    STAssertNil(self.stream.streamError, @"Opening the stream should not report an error");
    STAssertEquals(self.stream.streamStatus, NSStreamStatusOpen, @"Wrong status after opening the stream");
    
    [self.uploadDelegate runLoopUntilInputFinished];
    STAssertEquals(self.uploadDelegate.readData.length, testResult.length, @"The wrong number of bytes were read");
    STAssertEqualObjects(self.uploadDelegate.readData, testResult, @"The wrong data was returned");
    STAssertFalse(self.stream.hasBytesAvailable, @"Once read, a stream should not have bytes available");
}

- (void)testShortFile {
    self.uploadDelegate.bufferSize = longBufferSize;
    
    NSString *dummyJSON = @"Invalid JSON data";
    JiveAttachment *firstFile = [JiveAttachment new];
    NSString *fileName = @"filterable_fields";
    NSString *extension = @"json";
    NSString *contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName
                                                                             ofType:extension];
    
    firstFile.name = contentPath.lastPathComponent;
    firstFile.url = [NSURL fileURLWithPath:contentPath];
    
    NSString *fileContents = [NSString stringWithContentsOfURL:firstFile.url
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
    NSData *testResult = [[NSString stringWithFormat:@"--0xJiveBoundary\r\n"
                           @"Content-Disposition: form-data; name=\"content\"\r\n"
                           @"Content-Type: application/json; charset=UTF-8\r\n\r\n"
                           @"%@\r\n--0xJiveBoundary\r\n"
                           @"Content-Disposition: form-data; name=\"%@.%@\"; filename=\"%@.%@\"\r\n"
                           @"Content-Type: application/json\r\n\r\n"
                           @"%@\r\n--0xJiveBoundary\r\n",
                           dummyJSON, fileName, extension, fileName, extension, fileContents] dataUsingEncoding:NSUTF8StringEncoding];
    
    [firstFile setValue:[NSNumber numberWithUnsignedInteger:fileContents.length] forKey:@"size"];
    STAssertFalse(self.stream.hasBytesAvailable, @"An empty stream should not have bytes available");
    
    self.stream.JSONBody = [dummyJSON dataUsingEncoding:NSUTF8StringEncoding];
    self.stream.attachments = @[firstFile];
    STAssertFalse(self.stream.hasBytesAvailable, @"A closed stream should not have bytes available");

    [self.stream open];
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    STAssertNil(self.stream.streamError, @"Opening the stream should not report an error");
    STAssertEquals(self.stream.streamStatus, NSStreamStatusOpen, @"Wrong status after opening the stream");
    
    [self.uploadDelegate runLoopUntilInputFinished];
    STAssertEquals(self.uploadDelegate.readData.length, testResult.length, @"The wrong number of bytes were read");
    STAssertEqualObjects(self.uploadDelegate.readData, testResult, @"The wrong data was returned");
    STAssertFalse(self.stream.hasBytesAvailable, @"Once read, a stream should not have bytes available");
}

- (void)testFileError {
    self.uploadDelegate.bufferSize = longBufferSize;
    
    NSString *dummyJSON = @"Invalid JSON data";
    JiveAttachment *firstFile = [JiveAttachment new];
    NSString *fileName = @"filterable_fields";
    NSString *extension = @"json";
    NSString *contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName
                                                                             ofType:extension];
    
    firstFile.name = contentPath.lastPathComponent;
    firstFile.url = [NSURL URLWithString:[NSString stringWithFormat:@"file:/%@", contentPath]]; // Invalid file URL
    
    NSInputStream *erroredInputStream = [NSInputStream inputStreamWithURL:firstFile.url];
    
    [erroredInputStream open];
    
    uint8_t buffer[longBufferSize] = { 0 };
    NSUInteger readBytes = (NSUInteger)[erroredInputStream read:buffer maxLength:longBufferSize];
    const NSUInteger errorFlag = (NSUInteger)-1;
    
    STAssertEquals(readBytes, errorFlag, @"PRECONDITION: setup erroredInputStream failed");
    STAssertNotNil(erroredInputStream.streamError, @"PRECONDITION: setup erroredInputStream failed");
    STAssertEquals(erroredInputStream.streamStatus, NSStreamStatusError, @"PRECONDITION: setup erroredInputStream failed");
    
    [firstFile setValue:[NSNumber numberWithUnsignedInteger:100] forKey:@"size"];
    STAssertFalse(self.stream.hasBytesAvailable, @"An empty stream should not have bytes available");
    
    self.stream.JSONBody = [dummyJSON dataUsingEncoding:NSUTF8StringEncoding];
    self.stream.attachments = @[firstFile];
    STAssertFalse(self.stream.hasBytesAvailable, @"A closed stream should not have bytes available");
    STAssertEquals(self.stream.streamStatus, NSStreamStatusNotOpen, @"The stream status should be NSStreamStatusNotOpen");
    
    [self.stream open];
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    STAssertNil(self.stream.streamError, @"Opening the stream should not report an error");
    STAssertEquals(self.stream.streamStatus, NSStreamStatusOpen, @"Wrong status after opening the stream");
    
    [self.uploadDelegate runLoopUntilInputFinished];
    STAssertEquals(readBytes, errorFlag, @"An error was not returned");
    STAssertEqualObjects(self.stream.streamError, erroredInputStream.streamError, @"The wrong error was produced");
    STAssertEquals(self.stream.streamStatus, NSStreamStatusError, @"The error should be available");
    STAssertFalse(self.stream.hasBytesAvailable, @"Once errored out, a stream should not have bytes available");
}

@end
