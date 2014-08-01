//
//  UserSearchController.m
//  Gaje
//
//  Created by hello on 14-7-31.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "UserSearchController.h"
#import "AppDelegate.h"

@interface UserSearchController ()

@end

@implementation UserSearchController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"change");  
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"cancel");
    searchBar.showsCancelButton = NO;
   [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search");
    [searchBar resignFirstResponder];
    
    //
    
    [[AppDelegate sharedDelegate] togglePaperFold:searchBar];
    [[AppDelegate sharedDelegate] userDidSwitchToControllerAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
