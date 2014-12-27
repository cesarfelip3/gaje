//
//  UpdateInfoCell.h
//  Gaje
//
//  Created by hello on 14-8-13.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"

@interface UpdateInfoCell : UITableViewCell

@property (strong) IBOutlet UIImageView *imageIcon;
@property (strong) IBOutlet UILabel *info;
@property (nonatomic, retain) DiskCache *cache;

- (BOOL)loadImage:(NSString *)url fileName:(NSString *)filename;
@end
