//
//  ThemeController.m
//  Gaje
//
//  Created by hello on 14-7-2.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "ThemeController.h"

@interface ThemeController ()

@end

@implementation ThemeController

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
    
    //self.themeArray = [[NSMutableArray alloc] init];
    
    Theme *theme = [Theme getInstance];
    
    theme.delegateType = @"theme.list";
    theme.delegate = self;
    [theme fetchList:self.themeArray Token:@""];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)onCallback:(NSInteger)type
{
    Theme *theme = [Theme getInstance];
    
    if ([theme.delegateType isEqualToString:@"theme.list"]) {
        theme.delegateType = @"";
        
        if ([self.themeArray count] > 0) {
 
            // NSLog(@"themeArray = %@", self.themeArray);
            [self.tableView reloadData];
            
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.themeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_theme_item" forIndexPath:indexPath];
    
    Theme *theme = [self.themeArray objectAtIndex:[indexPath row]];
    
    [cell.textLabel setText:theme.name];
    
    if (theme.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Theme* theme = [self.themeArray objectAtIndex:[indexPath row]];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        theme.selected = YES;
        
    } else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        theme.selected = NO;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
