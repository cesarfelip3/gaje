//
//  OtherViewController.m
//  Metropolitan
//
//  Created by Valentin Filip on 12/22/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "AccountViewController.h"
#import "DetailViewController.h"

#import "AppDelegate.h"
#import "ADVTheme.h"

#import "DataSource.h"
#import "AccountCell.h"
#import "TimelineCell.h"


@interface AccountViewController (){
    NSIndexPath *currentIndex;
}


@property (strong, nonatomic) NSDictionary *account;

@end



@implementation AccountViewController

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    [ADVThemeManager customizeTimelineView:self.view];
    
    UIImageView *titleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
    self.navigationItem.titleView = titleImageV;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeMenu) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(0, 0, 40, 30);
        [menuButton setImage:[UIImage imageNamed:@"navigation-btn-menu"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    }
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 40, 30);
    [btnSearch setImage:[UIImage imageNamed:@"navigation-btn-settings"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    self.account = [DataSource userAccount];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.account[@"timeline"] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        NSString *CellIdentifier = @"AccountCell";
        AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.data = _account;
        
        return cell;
    }
    
    NSString *CellIdentifier = @"TimelineCell";
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    CGRect tableRect = cell.imageVBkg.frame;
    tableRect.origin.y = 0;
    cell.imageVBkg.frame = tableRect;
    
    NSDictionary *item = self.account[@"timeline"][indexPath.row-1];
    cell.data = item;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return 195;
    }
    return 240;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentIndex = indexPath;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        DetailViewController *detailVC = segue.destinationViewController;
        
        NSDictionary *item = self.account[@"timeline"][currentIndex.row-1];
        detailVC.item = item;
    }
}


@end
