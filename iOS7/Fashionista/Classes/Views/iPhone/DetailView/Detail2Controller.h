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

@interface Detail2Controller : UITableViewController <UITextFieldDelegate, NetworkCallbackDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *imageBkg;
@property (strong, nonatomic) IBOutlet UIImageView *imageContent;

@property (nonatomic, retain) DiskCache *cache;
@property (strong, nonatomic) Image *photo;

@property (strong, atomic) NSMutableArray *commentArray;

@end
