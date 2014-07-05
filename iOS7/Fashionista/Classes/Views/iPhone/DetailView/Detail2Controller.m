//
//  Detail2Controller.m
//  Gaje
//
//  Created by hello on 14-7-4.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Detail2Controller.h"
#import "CommandCell.h"
#import "TabbarCell.h"
#import "CommentCell.h"
#import "CommentItemCell.h"
#import "Comment.h"

@interface Detail2Controller ()

@end

@implementation Detail2Controller

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
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    [self.tableView.tableHeaderView setBackgroundColor:[UIColor lightGrayColor]];
    
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    [requestOperation start];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onButtonBrandTouched:(id)sender
{

    NSLog(@"on button brand touched");
    
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == 0) {
        
        // comment
    }
    
    if (button.tag == 1) {
        
        // brand
    }
}

- (BOOL)onCallback:(NSInteger)type
{
    
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
    return 3 + [self.commentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 3) {
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
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        
        [cell.buttonBrand addTarget:self action:@selector(onButtonBrandTouched:) forControlEvents:UIControlEventTouchDown];
        
        [cell.buttonComment addTarget:self action:@selector(onButtonBrandTouched:) forControlEvents:UIControlEventTouchDown];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        CommentCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierComment forIndexPath:indexPath];
        cell.textComment.text = @"drop a line";
        cell.textComment.delegate = self;
        
        cell.textComment.textColor = [UIColor lightGrayColor];
        [cell.textComment setTintColor:[UIColor lightGrayColor]];
        
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        TabbarCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierTabbar forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        NSString* comment = [NSString stringWithFormat:@"Comment(%d)", [self.commentArray count]];
        [cell.tabbar setTitle:comment forSegmentAtIndex:0];
        
        return cell;
    }
    
    CommentItemCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell_detail_comment_item" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    cell.content.lineBreakMode = NSLineBreakByWordWrapping;
    cell.content.numberOfLines = 0;
    //cell.usericon.frame = CGRectMake(15, 10, 40, 30);
    
    NSInteger count = [self.commentArray count];
    NSInteger row = count - (indexPath.row - 3) - 1;
    
    Comment *comment = [self.commentArray objectAtIndex:row];
    [cell.content setText:comment.content];
    [cell.content sizeToFit];
    
    //cell.contentView.layer.borderWidth = 1;
    //cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    [cell loadImage:comment.usericon fileName:comment.userUUID ImageView:cell.usericon];
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