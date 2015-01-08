//
//  JVEditingViewController.h
//  Example
//
//  Created by Orson Bushnell on 1/10/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Jive;
@class JiveContent;

@interface JVEditingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *bodyField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (strong, nonatomic) Jive *instance;
@property (strong, nonatomic) JiveContent *content;

- (IBAction)savePressed:(id)sender;

@end
