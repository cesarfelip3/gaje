//
//  TabbarCell.m
//  Gaje
//
//  Created by hello on 14-7-4.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "TabbarCell.h"

@implementation TabbarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
