//
//  Detail3Controller.h
//  Gaje
//
//  Created by hello on 14-7-12.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"

@interface ProfileDetailController : UITableViewController <UITextFieldDelegate, NetworkCallbackDelegate, UIActionSheetDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *imageBkg;
@property (strong, nonatomic) IBOutlet UIImageView *imageContent;

@property (strong, nonatomic) IBOutlet UIProgressView *progress;

@property (nonatomic, retain) DiskCache *cache;
@property (strong, nonatomic) Image *photo;

@property (strong, atomic) NSMutableArray *photoArray;
@property (strong, atomic) NSMutableArray *commentArray;
@property (strong, atomic) NSMutableArray *branderArray;

@property (assign, atomic) NSInteger *currentTab;


@end
