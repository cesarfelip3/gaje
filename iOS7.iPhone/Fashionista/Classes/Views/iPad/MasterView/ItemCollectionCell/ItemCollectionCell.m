//
//  ItemCollectionCell.m
//  Metropolitan
//
//  Created by Valentin Filip on 12/22/12.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "ItemCollectionCell.h"
#import "UIColor+Alpha.h"

static CGFloat kCollectionCellWidth = 244;
static CGFloat kCollectionCellPadding = 5;

@implementation ItemCollectionCell


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
    [ItemCollectionCell initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageBkg.image = [[UIImage imageNamed:@"background-content"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGFloat elemY = 0;
    if (_data[@"image"]) {
        UIImage *image = [UIImage imageNamed:_data[@"image"]];
        elemY = (int)[image aspectFitHeightForWidth:(kCollectionCellWidth-kCollectionCellPadding)];
        _imageProduct.image = image;
    }
    CGRect frameImage = _imageProduct.frame;
    frameImage.size.height = elemY;
    _imageProduct.frame = frameImage;
    
    UILabel *lblName = (UILabel *)[_viewStage viewWithTag:1];
    lblName.text = _data[@"name"];
    lblName.textColor = [UIColor colorWithRed:0.87f green:0.23f blue:0.19f alpha:1.00f];
    lblName.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
    
    UILabel *lblDesc = (UILabel *)[_viewStage viewWithTag:2];
    lblDesc.text = _data[@"description"];
    lblDesc.textColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];
    lblDesc.font = [UIFont fontWithName:@"Avenir-Heavy" size:12];
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    fmt.numberStyle = NSNumberFormatterDecimalStyle;
    _labelPrice.text = [NSString stringWithFormat:@"$%@", [fmt stringFromNumber:_data[@"price"]]];
    _labelPrice.textColor = [UIColor whiteColor];
    _labelPrice.font = [UIFont fontWithName:@"Avenir-Heavy" size:14];
    
    NSArray *sizes = _data[@"sizes"];
    UILabel *lblSizesTitle = (UILabel *)[_viewDetails viewWithTag:1];
    lblSizesTitle.textColor = [UIColor colorWithRed:0.87f green:0.23f blue:0.19f alpha:1.00f];
    lblSizesTitle.font = [UIFont fontWithName:@"Avenir-Heavy" size:12];
    
    UILabel *lblSizes = (UILabel *)[_viewDetails viewWithTag:2];
    lblSizes.text = [sizes componentsJoinedByString:@", "];
    lblSizes.textColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];
    lblSizes.font = [UIFont fontWithName:@"Avenir-Heavy" size:12];
    
    NSArray *colors = _data[@"colors"];
    UILabel *lblColorsTitle = (UILabel *)[_viewDetails viewWithTag:4];
    lblColorsTitle.textColor = [UIColor colorWithRed:0.87f green:0.23f blue:0.19f alpha:1.00f];
    lblColorsTitle.font = [UIFont fontWithName:@"Avenir-Heavy" size:12];
    for (UIView *subView in _viewDetails.subviews) {
        if (subView.tag >= 100) {
            [subView removeFromSuperview];
        }
    }
    
    CGFloat tag = 100;
    CGFloat offset = CGRectGetMinX(lblColorsTitle.frame);
    CGFloat padding = 5;
    for (NSString *colorHex in colors) {
        UIColor *color = [UIColor colorWithHexString:colorHex];
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(offset, CGRectGetMaxY(lblColorsTitle.frame) + padding, 15, 15)];
        colorView.backgroundColor = color;
        colorView.tag = tag++;
        
        offset = CGRectGetMaxX(colorView.frame) + padding;
        [_viewDetails addSubview:colorView];
    }
    
    UIButton *btnAdd = (UIButton *)[_viewDetails viewWithTag:5];
    btnAdd.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17];
    
    CGRect frameStage = _viewStage.frame;
    frameStage.origin.y = CGRectGetMaxY(frameImage);
    _viewStage.frame = CGRectIntegral(frameStage);
    
    CGRect frameDetails = _viewDetails.frame;
    frameDetails.origin.y = CGRectGetMaxY(frameStage);
    _viewDetails.frame = CGRectIntegral(frameDetails);
    
    CGRect frameBkg = _imageBkg.frame;
    frameBkg.size.height = CGRectGetMaxY(frameDetails) + 7;
    _imageBkg.frame = frameBkg;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, CGRectGetMaxY(_viewDetails.frame) + 10);

    self.frame = CGRectIntegral(self.frame);
}

+ (CGSize)sizeForCellWithData:(NSDictionary *)dataDict {
    CGSize cellSize = (CGSize){kCollectionCellWidth,0};
    
    if (dataDict[@"image"]) {
        CGFloat height = [[UIImage imageNamed:dataDict[@"image"]] aspectFitHeightForWidth:(kCollectionCellWidth-kCollectionCellPadding)];
        cellSize.height = (int)height;
    }
    
    cellSize.height += 222;
    return cellSize;
}

@end
