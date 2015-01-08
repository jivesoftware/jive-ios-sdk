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
#import "JVEditingViewController.h"

@interface JVDetailViewController ()

@property (strong, nonatomic) JVBlogViewController *tableViewController;
@property (strong, nonatomic) JiveBlog *blog;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSArray *blogPosts;
@property (strong, nonatomic) NSArray *authoredDocuments;

@end

@implementation JVDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(JivePerson *)person
{
    if (_detailItem != person) {
        _detailItem = person;
        self.title = person.displayName;
        [self.activityIndicator startAnimating];
        [person blogWithOptions:nil
                     onComplete:^(JiveBlog *blog) {
                         self.blog = blog;
                     }
                        onError:^(NSError *error) {
                            [self.activityIndicator stopAnimating];
                            NSLog(@"%@", error);
                        }];
    }
}

- (void)setBlog:(JiveBlog *)blog {
    Jive *jive = ((JivePerson *)self.detailItem).jiveInstance;
    NSOperation *operation = [jive contentsOperationWithURL:blog.contentsRef
                                                 onComplete:^(NSArray *contents) {
                                                     [self.activityIndicator stopAnimating];
                                                     self.blogPosts = contents;
                                                     if (self.tabBar.selectedItem.tag == 0) {
                                                         self.tableViewController.contents = contents;
                                                     }
                                                 }
                                                    onError:^(NSError *error) {
                                                        [self.activityIndicator stopAnimating];
                                                    }];
    
    _blog = blog;
    self.title = blog.name;
    [self.operationQueue addOperation:operation];
    
    JiveContentRequestOptions *authoredContentOptions = [JiveContentRequestOptions new];
    
    [authoredContentOptions addAuthor:self.detailItem.selfRef];
    [authoredContentOptions addType:JiveDocumentType];
    operation = [jive contentsOperation:authoredContentOptions
                             onComplete:^(NSArray *authoredDocuments) {
                                 self.authoredDocuments = authoredDocuments;
                                 if (self.tabBar.selectedItem.tag == 1) {
                                     self.tableViewController.contents = authoredDocuments;
                                 }
                             }
                                onError:nil];
    [self.operationQueue addOperation:operation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.operationQueue = [NSOperationQueue new];
    self.operationQueue.maxConcurrentOperationCount = 1;
    self.tableViewController = [JVBlogViewController new];
    self.tableViewController.tableView = self.tableView;
    [self.activityIndicator startAnimating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"beginEditing"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        JiveContent *object = self.tableViewController.contents[indexPath.row];
        JVEditingViewController *editingViewController = [segue destinationViewController];
        
        editingViewController.instance = self.detailItem.jiveInstance;
        editingViewController.content = object;
    }
}

#pragma mark UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    switch (item.tag) {
        case 0:
            self.tableViewController.contents = self.blogPosts;
            break;
            
        case 1:
            self.tableViewController.contents = self.authoredDocuments;
            break;
            
        default:
            self.tableViewController.contents = nil;
            break;
    }
}

@end
