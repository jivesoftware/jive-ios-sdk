//
//  JVEditingViewController.m
//  Example
//
//  Created by Orson Bushnell on 1/10/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JVEditingViewController.h"
#import <Jive/Jive.h>

@interface JVEditingViewController ()

@property (strong, nonatomic) NSTimer *refreshLockTimer;

@end

@implementation JVEditingViewController

- (void)showEditableText:(JiveContent *)updatedContent
{
    const NSTimeInterval kFiveMinutes = 5 * 60;
    
    self.titleField.text = updatedContent.subject;
    self.bodyField.text = updatedContent.content.text;
    [self.bodyField becomeFirstResponder];
    self.refreshLockTimer = [NSTimer scheduledTimerWithTimeInterval:kFiveMinutes
                                                          target:self
                                                        selector:@selector(refreshLock)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)getEditableVersion
{
    [self.instance getEditableContent:self.content
                          withOptions:nil
                           onComplete:^(JiveContent *updatedContent) {
                               [self showEditableText:updatedContent];
                           }
                              onError:^(NSError *error) {
                                  NSLog(@"getEditableContent failed %@", error);
                                  [self.activityIndicator stopAnimating];
                              }];
}

- (void)setContent:(JiveContent *)content
{
    if (_content != content) {
        _content = content;
        self.title = content.subject;
        self.titleField.text = content.subject;
        if (self.instance.platformVersion.supportsContentEditingAPI) {
            if ([content.type isEqualToString:JiveDocumentType]) {
                [self.instance lockContentForEditing:content
                                         withOptions:nil
                                          onComplete:^(JiveContent *lockedContent) {
                                              if (lockedContent.content.editableValue) {
                                                  [self showEditableText:lockedContent];
                                              } else {
                                                  [self getEditableVersion];
                                              }
                                          }
                                             onError:^(NSError *error) {
                                                 NSLog(@"initial lockContentForEditing failed %@", error);
                                                 [self.activityIndicator stopAnimating];
                                             }];
            } else {
                [self getEditableVersion];
            }
            [self.activityIndicator startAnimating];
        } else {
            self.bodyField.text = content.content.text;
            [self.bodyField becomeFirstResponder];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.content) {
        self.title = self.content.subject;
        self.titleField.text = self.content.subject;
        self.bodyField.text = self.content.content.text;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.refreshLockTimer) {
        [self.refreshLockTimer invalidate];
        self.refreshLockTimer = nil;
        if ([self.content.type isEqualToString:JiveDocumentType]) {
            [self.instance unlockContent:self.content
                              onComplete:^ {
                                  NSLog(@"unlockContent succeeded.");
                              }
                                 onError:^(NSError *error) {
                                     NSLog(@"unlockContent failed %@", error);
                                 }];
        }
    }
}

- (IBAction)savePressed:(id)sender {
    self.content.subject = self.titleField.text;
    self.content.content.text = self.bodyField.text;
    [self.instance saveContentWhileEditing:self.content
                               withOptions:nil
                                onComplete:^(JiveContent *content) {
                                    [self.activityIndicator stopAnimating];
                                }
                                   onError:^(NSError *error) {
                                       NSLog(@"saveContentWhileEditing failed %@", error);
                                       [self.activityIndicator stopAnimating];
                                   }];
    [self.activityIndicator startAnimating];
}

- (void)refreshLock {
    [self.instance lockContentForEditing:self.content
                             withOptions:nil
                              onComplete:^(JiveContent *content) {
                                  NSLog(@"lockContentForEditing complete? %@", content.content.editable);
                              }
                                 onError:^(NSError *error) {
                                     NSLog(@"lockContentForEditing error %@", error);
                                 }];
}

@end
