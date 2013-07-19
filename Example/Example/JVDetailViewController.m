//
//  JVDetailViewController.m
//  Example
//
//  Created by Orson Bushnell on 7/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JVDetailViewController.h"
#import "JVBlogViewController.h"
#import <Jive/Jive.h>
#import "JVJiveFactory.h"

@interface JVDetailViewController ()

@property (strong, nonatomic) JVBlogViewController *tableViewController;
@property (strong, nonatomic) JiveBlog *blog;
@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation JVDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        JivePerson *person = newDetailItem;
        _detailItem = newDetailItem;
        self.title = person.displayName;
        [person blogWithOptions:nil
                     onComplete:^(JiveBlog *blog) {
                         self.blog = blog;
                     } onError:nil];
    }
}

- (void)setBlog:(JiveBlog *)blog {
    NSOperation *operation = [[JVJiveFactory jiveInstance] contentsOperationWithURL:blog.contentsRef
                                                                         onComplete:^(NSArray *contents) {
                                                                             [self.activityIndicator stopAnimating];
                                                                             self.tableViewController.contents = contents;
                                                                         } onError:nil];
    
    _blog = blog;
    self.title = blog.name;
    [self.operationQueue addOperation:operation];
    [self.activityIndicator startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.operationQueue = [NSOperationQueue new];
    self.tableViewController = [JVBlogViewController new];
    self.tableViewController.tableView = self.tableView;
}

@end
