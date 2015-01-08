//
//  JVDetailViewController.h
//  Example
//
//  Created by Orson Bushnell on 7/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JivePerson;

@interface JVDetailViewController : UIViewController <UITabBarDelegate>

@property (strong, nonatomic) JivePerson *detailItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end
