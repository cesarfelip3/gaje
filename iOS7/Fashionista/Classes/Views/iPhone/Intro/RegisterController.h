//
//  RegisterController.h
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import <UIKit/UIKit.h>
#import "InitController.h"
#import "User.h"

@interface RegisterController : UITableViewController <UITextFieldDelegate>
{
    InitController *_navigation;
    NSInteger _timeout;
}

@property (atomic, retain) IBOutlet UITableView *view;

@property (atomic, retain) InitController *navigation;

@property (atomic, retain) IBOutlet UITextField *username;
@property (atomic, retain) IBOutlet UITextField *password;
@property (atomic, retain) IBOutlet UIButton *picture;

@property (atomic, retain) IBOutlet UITableViewCell *cellUsername;
@property (atomic, retain) IBOutlet UITableViewCell *cellPassword;
@property (atomic, retain) IBOutlet UITableViewCell *cellEmail;
@property (atomic, retain) IBOutlet UITableViewCell *cellRegister;
@property (atomic, retain) IBOutlet UIButton *buttonRegister;

@property (atomic, retain) IBOutlet UITextField *email;
@property (atomic, retain) User *user;


- (IBAction)onCompleteAction:(id)sender;
- (BOOL)onCallback:(NSInteger)type;

@end
