//
//  SettingCell.h
//  Gaje
//
//  Created by hello on 14-5-2.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SettingCell : UITableViewCell

@property (atomic, retain) IBOutlet FBLoginView *loginView;

@end
