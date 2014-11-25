//
//  PhotoInfoCell.m
//  Gaje
//
//  Created by hello on 14-11-25.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "PhotoInfoCell.h"

@implementation PhotoInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)setPhotoInfoText:(NSString *)title Description:(NSString *)description
{
    
    self.photoDesc.frame = CGRectMake(15, 30, 300, 44);
    self.photoDesc.lineBreakMode = NSLineBreakByWordWrapping;
    self.photoDesc.numberOfLines = 0;
    //cell.usericon.frame = CGRectMake(15, 10, 40, 30);
    
    self.photoTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.photoTitle setText:title];
    
    [self.photoDesc setText:description];
    [self.photoDesc sizeThatFits:CGSizeMake(300, 44)];
    [self.photoDesc sizeToFit];
    
    CGFloat height = self.photoDesc.frame.size.height + self.photoDesc.frame.origin.y;
    height += self.photoTitle.frame.size.height;
    
    NSLog(@"height = %f", height);
    return height;
}

- (void)hideAll
{
    [self.photoDesc setFrame:CGRectMake(self.photoDesc.frame.origin.x, self.photoDesc.frame.origin.y, self.photoDesc.frame.size.width, 0)];
    [self.photoTitle setFrame:CGRectMake(self.photoTitle.frame.origin.x, self.photoTitle.frame.origin.y, self.photoTitle.frame.size.width, 0)];
}

- (void)showAll
{
    [self.photoDesc setFrame:CGRectMake(self.photoDesc.frame.origin.x, self.photoDesc.frame.origin.y, self.photoDesc.frame.size.width, 44)];
    [self.photoTitle setFrame:CGRectMake(self.photoTitle.frame.origin.x, self.photoTitle.frame.origin.y, self.photoTitle.frame.size.width, 21)];
}

@end
