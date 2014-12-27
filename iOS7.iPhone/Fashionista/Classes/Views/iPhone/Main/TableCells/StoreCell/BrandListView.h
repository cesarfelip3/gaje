//
//  BrandListView.h
//  Gaje
//
//  Created by hello on 14-7-12.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "Image.h"

@class DiskCache;
@class User;

@interface BrandListView : UIView

@property (nonatomic, retain) DiskCache *cache;
@property (nonatomic, retain) Image *photo;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSMutableArray *imageArray;
- (BOOL)loadBranderIcons;
- (BOOL)cleanBranderIcons;

@end
