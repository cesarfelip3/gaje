//
//  Detail2Controller.m
//  Gaje
//
//  Created by hello on 14-7-4.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "TopBrandsDetailController.h"
#import "CommandCell.h"
#import "TabbarCell.h"
#import "CommentCell.h"
#import "CommentItemCell.h"
#import "Comment.h"
#import "BranderItemCell.h"
#import "Brander.h"

#import "User+UserApi.h"
#import "Image+ImageApi.h"

@interface TopBrandsDetailController ()

@end

@implementation TopBrandsDetailController

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
    
    [self setup];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setup
{
    self.navigationItem.title = @"Details";
    [self.navigationController.navigationBar setOpaque:NO];
    
    UIImageView *background = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"background"];
    
    background.image = image;
    //[self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    //[self.tableView.tableHeaderView setBackgroundColor:[UIColor lightGrayColor]];
    
    //[self.tableView setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:225/255.0 alpha:0.8]];
    //[self.tableView.tableHeaderView setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:225/255.0 alpha:0.8]];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView.tableHeaderView setBackgroundColor:[UIColor whiteColor]];
    
    _imageBkg.image = [[UIImage imageNamed:@"background-content"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self loadImage:self.photo.url fileName:self.photo.fileName ImageView:self.imageContent];
    
    NSInteger width = 280;
    NSInteger height = self.photo.height * width / self.photo.width;
    
    self.imageContent.frame = CGRectMake(self.imageContent.frame.origin.x, self.imageContent.frame.origin.y, 280, height);
    _imageBkg.frame = CGRectMake(_imageBkg.frame.origin.x, _imageBkg.frame.origin.y, 300, height + 25);
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 320, height + 35);
    
    
    //
    
    self.commentArray = [[NSMutableArray alloc] init];
    self.photo.delegate = self;
    [self.photo fetchCommentList:self.commentArray Token:@""];
    
    self.currentTab = 0;
    
    //
    
    self.branderArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
}

- (BOOL)loadImage:(NSString *)url fileName:(NSString *)filename ImageView:(UIImageView *)imageView
{
    
    
    if (!self.cache) {
        self.cache = [DiskCache getInstance];
    }
    
    if (self.cache) {
        
        UIImage *image = [self.cache getImage:filename];
        
        if (image) {
            [imageView setImage:image];
            self.progress.progress = 0;
            [self.progress setHidden:YES];
            return YES;
        }
    }
    
    self.progress.progress = 0;
    [self.progress setHidden:NO];
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //// NSLog(@"Response: %@", responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        UIImage *image = responseObject;
        
        if (image) {
            
            [imageView setImage:image];
            
            DiskCache *cache = [DiskCache getInstance];
            [cache addImage:responseObject fileName:filename];
        }
        
        self.progress.progress = 0;
        [self.progress setHidden:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.progress.progress = 0;
        [self.progress setHidden:YES];
        
    }];
    
    [requestOperation setDownloadProgressBlock:^(NSUInteger __unused bytesWritten,
                                                 long long totalBytesWritten,
                                                 long long totalBytesExpectedToWrite) {
        //// NSLog(@"%2.2f", (float)(totalBytesWritten) / totalBytesExpectedToWrite);
        self.progress.hidden = NO;
        self.progress.progress = (float)(totalBytesWritten) / totalBytesExpectedToWrite;
        
    }];
    
    [requestOperation start];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onButtonActionTouched:(id)sender
{
    
    // NSLog(@"on button brand touched");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Track" otherButtonTitles:@"Brand",@"block photos from this user", nil];
    
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    // NSLog(@"%d", buttonIndex);
    
    User* user = [User getInstance];
    
    if (buttonIndex == 0) {
        
        NSDictionary *values = @{@"user_followed_uuid":self.photo.userUUID, @"user_following_uuid":user.userUUID};
        [user addFollow:values Token:@""];
    }
    
    if (buttonIndex == 1) {
        
        self.tabbar.selectedSegmentIndex = 1;
        [self.tabbar sendActionsForControlEvents:UIControlEventValueChanged];
        //self.currentTab = 1;
        
        if (!self.photo.enableBrandIt) {
            return;
        }
        
        NSDictionary *values = @{@"image_uuid":self.photo.imageUUID, @"user_uuid":user.userUUID};
        self.photo.delegate = nil;
        [self.photo addBrander:values Token:@""];
        
        User *user = [User getInstance];
        
        Brander *brander = [[Brander alloc] init];
        brander.username = user.username;
        brander.iconurl = user.iconurl;
        brander.token = user.token;
        
        [self.branderArray addObject:brander];
        self.photo.branderCount++;
        self.photo.enableBrandIt = NO;
        
        [self.tableView reloadData];
    }
    
    if (buttonIndex == 2) {
        User *user = [User getInstance];
        
        if ([user.userUUID isEqualToString:self.photo.userUUID]) {
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
        
        NSDictionary *values = @{@"user_uuid":user.userUUID, @"user_block_uuid":self.photo.userUUID};
        [user addBlock:values Token:@""];
    }
    
}

- (IBAction)onTabChanged:(id)sender
{
    
    UISegmentedControl *tabbar = (UISegmentedControl *)sender;
    // NSLog(@"tab changed = %d", tabbar.selectedSegmentIndex);
    
    if (tabbar.selectedSegmentIndex == 1) {
        
        self.photo.delegateType = @"brander_list";
        self.photo.delegate = self;
        [self.photo fetchBranderList:self.branderArray Token:@""];
        
        
    }
    
    self.currentTab = tabbar.selectedSegmentIndex;
    
    if (self.currentTab == 0) {
        [self.tableView reloadData];
    }
    
}

- (BOOL)onCallback:(NSInteger)type
{
    User *user = [User getInstance];
    
    if ([user.delegateType isEqualToString:@"block_user"]) {
        
        user.delegateType = @"";
        type == 0 ? [self.navigationController popToRootViewControllerAnimated:YES] : nil;
        
        if (type > 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:user.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
        }
        
        return YES;
    }
    
    if ([self.branderArray count] > 0) {
        [self.tableView reloadData];
    }
    
    if ([self.commentArray count] > 0) {
        [self.tableView reloadData];
    }
    
    return YES;
}

//=============================
// TextField Delegate
//=============================

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    textField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    if (textField.text == nil || [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    
    User* user = [User getInstance];
    
    Comment* comment = [[Comment alloc] init];
    comment.content = textField.text;
    comment.userUUID = [[User getInstance] userUUID];
    comment.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, user.token];
    
    [self.commentArray addObject:comment];
    [self.tableView reloadData];
    
    NSDictionary *values = @{@"image_uuid":self.photo.imageUUID, @"content":textField.text, @"user_uuid":user.userUUID};
    [self.photo addComment:values Token:@""];
    
    return YES;
}
//=============================
//
//=============================

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentTab == 0) {
        return 3 + [self.commentArray count];
    }
    
    return 3 + [self.branderArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 3) {
        
        if (self.currentTab == 0) {
            NSInteger count = [self.commentArray count];
            NSInteger row = count - (indexPath.row - 3) - 1;
            
            Comment *comment = [self.commentArray objectAtIndex:row];
            
            //https://developer.apple.com/library/ios/documentation/uikit/reference/NSAttributedString_UIKit_Additions/Reference/Reference.html
            //https://developer.apple.com/library/ios/documentation/uikit/reference/NSString_UIKit_Additions/Reference/Reference.html#//apple_ref/occ/instm/NSString/boundingRectWithSize:options:attributes:context:
            
            CommentItemCell *cell;
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_detail_comment_item"];
            
            cell.content.frame = CGRectMake(59, 10, 249, 40);
            cell.content.lineBreakMode = NSLineBreakByWordWrapping;
            cell.content.numberOfLines = 0;
            //cell.usericon.frame = CGRectMake(15, 10, 40, 30);
            
            [cell.content setText:comment.content];
            [cell.content sizeThatFits:CGSizeMake(260, 40)];
            [cell.content sizeToFit];
            
            CGFloat height = cell.content.frame.size.height + cell.content.frame.origin.y > 60 ? cell.content.frame.size.height + cell.content.frame.origin.y : 60;
            
            if (height > 60) {
                return height + 10;
            }
            
            return height;
            
            
        }
        
        return 80;
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierAuthor = @"cell_detail_author";
    NSString *identifierTabbar = @"cell_detail_tabbar";
    NSString *identifierComment = @"cell_detail_comment";
    
    if (indexPath.row == 0) {
    
        CommandCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierAuthor forIndexPath:indexPath];
        
        [self loadImage:self.photo.usericon fileName:[NSString stringWithFormat:@"%@.jpg", self.photo.usertoken] ImageView:cell.thumbnail];
        cell.username.text = self.photo.username;
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        [cell.buttonAction addTarget:self action:@selector(onButtonActionTouched:) forControlEvents:UIControlEventTouchDown];
        
        User *user = [User getInstance];
        
        if ([user.userUUID isEqualToString:self.photo.userUUID]) {
            [cell.buttonAction setHidden:YES];
            [cell.buttonAction setEnabled:NO];
        } else {
            [cell.buttonAction setHidden:NO];
            [cell.buttonAction setEnabled:YES];
        }
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        CommentCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierComment forIndexPath:indexPath];
        cell.textComment.text = @"drop a line";
        cell.textComment.delegate = self;
        
        cell.textComment.textColor = [UIColor lightGrayColor];
        [cell.textComment setTintColor:[UIColor lightGrayColor]];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        TabbarCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierTabbar forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSString* comment = [NSString stringWithFormat:@"lines droped(%d)", [self.commentArray count]];
        [cell.tabbar setTitle:comment forSegmentAtIndex:0];
        
        comment = [NSString stringWithFormat:@"brands(%d)", self.photo.branderCount];
        [cell.tabbar setTitle:comment forSegmentAtIndex:1];
        
        [cell.tabbar addTarget:self action:@selector(onTabChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.tabbar = cell.tabbar;
        
        return cell;
    }
    
    if (self.currentTab == 0) {
    
        CommentItemCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_detail_comment_item" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        cell.content.frame = CGRectMake(59, 10, 249, 40);
        cell.content.lineBreakMode = NSLineBreakByWordWrapping;
        cell.content.numberOfLines = 0;
        //cell.usericon.frame = CGRectMake(15, 10, 40, 30);
        
        NSInteger count = [self.commentArray count];
        NSInteger row = count - (indexPath.row - 3) - 1;
        
        Comment *comment = [self.commentArray objectAtIndex:row];
        [cell.content setText:comment.content];
        [cell.content sizeThatFits:CGSizeMake(260, 40)];
        [cell.content sizeToFit];
        
        //cell.contentView.layer.borderWidth = 1;
        //cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
        
        [cell loadImage:comment.usericon fileName:comment.userUUID ImageView:cell.usericon];
        return cell;
    }
    
        
    BranderItemCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell_detail_brander_item" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    NSInteger count = [self.branderArray count];
    NSInteger row = count - (indexPath.row - 3) - 1;
    
    Brander *brander = [self.branderArray objectAtIndex:row];
    cell.username.text = brander.username;
    
    [cell loadImage:brander.iconurl fileName:brander.token ImageView:cell.usericon];
    
    return cell;
    
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
