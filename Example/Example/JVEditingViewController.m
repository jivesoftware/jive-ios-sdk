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

@property (strong, nonatomic) NSTimer *autoSaveTimer;

@end

@implementation JVEditingViewController

- (void)getEditableVersion
{
    [self.instance getEditableContent:self.content
                          withOptions:nil
                           onComplete:^(JiveContent *updatedContent) {
                               self.titleField.text = updatedContent.subject;
                               self.bodyField.text = updatedContent.content.text;
                               [self.bodyField becomeFirstResponder];
                           }
                              onError:^(NSError *error) {
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
                                              const NSTimeInterval kFiveMinutes = 5 * 60;
                                              [self getEditableVersion];
                                              self.autoSaveTimer = [NSTimer scheduledTimerWithTimeInterval:kFiveMinutes
                                                                                                    target:self
                                                                                                  selector:@selector(autosave)
                                                                                                  userInfo:nil
                                                                                                   repeats:YES];
                                          }
                                             onError:^(NSError *error) {
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
    if (self.autoSaveTimer) {
        [self.autoSaveTimer invalidate];
        self.autoSaveTimer = nil;
        [self.instance deleteContentLock:self.content
                              onComplete:nil
                                 onError:nil];
    }
}

- (IBAction)savePressed:(id)sender {
    self.content.subject = self.titleField.text;
    self.content.content.text = self.bodyField.text;
    [self.instance updateContent:self.content
                     withOptions:nil
                      onComplete:^(JiveContent *content) {
                          [self.activityIndicator stopAnimating];
                      }
                         onError:^(NSError *error) {
                             [self.activityIndicator stopAnimating];
                         }];
    [self.activityIndicator startAnimating];
    [self.autoSaveTimer invalidate];
    self.autoSaveTimer = nil;
}

- (void)autosave {
    self.content.subject = self.titleField.text;
    self.content.content.text = self.bodyField.text;
    [self.instance autosaveContentWhileEditing:self.content
                                   withOptions:nil
                                    onComplete:nil
                                       onError:nil];
}

@end
