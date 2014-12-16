//
//  MasterViewController.m
//  PandoraUI-Orange
//
//  Created by Valentin Filip on 10/23/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "BoardController.h"

#import "ADVTheme.h"

#import "DataSource.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "BoardDetailController.h"
#import "User+UserApi.h"
#import "Image+ImageApi.h"

@interface BoardController () {
    NSIndexPath *currentIndex;
}


@property (strong, nonatomic) NSArray *items;

@end




@implementation BoardController

#pragma mark - View lifecycle

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
    btnSearch.frame = CGRectMake(0, 0, 30, 30);
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    [btnSearch addTarget:self action:@selector(onCameraButtonTouched:) forControlEvents:UIControlEventTouchDown];
    
    // NSLog(@"board controller == viewDidLoad");
    
    self.refreshControl = [[UIRefreshControl alloc] init];    
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    //self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    self.imageArray = [[NSMutableArray alloc] init];
    self.photo = [[Image alloc] init];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (IBAction)onRefresh:(id)sender
{
    self.photo.delegate = self;
    
    AppConfig *config = [AppConfig getInstance];
    NSString *token = config.token;
    
    self.photo.delegateType = @"image.latest";
    [self.photo fetchLatest:self.imageArray Token:token];

}

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.photo.delegate = self;
    
    AppConfig *config = [AppConfig getInstance];
    NSString *token = config.token;
    
    self.photo.delegateType = @"image.latest";
    [self.photo fetchLatest:self.imageArray Token:token];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

// upload

- (IBAction)onCameraButtonTouched:(id)sender
{
    // NSLog(@"camera");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"upload" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"upload_home"];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)onActionButtonTouched:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    Image *photo = [self.imageArray objectAtIndex:button.tag];
    self.currentPhoto = photo;
    UIActionSheet *sheet;
    
    if (self.currentPhoto.isTracking == 0) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Track" otherButtonTitles:@"Brand", @"Hide it", @"block photos from this user", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Tracking" otherButtonTitles:@"Brand", @"Hide it", @"block photos from this user", nil];
    }
    
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    // NSLog(@"%d", buttonIndex);
    
    User* user = [User getInstance];
    
    if (buttonIndex == 0) {
        
        if (self.currentPhoto.isTracking == 1) {
            
            
        } else {
            
            NSDictionary *values = @{@"user_followed_uuid":self.currentPhoto.userUUID, @"user_following_uuid":user.userUUID};
            user.delegate = nil;
            [user addFollow:values Token:@""];
            self.currentPhoto.isTracking = 1;
            
        }
    }
    
    if (buttonIndex == 1) {
        
        self.currentPhoto.brandIt = 1;
        
        //NSDictionary *values = @{@"image_uuid":self.currentPhoto.imageUUID, @"user_uuid":user.userUUID};
        //[self.photo addBrander:values Token:@""];
        
        [self.tableView reloadData];
    }
    
    // @todo 09.17
    
    if (buttonIndex == 2) {
        
        // hide it
        
        User *user = [User getInstance];
        NSString *token;
        NSDictionary *values = @{@"user_uuid":user.userUUID, @"image_uuid":self.currentPhoto.imageUUID};
        
        // NSLog(@"%@", values);
        
        user.delegate = nil;
        [user excludeImage:values Token:token];
        [self.imageArray removeObject:self.currentPhoto];
        [self.tableView reloadData];
    }
    
    if (buttonIndex == 3) {
        
        
        User *user = [User getInstance];
        
        if ([user.userUUID isEqualToString:self.currentPhoto.userUUID]) {
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to block this user?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        
        [alert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    // NSLog(@"ALERT %d", buttonIndex);
    
    if (buttonIndex == 1) {
        
        User *user = [User getInstance];
        user.delegate = self;
        user.delegateType = @"block_user";
        
        NSDictionary *values = @{@"user_uuid":user.userUUID, @"user_block_uuid":self.currentPhoto.userUUID};
        [user addBlock:values Token:@""];
    }
    
}

- (BOOL)onCallback:(NSInteger)type
{
    // NSLog(@"returned");
    
    User *user = [User getInstance];
    
    if ([user.delegateType isEqualToString:@"block_user"]) {
        
        user.delegateType = @"";
        self.photo.delegate = self;
        
        AppConfig *config = [AppConfig getInstance];
        NSString *token = config.token;
        
        self.photo.delegateType = @"image.latest";
        [self.photo fetchLatest:self.imageArray Token:token];
        
        return YES;
    }
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    return YES;
}

#pragma mark - StoreCell delegate

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


#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1 + [self.imageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        BoardThemeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeCell"];
        
        CGRect tableRect = cell.imageVBkg.frame;
        tableRect.origin.y = 0;
        cell.imageVBkg.frame = tableRect;
        [cell setData:@{}];
        
        return cell;
    }
    
    NSString *CellIdentifier = @"StoreCell";
    BoardItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Image *photo = [self.imageArray objectAtIndex:indexPath.row - 1];
    
    cell.delegate = self;
    cell.photo = photo;
    
    CGRect tableRect = cell.imageVBkg.frame;
    tableRect.origin.y = 0;
    cell.imageVBkg.frame = tableRect;
    [cell setData:@{}];
    
    [cell.btnAction addTarget:self action:@selector(onActionButtonTouched:) forControlEvents:UIControlEventTouchDown];
    cell.btnAction.tag = indexPath.row - 1;
    
    User *user = [User getInstance];
    
    if ([photo.userUUID isEqualToString:user.userUUID]) {
        [cell.btnAction setEnabled:NO];
        [cell.btnAction setHidden:YES];
    } else {
        [cell.btnAction setEnabled:YES];
        [cell.btnAction setHidden:NO];
    }
    
    if (photo.brandIt == 1) {
        [cell onBrandButtonTouched];
        photo.brandIt = 0;
        photo.enableBrandIt = 0;
    }
    
    if (photo.name == nil || [[photo.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
        [cell.labelTitle setHidden:YES];
        
    } else {
    
        [cell.labelTitle setHidden:NO];
        [cell.labelTitle setText:photo.name];
        cell.labelTitle.frame = CGRectMake(40, 280 * photo.height / photo.width + 240 - 185 - 18, 280, 21);
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.imageArray count] <= 0) {
        return 0;
    }
    
    if (indexPath.row == 0) {
        return 44;
    }
    
    Image *photo = [self.imageArray objectAtIndex:indexPath.row - 1];
    NSInteger height = 280 * photo.height / photo.width;
    
    if (photo.name == nil || [[photo.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return height + 240 - 185;
    }
    
    return height + 240 - 185 + 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        return;
    }
    
    currentIndex = indexPath;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    BoardDetailController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"home_detail"];
    
    Image *photo = [self.imageArray objectAtIndex:currentIndex.row - 1];
    detailVC.photo = photo;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //[self performSegueWithIdentifier:@"showDetail" sender:self];
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
