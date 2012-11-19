//
//  JiveAppDelegate.h
//  jive-rte
//
//  Created by Jacob Wright on 11/19/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JiveViewController;

@interface JiveAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JiveViewController *viewController;

@end
