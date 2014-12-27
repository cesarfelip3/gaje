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
    [self.labelTitle setText:config.theme];
    
    return;
    
}


@end