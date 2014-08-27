//
//  UserSearchResultController.m
//  Gaje
//
//  Created by hello on 14-8-1.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "UserSearchResultController.h"



#import "ADVTheme.h"

#import "DataSource.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Detail2Controller.h"

@interface UserSearchResultController () {
    
    NSIndexPath *currentIndex;
}

@end

@implementation UserSearchResultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[ADVThemeManager customizeTimelineView:self.view];
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
    
    NSLog(@"cmeara");
    
    self.photo = [[Image alloc] init];
    self.resultArray = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.tableView addSubview:self.refreshControl];
}

- (IBAction)onRefresh:(id)sender
{
    
    User *user = [User getInstance];
    user.delegate = self;
    
    
    AppConfig *config = [AppConfig getInstance];
    
    
    NSDictionary *values = @{@"name":config.userSearchKeyword};
    [user search:values ResultArray:self.resultArray Token:@""];
    
}

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    User *user = [User getInstance];
    user.delegate = self;
    
    AppConfig *config = [AppConfig getInstance];
    
    
    NSDictionary *values = @{@"name":config.userSearchKeyword};
    [user search:values ResultArray:self.resultArray Token:@""];
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
    
    if ([self.resultArray count] == 0) {
        return 1;
    }
    
    return [self.resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.resultArray count] == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InfoCell"];
        
        [cell.textLabel setText:@"Not found any user"];
        return cell;
    }
    
    NSString *CellIdentifier = @"StoreCell";
    FollowerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    User *follower = [self.resultArray objectAtIndex:indexPath.row];
    
    cell.follower = follower;
    
    //CGRect tableRect = cell.imageVBkg.frame;
    //tableRect.origin.y = 0;
    //cell.imageVBkg.frame = tableRect;
    [cell setData];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentIndex = indexPath;
    User *follower = [self.resultArray objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    UserSearchProfileController *vc = [storyboard instantiateViewControllerWithIdentifier:@"user_search_profile"];
    vc.user = follower;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        Detail2Controller *detailVC = segue.destinationViewController;
        
        Image *photo = [self.resultArray objectAtIndex:currentIndex.row];
        detailVC.photo = photo;
    }
}

@end
