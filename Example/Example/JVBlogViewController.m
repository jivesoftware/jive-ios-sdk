//
//  JVBlogViewController.m
//  Example
//
//  Created by Orson Bushnell on 7/19/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JVBlogViewController.h"
#import <Jive/Jive.h>

@interface JVBlogViewController ()

@end

@implementation JVBlogViewController

- (void)setTableView:(UITableView *)tableView {
    [super setTableView:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
}

- (void)setContents:(NSArray *)contents {
    _contents = contents;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Post";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    JivePost *post = self.contents[indexPath.row];
    
    cell.textLabel.text = post.subject;
    
    return cell;
}

@end
