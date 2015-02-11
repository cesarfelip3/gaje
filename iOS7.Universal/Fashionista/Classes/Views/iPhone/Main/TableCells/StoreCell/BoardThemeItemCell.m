//
//  BoardThemeItemCell.m
//  Gaje
//
//  Created by hello on 14-12-2.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "BoardThemeItemCell.h"
#import "DataSource.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"
#import "Brander.h"
#import "Image+ImageApi.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation BoardThemeItemCell

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

+ (void)initialize {
    
}

- (void)initialize {
    [[self class] initialize];
}


#pragma mark - Accessors

- (void)setData:(NSDictionary *)data {
    
    _data = data;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageVBkg.image = [[UIImage imageNamed:@"list-item-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 30, 30)];
    
    [self.imageVImage setHidden:YES];
    
    //self.imageVStage.image = [UIImage imageNamed:@"list-item-stage"];
    
    
    //self.imageVImage.frame = CGRectMake(self.imageVImage.frame.origin.x, self.imageVImage.frame.origin.x, 280, self.photo.height * 280 / self.photo.width);
    
    NSString *name;
    NSString *brand;
    
    name = @"";
    brand = @"";
    
    AppConfig *config = [AppConfig getInstance];
    
    NSInteger width2 = [UIScreen mainScreen].bounds.size.width - 50;
    UILabel *labelTitle = [[UILabel alloc] init];
    
    labelTitle.frame = CGRectMake(40, 10, width2, 44);
    labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    labelTitle.numberOfLines = 0;
    //cell.usericon.frame = CGRectMake(15, 10, 40, 30);
    
    [labelTitle setText:config.theme];
    [labelTitle sizeThatFits:CGSizeMake(width2, 44)];
    [labelTitle sizeToFit];
    
    self.labelTitle.frame = CGRectMake(40, 10, width2, 44);
    [self.labelTitle setText:config.theme];
    self.labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelTitle.numberOfLines = 0;
    [self.labelTitle sizeThatFits:CGSizeMake(width2, 44)];
    [self.labelTitle sizeToFit];
    NSInteger height2 = labelTitle.frame.size.height - 10;
    
    if (height2 <= 44) {
        height2 = 44;
    }
    
    self.imageVBkg.frame = CGRectMake(0, 0, self.imageVBkg.frame.size.width, height2);
    return;
    
}


@end