//
//  DetailViewController.h
//  
//
//  Created by Valentin Filip on 11/7/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface MasterViewController_iPad : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) NSArray *items;

@property (strong, nonatomic) IBOutlet iCarousel *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *coverflowBkg;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
