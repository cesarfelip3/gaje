//
//  MenuViewController.m
//  
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "MenuViewController.h"
#import "DataSource.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "User.h"

@interface MenuViewController ()

@property (nonatomic, strong) NSIndexPath   *currentSelection;

@end

@implementation MenuViewController

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menu = [[NSMutableArray alloc] initWithArray:[DataSource menu]];
    [self.tableView reloadData];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu-background.png"]];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"menu-searchBackground"]];
    
    if(![Utils isVersion6AndBelow]){
        CGRect tableRectSearch = self.searchBar.frame;
        tableRectSearch.origin.y += 20;
        self.searchBar.frame = tableRectSearch;
        
        CGRect tableRectView = self.tableView.frame;
        tableRectView.origin.y += 20;
        self.tableView.frame = tableRectView;
    }
    
    //self.searchBarDelegate = [[UserSearchDelegateController alloc] init];
    //self.searchBar.delegate = self.searchBarDelegate;
    
    self.searchBar.delegate = self;
    //self.searchBar.delegate = [[UserSearchController alloc] init];
    
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.searchBar setText:@""];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // NSLog(@"change");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // NSLog(@"cancel");
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // NSLog(@"search");
    [searchBar resignFirstResponder];
    
    //
    AppConfig *config = [AppConfig getInstance];
    config.userSearchKeyword = searchBar.text;
    
    [[AppDelegate sharedDelegate] togglePaperFold:searchBar];
    [[AppDelegate sharedDelegate] userDidSwitchToControllerAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menu.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menu[section][@"rows"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *bkg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-header.png"]];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 200, bkg.bounds.size.height)];
    lblTitle.text = self.menu[section][@"title"];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Avenir-Heavy" size:13.0f];
    
    [bkg addSubview:lblTitle];
    
    return bkg;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [aTableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *item = self.menu[indexPath.section][@"rows"][indexPath.row];
    
#if true
    NSString *title = [item objectForKey:@"title"];
    
    if ([title isEqualToString:@"Notification"]) {
        
        AppConfig *config = [AppConfig getInstance];
        
        title = [NSString stringWithFormat:@"Notifications(%ld)", (long)config.numberOfNotifications];
        item = @{@"image":@"", @"title":title};
    }
#endif
    
    UIImageView *imgRow = (UIImageView *)[cell viewWithTag:1];
    UIImage *imgRowImage = nil;
    if (item[@"image"]) {
        imgRowImage = [UIImage imageNamed:item[@"image"]];
    }
    imgRow.image = imgRowImage;
    UILabel *lblText = (UILabel *)[cell viewWithTag:2];
    lblText.text = item[@"title"];
    lblText.font = [UIFont fontWithName:@"Avenir-Heavy" size:17];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32.0f;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate userDidSwitchToControllerAtIndexPath:indexPath];
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}

@end
