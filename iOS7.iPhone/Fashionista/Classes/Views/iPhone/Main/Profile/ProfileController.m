//
//  OtherViewController.m
//  Metropolitan
//
//  Created by Valentin Filip on 12/22/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "ProfileController.h"
#import "ProfileDetailController.h"

#import "AppDelegate.h"
#import "ADVTheme.h"

#import "DataSource.h"
#import "AccountCell.h"
#import "TimelineCell.h"

#import "User.h"
#import "User+UserApi.h"

@interface ProfileController (){
    NSIndexPath *currentIndex;
}


@property (strong, nonatomic) NSDictionary *account;

@end



@implementation ProfileController

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    [ADVThemeManager customizeTimelineView:self.view];
    
    UIImageView *titleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];    self.navigationItem.titleView = titleImageV;
    
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
    
    [btnSearch addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    User *user = [User getInstance];
    
    // NSLog(@"user = %@", user.token);
    
    self.account = [DataSource userAccount];
    [self.account setValue:user.username forKey:@"name"];
    [self.account setValue:@"" forKey:@"followers"];
    [self.account setValue:@"" forKey:@"following"];
    
    [self.tableView reloadData];
    
    //==============================
    self.imageArray = [[NSMutableArray alloc] init];
    NSDictionary *values = @{@"user_uuid":user.userUUID};
    user.delegate = self;
    [user fetchImageList:self.imageArray Parameters:values Token:@""];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
}

- (IBAction)onRefresh:(id)sender
{
    User *user = [User getInstance];
    NSDictionary *values = @{@"user_uuid":user.userUUID};
    user.delegate = self;
    [user fetchImageList:self.imageArray Parameters:values Token:@""];
    
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

- (BOOL)onCallback:(NSInteger)type
{
    // NSLog(@"returned");
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!self.imageArray) {
        return 1;
    }
    return [self.imageArray count] + 1;
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
    // NSLog(@"%d", indexPath.row - 1);
    cell.photo = [self.imageArray objectAtIndex:indexPath.row - 1];
    
    NSDictionary *item = self.account[@"timeline"][0];
    cell.data = item;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return 195;
    }
    Image *photo = [self.imageArray objectAtIndex:indexPath.row - 1];
    NSInteger height = 280 * photo.height / photo.width;
    
    return height + 240 - 185;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndex = indexPath;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    ProfileDetailController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"home_detail3"];
    
    Image *photo = [self.imageArray objectAtIndex:currentIndex.row - 1];
    detailVC.photo = photo;
    detailVC.photoArray = self.imageArray;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
    }
}


@end
