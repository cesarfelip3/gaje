//
//  FavoritesViewController.h
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardItemCell.h"
#import "NetworkCallbackDelegate.h"
#import "Theme.h"

@interface WeekThemeController : UITableViewController <NetworkCallbackDelegate>

@property (strong,nonatomic) NSMutableArray *themeArray;
@property (strong, nonatomic) Theme *theme;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@end
