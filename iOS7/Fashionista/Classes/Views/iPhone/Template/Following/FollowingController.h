//
//  FollowingController.h
//  Gaje
//
//  Created by hello on 14-7-11.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowerItemCell.h"
#import "UploadController.h"
#import "FollowingProfileController.h"

@interface FollowingController : UIViewController <UITableViewDataSource, UITableViewDelegate, NetworkCallbackDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain) NSMutableArray *followerArray;
@property (retain) Image *photo;

@property (atomic, retain) UIRefreshControl *refreshControl;
@property (retain) UploadController *uploadController;

@end