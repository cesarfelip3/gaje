//
//  ProfileItemCell.h
//  Gaje
//
//  Created by hello on 14-7-30.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "BrandListView.h"

@class DiskCache;
@class User;
@protocol StoreCellDelegate;

@interface ProfileItemCell : UITableViewCell


@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;

@property (strong, nonatomic) IBOutlet UIImageView *imageVImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageVAvatar;
@property (strong, nonatomic) IBOutlet UIImageView *imageVStage;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet UIButton *btnBrand;
@property (strong, nonatomic) IBOutlet UIButton *btnAction;

@property (strong, nonatomic) NSMutableArray *brandArray;
@property (strong) IBOutlet BrandListView *brandContainer;

@property (weak, nonatomic) id<StoreCellDelegate> delegate;

@property (nonatomic, retain) DiskCache *cache;
@property (nonatomic, retain) Image *photo;

@property (nonatomic, assign) BOOL brandIt;

- (BOOL)onBrandButtonTouched;

@end


@protocol StoreCellDelegate <NSObject>

- (void)cellDidToggleFavoriteState:(ProfileItemCell *)cell forItem:(NSDictionary *)item;

@end