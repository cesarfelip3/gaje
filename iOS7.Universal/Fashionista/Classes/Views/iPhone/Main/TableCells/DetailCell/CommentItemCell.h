//
//  CommentItemCell.h
//  Gaje
//
//  Created by hello on 14-7-5.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"

@interface CommentItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* content;
@property (strong, nonatomic) IBOutlet UIImageView* usericon;

@property (nonatomic, retain) DiskCache *cache;

- (BOOL)loadImage:(NSString *)url fileName:(NSString *)filename ImageView:(UIImageView *)imageView;

@end
