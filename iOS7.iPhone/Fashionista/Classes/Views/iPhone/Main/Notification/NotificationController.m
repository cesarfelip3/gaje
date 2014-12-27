//
//  FollowingController.m
//  Gaje
//
//  Created by hello on 14-7-11.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "NotificationController.h"


#import "ADVTheme.h"

#import "DataSource.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "BoardDetailController.h"

#import "User+UserApi.h"

@interface NotificationController () {
    
    NSIndexPath *currentIndex;
}

@end

@implementation NotificationController

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
    btnSearch.frame = CGRectMake(0, 0, 40, 30);
    [btnSearch setImage:[UIImage imageNamed:@"navigation-btn-settings"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    [btnSearch addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    
    self.photo = [[Image alloc] init];
    self.followingArray = [[NSMutableArray alloc] init];
    self.updateDictionary = [[NSMutableDictionary alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    

    [self.tableView addSubview:self.refreshControl];
    
    
    
   
}

- (IBAction)onRefresh:(id)sender
{
    
    User *user = [User getInstance];
    user.delegate = self;
    
    [user getLatestUpdate:self.updateDictionary];
    
    //NSDictionary *values = @{@"user_uuid":user.userUUID};
    //[user fetchFollowingList:values ResultArray:self.followingArray Token:@""];
    
}

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    User *user = [User getInstance];
    user.delegate = self;
    
    [user getLatestUpdate:self.updateDictionary];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

// upload

- (IBAction)onCameraButtonTouched:(id)sender
{
    
}


- (BOOL)onCallback:(NSInteger)type
{
    // NSLog(@"returned");
    self.view.tag = 1;
    
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
    return [self.updateDictionary count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        return @"Line Dropped";
    }
    
    if (section == 1) {
        return @"Brands";
    }
    
    return @"Tracking";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = @"comments";
    
    if (section == 1) {
        key = @"branders";
    }
    
    if (section == 2) {
    
        key = @"followers";
    }
    
    return [[self.updateDictionary objectForKey:key] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"StoreCell";
    UpdateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        
        NSArray *commentArray = [self.updateDictionary objectForKey:@"comments"];
        
        Image *image = [commentArray objectAtIndex:indexPath.row];
        
        [cell.info setText:[NSString stringWithFormat:@"%@ dropped you a line", image.username]];
        
        NSString *url = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
        [cell loadImage:url fileName:image.usertoken];
        
        if (image.status == 1) {
            
            [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(2, 2);
        }
    }
    
    if (indexPath.section == 1) {
        
        NSArray *commentArray = [self.updateDictionary objectForKey:@"branders"];
        
        Image *image = [commentArray objectAtIndex:indexPath.row];
        
        [cell.info setText:[NSString stringWithFormat:@"%@ branded your photo.", image.username]];
        
        NSString *url = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
        [cell loadImage:url fileName:image.usertoken];
        
        if (image.status == 1) {
            
            [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(2, 2);
        }
        
    }
    
    if (indexPath.section == 2) {
        
        NSArray *followerArray = [self.updateDictionary objectForKey:@"followers"];
        
        User *follower = [followerArray objectAtIndex:indexPath.row];
        
        [cell.info setText:[NSString stringWithFormat:@"%@ is tracking you.", follower.username]];
        
        NSString *url = [NSString stringWithFormat:FB_PROFILE_ICON, follower.token];
        [cell loadImage:url fileName:follower.token];
        
    }
    
    //User *follower = [self.followingArray objectAtIndex:indexPath.row];
    
    //cell.follower = follower;
    
    //CGRect tableRect = cell.imageVBkg.frame;
    //tableRect.origin.y = 0;
    //cell.imageVBkg.frame = tableRect;
    //[cell setData];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentIndex = indexPath;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    BoardDetailController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"notification_detail"];
    NSString *key = @"comments";
    
    if (indexPath.section == 1) {
        key = @"branders";
    }
    
    if (indexPath.section == 2) {
        
        
        NSArray *followerArray = [self.updateDictionary objectForKey:@"followers"];
        
        User *follower = [followerArray objectAtIndex:indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        
        NotificationProfileController *vc = [storyboard instantiateViewControllerWithIdentifier:@"following_profile"];
        vc.user = follower;
        
        User *user = [User getInstance];
        
        NSDictionary *values = @{@"follower_uuid":follower.userUUID, @"user_uuid":user.userUUID, @"type":@"followers"};
        
        if ([values count] > 0) {
            
            [[User getInstance] markItRead:values];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    NSArray *commentArray = [self.updateDictionary objectForKey:key];
    
    Image *image = [commentArray objectAtIndex:indexPath.row];
    image.status = 1;
    
    detailVC.photo = image;
    
    NSDictionary *values;
    
    if ([key isEqualToString:@"comments"]) {
        values = @{@"uuid":image.commentUUID, @"image_uuid":image.imageUUID, @"type":@"comments"};
    }
    
    if ([key isEqualToString:@"branders"]) {
        values = @{@"uuid":image.branderUUID, @"image_uuid":image.imageUUID, @"type":@"branders"};
    }
    
    if ([values count] > 0) {
        
        //[[User getInstance] markItRead:values];
    }
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        BoardDetailController *detailVC = segue.destinationViewController;
        
        Image *photo = [self.followingArray objectAtIndex:currentIndex.row];
        detailVC.photo = photo;
    }
}

@end
