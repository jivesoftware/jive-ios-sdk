//
//  JVMasterViewController.m
//  Example
//
//  Created by Orson Bushnell on 7/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JVMasterViewController.h"
#import "JVDetailViewController.h"
#import <Jive/Jive.h>
#import "JVPersonCell.h"

@interface JVMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation JVMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.me) {
        _objects = [@[self.me] mutableCopy];
        [self.me followingWithOptions:nil
                           onComplete:^(NSArray *objects) {
                               [self addFollowers:objects];
                           } onError:nil];
    }
}

- (void)addFollowers:(NSArray *)objects {
    [_objects addObjectsFromArray:objects];
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                         forIndexPath:indexPath];
    JivePerson *object = _objects[indexPath.row];
    
    cell.person = object;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        JivePerson *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
