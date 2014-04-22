//
//  AccountCell.m
//
//  Created by Valentin Filip on 4/13/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "AccountCell.h"
#import "UIImage+StackBlur.h"

#import <QuartzCore/QuartzCore.h>

@implementation AccountCell

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
    UIImage *imgCover = [UIImage imageNamed:data[@"cover"]];
    
//    dispatch_queue_t blurThread = dispatch_queue_create("blurThread", NULL);
//    dispatch_async(blurThread, ^{
//        UIImage *imgBkg = [imgCover stackBlur:30];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.imageVBkg.image = imgBkg;
//        });
//    });
    self.imageVBkg.image = imgCover;
    
    self.imageVAvatar.image = [UIImage imageNamed:data[@"avatar"]];
    
    _lblTitle.text = data[@"name"];
    _lblTitle.font = [UIFont fontWithName:@"Avenir-Heavy" size:17];
    
    NSNumber *followers = data[@"followers"];
    NSNumber *following = data[@"following"];
    
    _lblStats.text = [NSString stringWithFormat:@"%@ Following, %@ Followers", following, followers];
    _lblStats.font = [UIFont fontWithName:@"Avenir-Heavy" size:10];
}


@end
