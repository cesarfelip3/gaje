//
//  ItemCollectionCell.h
//  Metropolitan
//
//  Created by Valentin Filip on 12/22/12.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCollectionCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView  *imageBkg;
@property (strong, nonatomic) IBOutlet UIImageView  *imageProduct;
@property (strong, nonatomic) IBOutlet UIView       *viewStage;
@property (strong, nonatomic) IBOutlet UIView       *viewDetails;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;

@property (strong, nonatomic) NSDictionary  *data;
@property (strong, nonatomic) UIImage       *image;


+ (CGSize)sizeForCellWithData:(NSDictionary *)dataDict;

@end
