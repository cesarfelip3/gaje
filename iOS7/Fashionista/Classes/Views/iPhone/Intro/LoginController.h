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
@property (atomic, retain) IBOutlet FBLoginView *loginView;

@property (atomic, retain) User *user;

- (IBAction)onButtonTouched:(id)sender;
- (BOOL)onCallback:(NSInteger)type;

@end
