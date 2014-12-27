//
//  ThemeController.h
//  Gaje
//
//  Created by hello on 14-7-2.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"

@interface ThemeController : UITableViewController <NetworkCallbackDelegate>

@property (retain) NSMutableArray *themeArray;

- (BOOL)onCallback:(NSInteger)type;

@end
