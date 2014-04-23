//
//  LoginController.h
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QUartzCore.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginController : UITableViewController <UITextFieldDelegate>
{
    NSInteger _timeout;
}

@property (atomic, retain) IBOutlet UITableView *view;

@property (atomic, retain) IBOutlet UITableViewCell *cellUsername;
@property (atomic, retain) IBOutlet UITableViewCell *cellPassword;

@property (atomic, retain) IBOutlet UITextField *username;
@property (atomic, retain) IBOutlet UITextField *password;

@property (atomic, retain) IBOutlet UIButton *buttonLogo;
@property (atomic, retain) IBOutlet UITableViewCell *cellRegister;

@property (atomic, retain) IBOutlet UITableViewCell *cellLogin;
@property (atomic, retain) IBOutlet UIButton *buttonLogin;

@property (atomic, retain) User *user;

- (IBAction)onButtonTouched:(id)sender;
- (BOOL)onCallback:(NSInteger)type;

@end
