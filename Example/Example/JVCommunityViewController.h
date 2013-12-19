//
//  JVCommunityViewController.h
//  Example
//
//  Created by Orson Bushnell on 12/17/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCommunityViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *communityURL;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
