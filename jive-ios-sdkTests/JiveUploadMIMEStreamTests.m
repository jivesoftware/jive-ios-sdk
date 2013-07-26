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

@interface JiveUploadMIMEStreamTests ()

@end

const int bufferSize = 256;
const int longBufferSize = 1024;

@implementation JiveUploadMIMEStreamTests

- (void)setUp {
    self.stream = [JiveUploadMIMEStream new];
}

- (void)tearDown {
    [self.stream close];
    self.stream = nil;
}

- (void)testSimpleUse {
    NSString *dummyJSON = @"Invalid JSON data";
    NSString *testResult = [NSString stringWithFormat:@"--0xJiveBoundary\r\n"
                            @"Content-Disposition: form-data; name=\"content\"\r\n"
                            @"Content-Type: application/json; charset=UTF-8\r\n\r\n"
                            @"%@\r\n--0xJiveBoundary\r\n", dummyJSON];
    
    STAssertFalse(self.stream.hasBytesAvailable, @"An empty stream should not have bytes available");
    
    self.stream.JSONBody = [dummyJSON dataUsingEncoding:NSUTF8StringEncoding];
    [self.stream open];
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    
    uint8_t buffer[bufferSize] = { 0 };
    NSUInteger readBytes = (NSUInteger)[self.stream read:buffer maxLength:bufferSize];
    
    STAssertEquals(readBytes, testResult.length, @"The wrong number of bytes were read");
    while (readBytes-- > 0) {
        STAssertEquals(buffer[readBytes],
                       (uint8_t)[testResult characterAtIndex:readBytes],
                       @"The buffer was not filled correctly");
    }
    
    STAssertFalse(self.stream.hasBytesAvailable, @"Once read, a stream should not have bytes available");
}

- (void)testSimpleUseWithLongData {
    NSString *dummyJSON = @"This is a really long invalid JSON data block, part 1."
    @"This is a really long invalid JSON data block, part 2."
    @"This is a really long invalid JSON data block, part 3."
    @"This is a really long invalid JSON data block, part 4."
    @"This is a really long invalid JSON data block, part 5."
    @"This is a really long invalid JSON data block, part 6.";
    NSString *testResult = [NSString stringWithFormat:@"--0xJiveBoundary\r\n"
                            @"Content-Disposition: form-data; name=\"content\"\r\n"
                            @"Content-Type: application/json; charset=UTF-8\r\n\r\n"
                            @"%@\r\n--0xJiveBoundary\r\n", dummyJSON];
    
    STAssertFalse(self.stream.hasBytesAvailable, @"An empty stream should not have bytes available");
    
    self.stream.JSONBody = [dummyJSON dataUsingEncoding:NSUTF8StringEncoding];
    [self.stream open];
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    
    uint8_t buffer[bufferSize] = { 0 };
    NSUInteger readBytes = (NSUInteger)[self.stream read:buffer maxLength:bufferSize];
    
    STAssertEquals(readBytes, (NSUInteger)bufferSize, @"The wrong number of bytes were read");
    while (readBytes-- > 0) {
        STAssertEquals(buffer[readBytes],
                       (uint8_t)[testResult characterAtIndex:readBytes],
                       @"The buffer was not filled correctly");
    }
    
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    
    readBytes = (NSUInteger)[self.stream read:buffer maxLength:bufferSize];
    STAssertTrue(readBytes > 0, @"There should have been some bytes read");
    STAssertEquals(readBytes, (NSUInteger)(testResult.length - bufferSize), @"The wrong number of bytes were read");
    while (readBytes-- > 0) {
        STAssertEquals(buffer[readBytes],
                       (uint8_t)[testResult characterAtIndex:readBytes + bufferSize],
                       @"The buffer was not filled correctly");
    }
    
    STAssertFalse(self.stream.hasBytesAvailable, @"Once read, a stream should not have bytes available");
}

- (void)testSimpleUseWithPreBoundaryLengthEqualToBufferSize {
    NSString *dummyJSON = @"This is a really long invalid JSON data block, part 1."
    @"This is a really long invalid JSON data block, part 2."
    @"This is a really long invalid JSO";
    NSString *testResult = [NSString stringWithFormat:@"--0xJiveBoundary\r\n"
                            @"Content-Disposition: form-data; name=\"content\"\r\n"
                            @"Content-Type: application/json; charset=UTF-8\r\n\r\n"
                            @"%@\r\n--0xJiveBoundary\r\n", dummyJSON];
    
    STAssertFalse(self.stream.hasBytesAvailable, @"An empty stream should not have bytes available");
    
    self.stream.JSONBody = [dummyJSON dataUsingEncoding:NSUTF8StringEncoding];
    [self.stream open];
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    
    uint8_t buffer[bufferSize] = { 0 };
    NSUInteger readBytes = (NSUInteger)[self.stream read:buffer maxLength:bufferSize];
    
    STAssertEquals(readBytes, (NSUInteger)bufferSize, @"The wrong number of bytes were read");
    while (readBytes-- > 0) {
        STAssertEquals(buffer[readBytes],
                       (uint8_t)[testResult characterAtIndex:readBytes],
                       @"The buffer was not filled correctly");
    }
    
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    
    readBytes = (NSUInteger)[self.stream read:buffer maxLength:bufferSize];
    STAssertTrue(readBytes > 0, @"There should have been some bytes read");
    STAssertEquals(readBytes, (NSUInteger)(testResult.length - bufferSize), @"The wrong number of bytes were read");
    while (readBytes-- > 0) {
        STAssertEquals(buffer[readBytes],
                       (uint8_t)[testResult characterAtIndex:readBytes + bufferSize],
                       @"The buffer was not filled correctly");
    }
    
    STAssertFalse(self.stream.hasBytesAvailable, @"Once read, a stream should not have bytes available");
}

- (void)testShortFile {
    NSString *dummyJSON = @"Invalid JSON data";
    JiveAttachment *firstFile = [JiveAttachment new];
    NSString *fileName = @"filterable_fields";
    NSString *extension = @"json";
    NSString *contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName
                                                                             ofType:extension];
    
    firstFile.name = contentPath.lastPathComponent;
    firstFile.url = [NSURL URLWithString:contentPath];
    
    NSString *fileContents = [NSString stringWithContentsOfURL:firstFile.url
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
    NSString *testResult = [NSString stringWithFormat:@"--0xJiveBoundary\r\n"
                            @"Content-Disposition: form-data; name=\"content\"\r\n"
                            @"Content-Type: application/json; charset=UTF-8\r\n\r\n"
                            @"%@\r\n--0xJiveBoundary\r\n"
                            @"Content-Disposition: form-data; name=\"%@.%@\"; filename=\"%@.%@\"\r\n"
                            @"Content-Type: application/json\r\n\r\n"
                            @"%@\r\n--0xJiveBoundary\r\n",
                            dummyJSON, fileName, extension, fileName, extension, fileContents];
    
    [firstFile setValue:[NSNumber numberWithUnsignedInteger:fileContents.length] forKey:@"size"];
    STAssertFalse(self.stream.hasBytesAvailable, @"An empty stream should not have bytes available");
    
    self.stream.JSONBody = [dummyJSON dataUsingEncoding:NSUTF8StringEncoding];
    self.stream.attachments = @[firstFile];
    STAssertFalse(self.stream.hasBytesAvailable, @"A closed stream should not have bytes available");

    [self.stream open];
    STAssertTrue(self.stream.hasBytesAvailable, @"A stream with JSON data should have bytes available");
    
    uint8_t buffer[longBufferSize] = { 0 };
    NSUInteger readBytes = (NSUInteger)[self.stream read:buffer maxLength:longBufferSize];
    
    STAssertEquals(readBytes, testResult.length, @"The wrong number of bytes were read");
    while (readBytes-- > 0) {
        STAssertEquals(buffer[readBytes],
                       (uint8_t)[testResult characterAtIndex:readBytes],
                       @"The buffer was not filled correctly");
    }
    
    STAssertFalse(self.stream.hasBytesAvailable, @"Once read, a stream should not have bytes available");
}

- (void)testFileError {
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
    STAssertNil(self.stream.streamError, @"Opening the stream should not cause the error");
    STAssertEquals(self.stream.streamStatus, NSStreamStatusOpen, @"Opening the stream should not report an error");
    
    readBytes = (NSUInteger)[self.stream read:buffer maxLength:longBufferSize];
    STAssertEquals(readBytes, errorFlag, @"An error was not returned");
    STAssertEqualObjects(self.stream.streamError, erroredInputStream.streamError, @"The wrong error was produced");
    STAssertEquals(self.stream.streamStatus, NSStreamStatusError, @"The error should be available");
    STAssertFalse(self.stream.hasBytesAvailable, @"Once errored out, a stream should not have bytes available");
}

@end
