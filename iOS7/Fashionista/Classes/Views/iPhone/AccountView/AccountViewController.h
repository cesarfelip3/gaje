//
//  OtherViewController.h
//  Metropolitan
//
//  Created by Valentin Filip on 12/22/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkCallbackDelegate.h"

@class User;

@interface AccountViewController : UITableViewController <NetworkCallbackDelegate>

@property (strong, nonatomic) NSMutableArray *imageArray;

- (BOOL)onCallback:(NSInteger)type;

@end
