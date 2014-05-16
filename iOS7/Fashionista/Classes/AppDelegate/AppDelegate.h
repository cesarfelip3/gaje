//
//  AppDelegate.h
//
//  Created by Valentin Filip on 11/7/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGTabBarController.h"
#import "MenuViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "NetworkCallbackDelegate.h"

@class NGTestTabBarController;
@class PaperFoldNavigationController;

typedef enum {
    ADVNavigationTypeTab = 0,
    ADVNavigationTypeMenu
} ADVNavigationType;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NGTabBarControllerDelegate, MenuViewControllerDelegate, FBLoginViewDelegate, NetworkCallbackDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NGTestTabBarController *tabbarVC;
@property (strong, nonatomic) PaperFoldNavigationController *foldVC;
@property (strong, nonatomic) MenuViewController *menuVC;
@property (strong, nonatomic) UIViewController *mainVC;
@property (assign, nonatomic) ADVNavigationType navigationType;

@property (nonatomic, retain) FBLoginView *loginView;

+ (AppDelegate *)sharedDelegate;
+ (void)customizeTabsForController:(UITabBarController *)tabVC;
+ (void)tabBarController:(NGTabBarController *)tabBarC setupItemsForOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)togglePaperFold:(id)sender;
- (void)resetAfterTypeChange:(BOOL)cancel;

@end
