//
//  Post.m
//  Pixcell8
//
//  Created by  on 13-10-27.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "Image.h"

@implementation Image

- (UIImage *)crop:(UIImage *)image {
    
    CGFloat height = image.size.height;
    CGFloat width = image.size.width;
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (width > height) {
    
        x = (width - height) / 2;
        y = 0;
        
        width = height;
        
    } else {
        
        x = 0;
        y = 0;
        
        height = width;
    }
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    CGImageRef cgImage = image.CGImage;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}

@end
