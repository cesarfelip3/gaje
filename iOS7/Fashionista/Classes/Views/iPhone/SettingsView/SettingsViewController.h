//
//  SettingsViewController.h
//  
//
//  Created by Valentin Filip on 4/19/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class User;

@interface SettingsViewController : UITableViewController <FBLoginViewDelegate>

@property (atomic, retain) IBOutlet FBLoginView *loginView;

@end
