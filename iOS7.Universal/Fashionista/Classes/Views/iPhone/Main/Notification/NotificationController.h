//
//  FollowingController.h
//  Gaje
//
//  Created by hello on 14-7-11.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateInfoCell.h"
#import "UploadController.h"
#import "NotificationProfileController.h"

@interface NotificationController : UIViewController <UITableViewDataSource, UITableViewDelegate, NetworkCallbackDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain) NSMutableArray *followingArray;
@property (retain) Image *photo;

@property (atomic, retain) UIRefreshControl *refreshControl;
@property (retain) UploadController *uploadController;

@property (strong) NSMutableDictionary *updateDictionary;

@end