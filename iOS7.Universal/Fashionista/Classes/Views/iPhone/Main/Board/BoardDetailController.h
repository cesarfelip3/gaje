//
//  Detail2Controller.h
//  Gaje
//
//  Created by hello on 14-7-4.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"
#import "PhotoInfoCell.h"

@interface BoardDetailController : UITableViewController <UITextFieldDelegate, NetworkCallbackDelegate, UIActionSheetDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *imageBkg;
@property (strong, nonatomic) IBOutlet UIImageView *imageContent;

@property (strong, nonatomic) IBOutlet UIProgressView *progress;

@property (nonatomic, retain) DiskCache *cache;
@property (strong, nonatomic) Image *photo;

@property (strong, atomic) NSMutableArray *commentArray;
@property (strong, atomic) NSMutableArray *branderArray;

@property (assign, atomic) NSInteger *currentTab;
@property (strong, nonatomic) UISegmentedControl *tabbar;

@end
