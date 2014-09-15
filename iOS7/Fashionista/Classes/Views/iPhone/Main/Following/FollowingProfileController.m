//
//  FollowingProfileController.m
//  Gaje
//
//  Created by hello on 14-7-12.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "FollowingProfileController.h"
#import "BoardDetailController.h"

#import "AppDelegate.h"
#import "ADVTheme.h"

#import "DataSource.h"
#import "AccountCell.h"
#import "TimelineCell.h"

#import "User.h"
#import "User+UserApi.h"

@interface FollowingProfileController (){
    NSIndexPath *currentIndex;
}


@property (strong, nonatomic) NSDictionary *account;
@end

@implementation FollowingProfileController

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    [ADVThemeManager customizeTimelineView:self.view];
    
    UIImageView *titleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
    self.navigationItem.titleView = titleImageV;
    
#if false
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

#endif    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    self.account = [DataSource userAccount];
    [self.account setValue:self.user.username forKey:@"name"];
    [self.account setValue:@"" forKey:@"followers"];
    [self.account setValue:@"" forKey:@"following"];
    
    [self.tableView reloadData];
    
    //==============================
    self.imageArray = [[NSMutableArray alloc] init];
    NSDictionary *values = @{@"user_uuid":self.user.userUUID};
    self.user.delegate = self;
    [self.user fetchImageList:self.imageArray Parameters:values Token:@""];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    self.isFollowing = YES;
}

- (IBAction)onRefresh:(id)sender
{
    User *user = [User getInstance];
    NSDictionary *values = @{@"user_uuid":self.user.userUUID};
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
    NSLog(@"returned");
    self.view.tag = 1;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    return YES;
}

- (IBAction)onFollowButtonTouched:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 0) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Unfollow" otherButtonTitles:nil];
        [sheet showInView:self.view];
    
    } else {
        
        User *user = [User getInstance];
        NSDictionary *values = @{@"user_followed_uuid":self.user.userUUID, @"user_following_uuid":user.userUUID};
        
        [self.user addFollow:values Token:@""];
    
        self.isFollowing = YES;
        [button setTitle:@"Tracking" forState:UIControlStateNormal];
        [self.tableView reloadData];
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        User *user = [User getInstance];
        NSDictionary *values = @{@"user_followed_uuid":self.user.userUUID, @"user_following_uuid":user.userUUID};
        
        [self.user removeFollow:values Token:@""];
        
        self.isFollowing = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!self.imageArray) {
        return 2;
    }
    return [self.imageArray count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath.row) {
        NSString *CellIdentifier = @"AccountCell";
        FollowerProfileItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.user = self.user;
        cell.data = _account;
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        FollowerProfileCommandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_command"];
        
        if (self.isFollowing) {
            cell.buttonFollow.tag = 0;
            [cell.buttonFollow setHidden:NO];
            [cell.buttonFollow setTitle:@"Tracking" forState:UIControlStateNormal];
        } else {
            cell.buttonFollow.tag = 1;
            [cell.buttonFollow setHidden:NO];
            [cell.buttonFollow setTitle:@"Track" forState:UIControlStateNormal];
        }
        
        
        [cell.buttonFollow addTarget:self action:@selector(onFollowButtonTouched:) forControlEvents:UIControlEventTouchDown];
        return cell;
        
    }
    
    NSString *CellIdentifier = @"TimelineCell";
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //CGRect tableRect = cell.imageVBkg.frame;
    //tableRect.origin.y = 0;
    //cell.imageVBkg.frame = tableRect;
    //NSLog(@"%d", indexPath.row - 1);
    cell.photo = [self.imageArray objectAtIndex:indexPath.row - 2];
    
    NSDictionary *item = self.account[@"timeline"][0];
    cell.data = item;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return 195;
    }
    
    if (indexPath.row == 1) {
        return 44;
    }
    
    Image *photo = [self.imageArray objectAtIndex:indexPath.row - 2];
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
    
    BoardDetailController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"home_detail2"];
    
    Image *photo = [self.imageArray objectAtIndex:currentIndex.row - 2];
    detailVC.photo = photo;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        BoardDetailController *detailVC = segue.destinationViewController;
        
        Image *photo = [self.imageArray objectAtIndex:currentIndex.row];
        detailVC.photo = photo;
    }
}


@end
