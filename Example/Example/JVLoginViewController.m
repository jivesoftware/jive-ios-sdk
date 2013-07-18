//
//  JVLoginViewController.m
//  Example
//
//  Created by Orson Bushnell on 7/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JVLoginViewController.h"
#import "JVAppDelegate.h"
#import <Jive/Jive.h>

@interface JVLoginViewController ()

@end

@implementation JVLoginViewController

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    self.password.text = nil;
    [self.userName becomeFirstResponder];
    [super viewDidAppear:animated];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userName) {
        [self.password becomeFirstResponder];
    } else if (self.userName.text.length == 0) {
        [self.userName becomeFirstResponder];
    } else if (self.password.text.length > 0) {
        [self.activityIndicator startAnimating];
        [self.password resignFirstResponder];
        self.userName.enabled = NO;
        self.password.enabled = NO;
    }
    
    return NO;
}

@end
