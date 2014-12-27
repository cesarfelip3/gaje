//
//  ThemeViewController.m
//  
//
//  Created by Valentin Filip on 4/19/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "NavigationSelectViewController.h"
#import "AppDelegate.h"
#import "ADVTheme.h"

#import "SettingsViewController.h"

@interface NavigationSelectViewController ()

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation NavigationSelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [ADVThemeManager customizeTableView:self.tableView];
    
    UIImageView *titleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
    self.navigationItem.titleView = titleImageV;
    
    self.currentIndex = [AppDelegate sharedDelegate].navigationType;
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case ADVNavigationTypeMenu:
            cell.textLabel.text = @"Hidden Menu";
            break;
        case ADVNavigationTypeTab:
            cell.textLabel.text = @"Tabbar";
            break;
        default:
            break;
    }
    
    if (indexPath.row == _currentIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    self.currentIndex = indexPath.row;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"NavigationType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [AppDelegate sharedDelegate].navigationType = indexPath.row;
    [[AppDelegate sharedDelegate] resetAfterTypeChange:NO];
}

@end
