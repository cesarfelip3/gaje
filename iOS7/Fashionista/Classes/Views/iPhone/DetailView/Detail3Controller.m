//
//  Detail3Controller.m
//  Gaje
//
//  Created by hello on 14-7-12.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Detail3Controller.h"

#import "CommandCell.h"
#import "TabbarCell.h"
#import "CommentCell.h"
#import "CommentItemCell.h"
#import "Comment.h"
#import "BranderItemCell.h"
#import "Brander.h"

@interface Detail3Controller ()

@end

@implementation Detail3Controller

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
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:225/255.0 alpha:0.8]];
    [self.tableView.tableHeaderView setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:225/255.0 alpha:0.8]];
    
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
    
    self.progress.progress = 0;
    
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
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Response: %@", responseObject);
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
        //NSLog(@"%2.2f", (float)(totalBytesWritten) / totalBytesExpectedToWrite);
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

- (IBAction)onButtonFollowTouched:(id)sender
{
    
    NSLog(@"on button brand touched");
    
    //UIButton *button = (UIButton*)sender;
    
    User* user = [User getInstance];
    NSDictionary *values = @{@"user_followed_uuid":self.photo.userUUID, @"user_following_uuid":user.userUUID};
    
    [user addFollow:values Token:@""];
    
}

- (IBAction)onButtonBrandTouched:(id)sender
{
    
    NSLog(@"on button brand touched");
    
    //UIButton *button = (UIButton*)sender;
    
    User* user = [User getInstance];
    NSDictionary *values = @{@"image_uuid":self.photo.imageUUID, @"user_uuid":user.userUUID};
    [self.photo addBrander:values Token:@""];
    
}

- (IBAction)onTabChanged:(id)sender
{
    
    UISegmentedControl *tabbar = (UISegmentedControl *)sender;
    NSLog(@"tab changed = %d", tabbar.selectedSegmentIndex);
    
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
    
    User* user = [User getInstance];
    
    NSDictionary *values = @{@"image_uuid":self.photo.imageUUID, @"content":textField.text, @"user_uuid":user.userUUID};
    [self.photo addComment:values Token:@""];
    
    if (textField.text == nil || [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    
    Comment* comment = [[Comment alloc] init];
    comment.content = textField.text;
    comment.userUUID = [[User getInstance] userUUID];
    //comment.usericon = @"";
    
    [self.commentArray addObject:comment];
    [self.tableView reloadData];
    
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
        
        return 60;
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
        [cell setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:225/255.0 alpha:0.8]];
        
        [cell.buttonBrand addTarget:self action:@selector(onButtonBrandTouched:) forControlEvents:UIControlEventTouchDown];
        
        User *user = [User getInstance];
        
        if ([user.userUUID isEqualToString:self.photo.userUUID]) {
            
            [cell.buttonFollow setHidden:YES];
            
        } else {
            
            [cell.buttonFollow setHidden:NO];
            [cell.buttonFollow addTarget:self action:@selector(onButtonFollowTouched:) forControlEvents:UIControlEventTouchDown];
        }
        
        [cell.buttonFollow setHidden:NO];
        [cell.buttonFollow addTarget:self action:@selector(onButtonFollowTouched:) forControlEvents:UIControlEventTouchDown];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        CommentCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierComment forIndexPath:indexPath];
        cell.textComment.text = @"drop a line";
        cell.textComment.delegate = self;
        
        cell.textComment.textColor = [UIColor lightGrayColor];
        [cell.textComment setTintColor:[UIColor lightGrayColor]];
        
        [cell setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:225/255.0 alpha:0.8]];
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        TabbarCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierTabbar forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:225/255.0 alpha:0.8]];
        NSString* comment = [NSString stringWithFormat:@"line dropped(%d)", [self.commentArray count]];
        [cell.tabbar setTitle:comment forSegmentAtIndex:0];
        
        comment = [NSString stringWithFormat:@"brand(%d)", [self.branderArray count]];
        [cell.tabbar setTitle:comment forSegmentAtIndex:1];
        
        [cell.tabbar addTarget:self action:@selector(onTabChanged:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    
    if (self.currentTab == 0) {
        
        CommentItemCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_detail_comment_item" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:225/255.0 alpha:0.8]];
        
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
        
        cell.usericon.image = nil;
        [cell loadImage:comment.usericon fileName:comment.userUUID ImageView:cell.usericon];
        return cell;
    }
    
    
    BranderItemCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell_detail_brander_item" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:225/255.0 alpha:0.8]];
    
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