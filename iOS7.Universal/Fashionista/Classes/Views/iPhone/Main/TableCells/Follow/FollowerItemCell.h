//
//  FollowerItemCell.h
//  Gaje
//
//  Created by hello on 14-7-12.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "BrandListView.h"

@class DiskCache;
@class User;

@interface FollowerItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;

@property (strong, nonatomic) IBOutlet UIImageView *imageVImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageVAvatar;
@property (strong, nonatomic) IBOutlet UIImageView *imageVStage;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet UIButton *btnFav;

@property (strong, nonatomic) NSMutableArray *brandArray;

@property (nonatomic, retain) DiskCache *cache;
@property (nonatomic, retain) User *follower;
@property (nonatomic, strong) Image *photo;

- (void)setData;

@end
