//
//  ResetPasswordController.h
//  Pixcell8
//
//  Created by  on 13-10-28.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "NetworkCallbackDelegate.h"

@interface ResetPasswordController : UITableViewController <UITextFieldDelegate, NetworkCallbackDelegate>

@property (atomic, retain) IBOutlet UITableView *view;
@property (atomic, retain) IBOutlet UITableViewCell *cellUsername;
@property (atomic, retain) IBOutlet UITextField *username;

@end
