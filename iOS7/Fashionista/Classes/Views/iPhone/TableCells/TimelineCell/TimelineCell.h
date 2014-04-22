//
//  StoreCell.h
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TimelineCellDelegate;


@interface TimelineCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;

@property (strong, nonatomic) IBOutlet UIImageView *imageVImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageVAvatar;
@property (strong, nonatomic) IBOutlet UIImageView *imageVStage;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet UIButton *btnFav;

@property (weak, nonatomic) id<TimelineCellDelegate> delegate;

- (IBAction)actionToggleFav:(id)sender;

@end





@protocol TimelineCellDelegate <NSObject>

- (void)cellDidToggleFavoriteState:(TimelineCell *)cell forItem:(NSDictionary *)item;

@end

