//
//  MapViewController.h
//  
//
//  Created by Valentin Filip on 2/16/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"

@class ADVGalleryPlain;


@interface DetailViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageBkg;
@property (strong, nonatomic) IBOutlet UIImageView *imageContent;

@property (strong, nonatomic) IBOutlet ADVGalleryPlain *viewGallery;
@property (strong, nonatomic) IBOutlet UIView *viewStage;
@property (strong, nonatomic) IBOutlet UIView *viewDetails;

@property (strong, nonatomic) NSDictionary *item;

@property (nonatomic, retain) DiskCache *cache;
@property (strong, nonatomic) Image *photo;

@end
