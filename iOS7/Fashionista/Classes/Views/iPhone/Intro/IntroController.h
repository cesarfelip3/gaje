//
//  IntroController.h
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "InitController.h"
#import "NetworkCallbackDelegate.h"

@interface IntroController : UITableViewController
{
    InitController *_navigation;
    UIView *_banner;
}

@property (atomic, retain) IBOutlet UIView *banner;
@property (atomic, retain) IBOutlet InitController *navigation;

@property (atomic, retain) IBOutlet UITableViewCell *cellRegister;
@property (atomic, retain) IBOutlet UITableViewCell *cellLogin;

@end
