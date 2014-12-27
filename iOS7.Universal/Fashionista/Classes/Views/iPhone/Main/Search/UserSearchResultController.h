//
//  UserSearchResultController.h
//  Gaje
//
//  Created by hello on 14-8-1.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSearchProfileController.h"

#import "FollowerItemCell.h"
#import "UploadController.h"

@interface UserSearchResultController : UIViewController<UITableViewDataSource, UITableViewDelegate, NetworkCallbackDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain) NSMutableArray *resultArray;
@property (retain) Image *photo;

@property (atomic, retain) UIRefreshControl *refreshControl;
@property (retain) UploadController *uploadController;

@end
