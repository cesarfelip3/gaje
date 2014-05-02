//
//  SettingsViewController.m
//  
//
//  Created by Valentin Filip on 4/19/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "ADVTheme.h"
#import "NavigationSelectViewController.h"
#import "SettingCell.h"

#import "User.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ADVThemeManager customizeTableView:self.tableView];
    
    UIImageView *titleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
    self.navigationItem.titleView = titleImageV;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeMenu) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(0, 0, 40, 30);
        [menuButton setImage:[UIImage imageNamed:@"navigation-btn-menu"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    }
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
//    UIBarButtonItem* reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-btn-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
//    
//    self.navigationItem.leftBarButtonItem = reloadButton;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    [self.tableView reloadData];
}


- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

//==========================
//
//==========================
- (void) loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    
    NSLog(@"FB Login error");
    
}


- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"FB Login");
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    
    User *user = [User getInstance];
    [user logout];
    
    
    NSLog(@"FB Logout");
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.loginView.delegate = [AppDelegate sharedDelegate];
    [AppDelegate sharedDelegate].loginView = cell.loginView;
    
#if false
    
    cell.textLabel.text = @"Navigation Type";
    NSString *themeName;
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"]) {
        case ADVNavigationTypeMenu:
            themeName = @"Hidden Menu";
            break;
        case ADVNavigationTypeTab:
            themeName = @"Tabbar";
            break;
        default:
            break;
    }
    cell.detailTextLabel.text = themeName;
#endif
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //[self performSegueWithIdentifier:@"selectNavigationType" sender:self];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"selectNavigationType"] || [segue.identifier isEqualToString:@"selectNavigationTypeNoAnim"]) {
        
    }
}
@end
