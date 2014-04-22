//
//  AccountCell.h
//
//  Created by Valentin Filip on 4/13/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;
@property (strong, nonatomic) IBOutlet UIImageView *imageVAvatar;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblStats;

@end
