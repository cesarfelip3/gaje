//
//  LoginCell.m
//  Pixcell8
//
//  Created by  on 13-11-1.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "LoginCell.h"

@implementation LoginCell

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

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 60;
    frame.size.width -= 2 * 60;
    [super setFrame:frame];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 0, 0, 44, 44 );
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.7;
}

@end
