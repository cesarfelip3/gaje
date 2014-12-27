//
//  FollowerProfileController.h
//  Gaje
//
//  Created by hello on 14-7-12.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkCallbackDelegate.h"
#import "FollowerProfileCommandCell.h"
#import "FollowerProfileItemCell.h"

@class User;

@interface FollowerProfileController : UITableViewController <NetworkCallbackDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *imageArray;

@property (strong, nonatomic) User *user;

- (BOOL)onCallback:(NSInteger)type;

@end
