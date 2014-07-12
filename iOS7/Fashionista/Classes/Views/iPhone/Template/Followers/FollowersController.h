//
//  MasterViewController.h
//  PandoraUI-Orange
//
//  Created by Valentin Filip on 10/23/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowerProfileController.h"

#import "FollowerItemCell.h"
#import "UploadController.h"

@interface FollowersController : UIViewController <UITableViewDataSource, UITableViewDelegate, NetworkCallbackDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain) NSMutableArray *followerArray;
@property (retain) Image *photo;

@property (atomic, retain) UIRefreshControl *refreshControl;
@property (retain) UploadController *uploadController;

@end
