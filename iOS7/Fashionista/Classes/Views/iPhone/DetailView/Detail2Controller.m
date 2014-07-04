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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierAuthor = @"cell_detail_author";
    NSString *identifierTabbar = @"cell_detail_tabbar";
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
    
        CommandCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierAuthor forIndexPath:indexPath];
        
        [self loadImage:self.photo.usericon fileName:[NSString stringWithFormat:@"%@.jpg", self.photo.usertoken] ImageView:cell.thumbnail];
        cell.username.text = self.photo.username;
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        
        [cell.buttonBrand addTarget:self action:@selector(onButtonBrandTouched:) forControlEvents:UIControlEventTouchDown];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        TabbarCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierTabbar forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        return cell;
    }
    
    // Configure the cell...

    
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
