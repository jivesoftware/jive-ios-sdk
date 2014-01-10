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

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        JivePost *post = newDetailItem;
        _detailItem = newDetailItem;
        self.title = post.subject;
        self.titleField.text = post.subject;
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
    }
}

@end
