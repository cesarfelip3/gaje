//
//  FollowingController.m
//  Gaje
//
//  Created by hello on 14-7-11.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "FollowingController.h"


#import "ADVTheme.h"

#import "DataSource.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Detail2Controller.h"

@interface FollowingController () {
    
    NSIndexPath *currentIndex;
}

@end

@implementation FollowingController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]]];
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
    btnSearch.frame = CGRectMake(0, 0, 30, 30);
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    [btnSearch addTarget:self action:@selector(onCameraButtonTouched:) forControlEvents:UIControlEventTouchDown];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    NSLog(@"cmeara");
    
    self.photo = [[Image alloc] init];
    self.followerArray = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.tableView addSubview:self.refreshControl];
}

- (IBAction)onRefresh:(id)sender
{
    
    User *user = [User getInstance];
    user.delegate = self;
    
    NSDictionary *values = @{@"user_uuid":user.userUUID};
    [user fetchFollowingList:values ResultArray:self.followerArray Token:@""];
    
}

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    User *user = [User getInstance];
    user.delegate = self;
    
    NSDictionary *values = @{@"user_uuid":user.userUUID};
    [user fetchFollowingList:values ResultArray:self.followerArray Token:@""];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

// upload

- (IBAction)onCameraButtonTouched:(id)sender
{
    NSLog(@"camera");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"upload" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"upload_home"];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (BOOL)onCallback:(NSInteger)type
{
    NSLog(@"returned");
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    return YES;
}

#pragma mark - StoreCell delegate
#if false
- (void)cellDidToggleFavoriteState:(BoardItemCell *)cell forItem:(NSDictionary *)item {
    NSString* plistPath = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    if ((plistPath = [[[NSBundle mainBundle] bundlePath]
                      stringByAppendingPathComponent:@"Personal-Account.plist"]))
    {
        if ([manager isWritableFileAtPath:plistPath]) {
            NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            NSMutableArray *favorites = [infoDict[@"timeline"] mutableCopy];
            NSInteger position = [DataSource itemIsFavorite:item];
            if (position > -1) {
                [favorites removeObjectAtIndex:position];
            } else {
                [favorites addObject:item];
            }
            [infoDict setObject:favorites forKey:@"timeline"];
            [infoDict writeToFile:plistPath atomically:YES];
            [cell setNeedsLayout];
        }
    }
}
#endif

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.followerArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"StoreCell";
    FollowerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    User *follower = [self.followerArray objectAtIndex:indexPath.row];
    
    cell.follower = follower;
    
    CGRect tableRect = cell.imageVBkg.frame;
    tableRect.origin.y = 0;
    cell.imageVBkg.frame = tableRect;
    [cell setData];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentIndex = indexPath;
    
    
    User *follower = [self.followerArray objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    FollowingProfileController *vc = [storyboard instantiateViewControllerWithIdentifier:@"follower_profile"];
    vc.user = follower;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        Detail2Controller *detailVC = segue.destinationViewController;
        
        Image *photo = [self.followerArray objectAtIndex:currentIndex.row];
        detailVC.photo = photo;
    }
}

@end
