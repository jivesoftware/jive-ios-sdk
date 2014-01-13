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

@end

@implementation JVEditingViewController

- (void)setDetailItem:(JivePost *)post
{
    if (_detailItem != post) {
        _detailItem = post;
        self.title = post.subject;
        self.titleField.text = post.subject;
        if (self.instance.platformVersion.supportsContentEditingAPI) {
            [self.instance getEditableContent:post
                                  withOptions:nil
                                   onComplete:^(JiveContent *content) {
                                       self.titleField.text = content.subject;
                                       self.bodyField.text = content.content.text;
                                       [self.bodyField becomeFirstResponder];
                                   }
                                      onError:^(NSError *error) {
                                          [self.activityIndicator stopAnimating];
                                      }];
            [self.activityIndicator startAnimating];
        } else {
            self.bodyField.text = post.content.text;
            [self.bodyField becomeFirstResponder];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.detailItem) {
        JivePost *post = self.detailItem;
        
        self.title = post.subject;
        self.titleField.text = post.subject;
        self.bodyField.text = post.content.text;
    }
}

- (IBAction)savePressed:(id)sender {
    self.detailItem.subject = self.titleField.text;
    self.detailItem.content.text = self.bodyField.text;
    [self.instance updateContent:self.detailItem
                     withOptions:nil
                      onComplete:^(JiveContent *content) {
                          [self.activityIndicator stopAnimating];
                      }
                         onError:^(NSError *error) {
                             [self.activityIndicator stopAnimating];
                         }];
    [self.activityIndicator startAnimating];
}

@end
