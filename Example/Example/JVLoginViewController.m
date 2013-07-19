//
//  JVLoginViewController.m
//  Example
//
//  Created by Orson Bushnell on 7/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JVLoginViewController.h"
#import "JVJiveFactory.h"
#import <Jive/Jive.h>
#import "JVMasterViewController.h"

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
        [JVJiveFactory loginWithName:self.userName.text
                            password:self.password.text
                            complete:^(JivePerson *person) {
                                [self handleLogin:person];
                            } error:^(NSError *error) {
                                [self resetLoginView];
                                [self.password becomeFirstResponder];
                            }];
    }
    
    return NO;
}

#pragma mark - Private

- (void)handleLogin:(JivePerson *)person {
    [self performSegueWithIdentifier:@"Login" sender:self];
    ((JVMasterViewController *)self.navigationController.presentingViewController).me = person;
    [self resetLoginView];
}

- (void)resetLoginView {
    [self.activityIndicator stopAnimating];
    self.userName.enabled = YES;
    self.password.enabled = YES;
    self.password.text = nil;
}

@end
