//
//  PhotoInfoCell.h
//  Gaje
//
//  Created by hello on 14-11-25.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoInfoCell : UITableViewCell

@property (strong) IBOutlet UILabel *photoTitle;
@property (strong) IBOutlet UILabel *photoDesc;

- (CGFloat)setPhotoInfoText:(NSString *)title Description:(NSString *)description;
- (void)hideAll;
- (void)showAll;

@end
