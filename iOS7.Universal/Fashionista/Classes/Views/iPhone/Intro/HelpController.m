//
//  HelpController.m
//  Pixcell8
//
//  Created by  on 13-10-28.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "HelpController.h"

@interface HelpController ()

@end

@implementation HelpController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setup];
}

- (void)setup
{
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8]];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8]];
    
    self.view.backgroundView = nil;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_texture"]]];
    //self.view.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_rest"]];
    
    [self.cellResetPassword.textLabel setText:@"Email"];
    [self.cellCustomService.textLabel setText:@"Pixcell8 Help Center"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
