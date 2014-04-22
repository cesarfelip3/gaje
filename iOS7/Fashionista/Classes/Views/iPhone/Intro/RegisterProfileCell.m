//
//  RegisterProfileCell.m
//  Pixcell8
//
//  Created by  on 13-11-14.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "RegisterProfileCell.h"

@implementation RegisterProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 0, 0, 44, 44 );
}

@end
