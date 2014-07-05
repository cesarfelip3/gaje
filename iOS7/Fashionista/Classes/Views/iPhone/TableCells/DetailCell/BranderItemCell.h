//
//  BranderItemCell.h
//  Gaje
//
//  Created by hello on 14-7-5.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BranderItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* username;
@property (strong, nonatomic) IBOutlet UILabel* date;
@property (strong, nonatomic) IBOutlet UIImageView* usericon;

@property (strong, nonatomic) IBOutlet UIButton* follow;

@end
