//
//  JVCommunityViewController.m
//  Example
//
//  Created by Orson Bushnell on 12/17/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JVCommunityViewController.h"
#import <Jive/Jive.h>
#import "JVJiveFactory.h"

@implementation JVCommunityViewController

- (void)advanceToLogin:(JVJiveFactory *)factory {
    [self.activityIndicator stopAnimating];
    [JVJiveFactory setInstance:factory];
    [self performSegueWithIdentifier:@"Community" sender:self];
}

- (void)checkForRedirect:(JivePlatformVersion *)version
                 fromURL:(NSURL *)targetURL
                 factory:(JVJiveFactory *)initialFactory {
    // Not all instances report their url in the version.
    if (!version.instanceURL || [version.instanceURL isEqual:targetURL]) {
        [self advanceToLogin:initialFactory];
    } else {
        // Attempt to redirect to the server's instance url.
        __block JVJiveFactory *factory = nil;
        
        factory = [[JVJiveFactory alloc] initWithInstanceURL:version.instanceURL
                                                    complete:^(JivePlatformVersion *redirectVersion) {
                                                        // Direct access granted.
                                                        self.communityURL.text = redirectVersion.instanceURL.absoluteString;
                                                        [self advanceToLogin:factory];
                                                    }
                                                       error:^(NSError *error) {
                                                           // The server lied, bad server. Use the original url.
                                                           [self advanceToLogin:initialFactory];
                                                       }];
    }
}

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    self.communityURL.enabled = YES;
    [self.communityURL becomeFirstResponder];
    [super viewDidAppear:animated];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Assume the default instance.
    NSString *instanceString = @"https://community.jivesoftware.com/";
    
    // Check to see if the user entered a different url.
    if (self.communityURL.text.length > 0) {
        instanceString = self.communityURL.text;
        if (![instanceString hasPrefix:@"http"]) {
            instanceString = [@"http://" stringByAppendingString:instanceString];
            // But what if it should be https:// ?
        }
        
        // The SDK assumes the URL has a / at the end. So make sure it does.
        if (![instanceString hasSuffix:@"/"]) {
            instanceString = [instanceString stringByAppendingString:@"/"];
        }
    }
    
    NSURL *instanceURL = [NSURL URLWithString:instanceString];
    __block JVJiveFactory *factory = nil;
    
    [self.activityIndicator startAnimating];
    [self.communityURL resignFirstResponder];
    self.communityURL.enabled = NO;
    // Is it a valid instance?
    factory = [[JVJiveFactory alloc] initWithInstanceURL:instanceURL
                                                complete:^(JivePlatformVersion *version) {
                                                    [self checkForRedirect:version
                                                                   fromURL:instanceURL
                                                                   factory:factory];
                                                } error:^(NSError *error) {
                                                    [self.activityIndicator stopAnimating];
                                                    self.communityURL.enabled = YES;
                                                    [self.communityURL becomeFirstResponder];
                                                }];
    
    return NO;
}

@end
