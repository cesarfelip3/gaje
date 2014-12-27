//
//  FollowerProfileItemCell.h
//  Gaje
//
//  Created by hello on 14-7-12.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiskCache;
@class User;

@interface FollowerProfileItemCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;
@property (strong, nonatomic) IBOutlet UIImageView *imageVAvatar;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblStats;

@property (nonatomic, retain) DiskCache *cache;
@property (nonatomic, strong) User *user;
@end
