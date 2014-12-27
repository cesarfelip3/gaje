//
//  AppDelegate.m
//
//  Created by Valentin Filip on 11/7/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "AppDelegate.h"

#import "ADVTheme.h"

#import "BoardController.h"
#import "NGTestTabBarController.h"
#import "PaperFoldNavigationController.h"

#import <FacebookSDK/FacebookSDK.h>
#import "Bootstrap.h"

#import "User.h"
#import "User+UserApi.h"

static AppDelegate *sharedDelegate;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // prepare configuration here
    // prepare db
    
    // NSLog(@"application launch");
    
    Bootstrap *bootstrap = [Bootstrap getInstance];
    [bootstrap bootstrap];
 
    
    AppConfig *config = [AppConfig getInstance];
    config.fbfrom = @"application";
    
    // we saved user credential after being login
    // we see if we have it
    
    User *user = [User getInstance];
    [user auth];
    
    // only if user authorized == returned user
    // then it will load the main UI
    
    if (config.userIsLogin == 1) {
        
        NSDictionary *data = @{
                               @"username":user.username,
                               @"email":user.email,
                               @"fullname":user.fullname,
                               @"facebook_token":user.token,
                               @"facebook_icon": [NSString stringWithFormat:FB_PROFILE_ICON, user.token],
                               @"location":user.location
                               };
        
        
        user.delegate = self;
        [user login:data];
    }
    
    //
    // handle remote notification
    //
    if (config.userIsLogin == 1) {
        UILocalNotification *notification =
        [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (notification) {
            //NSString *itemName = [localNotif.userInfo objectForKey:ToDoItemKey];
            //[viewController displayItem:itemName];  // custom method
            application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber - 1;
        }
    }
    
    if (config.userIsLogin == 1) {
    
        [ADVThemeManager customizeAppAppearance];
        // Override point for customization after application launch.

        if (true || [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            //self.mainVC = (((UINavigationController *)self.window.rootViewController).viewControllers)[0];
            
        //} else {
            UIStoryboard *storyboard;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
                storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            
            } else {
                storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
            }
            
            self.mainVC = [storyboard instantiateInitialViewController];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            if (![[NSUserDefaults standardUserDefaults] valueForKey:@"NavigationType"]) {
                [[NSUserDefaults standardUserDefaults] setInteger:ADVNavigationTypeMenu forKey:@"NavigationType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            self.navigationType = [[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"];
            if (_navigationType == ADVNavigationTypeTab) {
                //[self setupTabbar];
            } else {
                [self setupMenu];
            }
            
            self.window.rootViewController = self.mainVC;
            self.window.backgroundColor = [UIColor blackColor];
            [self.window makeKeyAndVisible];
        }
    }
    
    [FBLoginView class];
    
    return YES;
}


#pragma here we have FB SDK required interface

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // NSLog(@"%d", wasHandled);
    
    // You can add your app-specific url handling code here if needed
    return wasHandled;
}

// FB login error
// do nothing

- (void) loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    AppConfig *config = [AppConfig getInstance];
    config.userIsLogin = 0;
    
    // NSLog(@"FB Login error");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"We have encounter a Facebook login/logout error, we recommend that you check your facebook credential or try it later, if the error persist, please contact with us for further help" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

// FB login success
//

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    
    AppConfig *config = [AppConfig getInstance];
    config.fbstage = 2;
    // NSLog(@"FB Login OK");
    
}

// FB, get user info
// only if we get user info successfully, we will allow
// continue use

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    // NSLog(@"FB User");
    
    // here we store user id, but only one of them
    // suppose there are different FB ids
    // and we only retain the last one
    // to remember that this time, we have facebook token as the only unique identifier
    
    if (user) {
        
        NSString *username = [user objectForKey:@"first_name"];
        NSString *email = [user objectForKey:@"email"];
        NSString *fullname = [user objectForKey:@"name"];
        NSString *token = [user objectForKey:@"id"];
        NSDictionary *location = [user objectForKey:@"location"];
        
        
        User *$user = [User getInstance];
        $user.username = username;
        $user.email = email;
        $user.fullname = fullname;
        $user.token = token;
        $user.location = [location objectForKey:@"name"];
        
        if ([$user exits]) {
            
            AppConfig *config = [AppConfig getInstance];
            config.userIsLogin = 1;
            config.token = token;
            return;
            
        } else {
        
            // here we added user to local storage
            // then we will call service to add it remotely
            // without saving it, we can't use service correclty
        
            [$user add];
        }
        
        NSDictionary *data = @{
                               @"username":username,
                               @"email":email,
                               @"fullname":fullname,
                               @"facebook_token":token,
                               @"facebook_icon": [NSString stringWithFormat:FB_PROFILE_ICON, token],
                               @"location":$user.location
                               };
        
        
        $user.delegate = self;
        [$user login:data];
        
        [self.loginView setHidden:YES];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"We have encounter a Facebook login/logout error, we recommend that you check your facebook credential or try it later, if the error persist, please contact with us for further help" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)onCallback:(NSInteger)type
{
    AppConfig *config = [AppConfig getInstance];
    
    if (type > 0) {
        
        [self.loginView setHidden:NO];
        User *user = [User getInstance];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:user.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    
    } else {
        
        config.userIsLogin = 1;
    }
    
    // if failed to sync the user account
    // we will stay at intro UI
    
    if (config.userIsLogin != 1) {
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"intro" bundle:nil];
        UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"intro_init"];
        self.window.rootViewController = controller;
        [self.window makeKeyAndVisible];
        [FBLoginView class];
        return NO;
    }
    
    
    //
    
    if (config.userIsLogin == 1 && [config.fbfrom isEqualToString:@"application"]) {
        
        
        [ADVThemeManager customizeAppAppearance];
        
        if (true || [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            //self.mainVC = (((UINavigationController *)self.window.rootViewController).viewControllers)[0];
        //} else {
            
            UIStoryboard *storyboard;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                
                storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
                
            } else {
                storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
            }
            
            self.mainVC = [storyboard instantiateInitialViewController];
            
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            if (![[NSUserDefaults standardUserDefaults] valueForKey:@"NavigationType"]) {
                [[NSUserDefaults standardUserDefaults] setInteger:ADVNavigationTypeMenu forKey:@"NavigationType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            self.navigationType = [[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"];
            if (_navigationType == ADVNavigationTypeTab) {
                //[self setupTabbar];
            } else {
                [self setupMenu];
            }
            
            self.window.rootViewController = self.mainVC;
            self.window.backgroundColor = [UIColor blackColor];
            [self.window makeKeyAndVisible];
        }
    }
    
    [FBLoginView class];
    
    //
    // register remote notification
    //
    if (config.userIsLogin == 1) {
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            
            UIUserNotificationType types = UIUserNotificationTypeBadge |
            UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            
            UIUserNotificationSettings *mySettings =
            [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
            
            UIApplication *app = [UIApplication sharedApplication];
            //[[UIApplication sharedApplication].registerForRemoteNotifications];
            [app registerForRemoteNotifications];
            
        } else {
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
        
        
        
    }
    
    return YES;
}

#pragma @module - remote push notification

//
// notification delegate
//

// https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html#//apple_ref/doc/uid/TP40008194-CH103-SW1

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    //const void *devTokenBytes = [devToken bytes];
    //self.registered = YES;
    //[self sendProviderDeviceToken:devTokenBytes]; // custom method
    
#if true
    const uint8_t *bytes = [devToken bytes];
    NSString *token = [NSString stringWithFormat:@""];
    
    for (int i = 0; i < 32; i++) {
        
        token = [token stringByAppendingFormat:@"%0x", bytes[i]];
    }
    
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
    
    AppConfig *config = [AppConfig getInstance];
    config.devToken = devToken;
    config.devTokenString = token;
    config.remoteNotificationRegistered = 0;
    
    //NSLog(@"dev_token = %@", devToken);
    //NSLog(@"dev_token = %@", token);
    
    if (config.userIsLogin == 1) {
        
        User *user = [User getInstance];
        user.delegate = nil;
        
        NSDictionary *values = @{@"user_uuid":user.userUUID, @"token":config.devTokenString};
        [user registerDevToken:values];
        
    }
#endif
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    //NSLog(@"Error in registration. Error: %@", err);
    
    AppConfig *config = [AppConfig getInstance];
    config.devToken = nil;
    config.devTokenString = nil;
    config.remoteNotificationRegistered = 0;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}

#pragma @module - FB Login delegates

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    AppConfig *config = [AppConfig getInstance];
    config.fbstage = 1;
    
    // NSLog(@"FB Logout");
    
    if (config.userIsLogin != 1) {
        return;
    }
    
    
    User *user = [User getInstance];
    [user logout];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"intro" bundle:nil];
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"intro_init"];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    [FBLoginView class];
    
    config.fbfrom = @"application";
    
}

- (void)handleAuthError:(NSError *)error
{
    NSString *alertText;
    NSString *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
        // Error requires people using you app to make an action outside your app to recover
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        [self showMessage:alertText withTitle:alertTitle];
        
    } else {
        // You need to find more information to handle the error within your app
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            //The user refused to log in into your app, either ignore or...
            alertTitle = @"Login cancelled";
            alertText = @"You need to login to access this part of the app";
            [self showMessage:alertText withTitle:alertTitle];
            
        } else {
            // All other errors that can happen need retries
            // Show the user a generic error message
            alertTitle = @"Something went wrong";
            alertText = @"Please retry";
            [self showMessage:alertText withTitle:alertTitle];
        }
    }
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

//===============================
//
//===============================

- (void)setupTabbar {
    if (!self.tabbarVC) {
        UIStoryboard *mainStoryboard;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                                 bundle: nil];
        } else {
            mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        }
        
        UINavigationController *navMag1 = [mainStoryboard instantiateViewControllerWithIdentifier:@"BoardNav"];
        UINavigationController *navMag2 = [mainStoryboard instantiateViewControllerWithIdentifier:@"MapNav"];
        UINavigationController *navMag3 = [mainStoryboard instantiateViewControllerWithIdentifier:@"ElementsNav"];
        UINavigationController *navMag4 = [mainStoryboard instantiateViewControllerWithIdentifier:@"AccountNav"];
        UINavigationController *navMag5 = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsNav"];
        navMag1.ng_tabBarItem = [NGTabBarItem itemWithTitle:@""];
        navMag2.ng_tabBarItem = [NGTabBarItem itemWithTitle:@""];
        navMag3.ng_tabBarItem = [NGTabBarItem itemWithTitle:@""];
        navMag4.ng_tabBarItem = [NGTabBarItem itemWithTitle:@""];
        navMag5.ng_tabBarItem = [NGTabBarItem itemWithTitle:@""];
        
        
        NSArray *viewControllers = [NSArray arrayWithObjects:navMag1, navMag2, navMag3, navMag4,navMag5, nil];
        
        NGTabBarController *tabBarController = [[NGTestTabBarController alloc] initWithDelegate:self];
        
        tabBarController.viewControllers = viewControllers;
        
        [AppDelegate tabBarController:tabBarController setupItemsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        self.tabbarVC = (NGTestTabBarController *)tabBarController;
    }
    
    self.mainVC = _tabbarVC;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - NGTabBarControllerDelegate
////////////////////////////////////////////////////////////////////////

- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position {
    if (NGTabBarIsVertical(position)) {
        return CGSizeMake(150.0f, 40.f);
    } else {
        if (UIInterfaceOrientationIsPortrait(viewController.interfaceOrientation)) {
            return CGSizeMake(self.window.bounds.size.width / _tabbarVC.viewControllers.count, 49.f);
        } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
                   && [UIScreen mainScreen].bounds.size.height == 568)
        {
            return CGSizeMake(142, 31);
        } else {
            return CGSizeMake(120, 31);
        }
    }
}



- (void)setupMenu {
    UIStoryboard *mainStoryboard;
    UIStoryboard *iPad;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                   bundle: nil];
    } else {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
    iPad = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    
    
    if (!self.foldVC) {
        self.foldVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PaperFoldController"];
    }
    
    UINavigationController *navMag1;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        navMag1 = [mainStoryboard instantiateViewControllerWithIdentifier:@"BoardNav"];
    } else {
        navMag1 = [iPad instantiateViewControllerWithIdentifier:@"BoardNav"];
    }
    
    if (!_menuVC) {
        _menuVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SideViewController"];
        _menuVC.delegate = self;
    }
    [_foldVC setRootViewController:navMag1];
    [_foldVC setLeftViewController:_menuVC width:260];
    
    self.mainVC = _foldVC;
}


- (void)togglePaperFold:(id)sender {
    
    if (_foldVC.paperFoldView.state == PaperFoldStateLeftUnfolded) {
        [_foldVC.paperFoldView setPaperFoldState:PaperFoldStateDefault animated:YES];
    } else {
        [_foldVC.paperFoldView setPaperFoldState:PaperFoldStateLeftUnfolded animated:YES];
    }
    
    // lets check notification
    
    User *user = [User getInstance];
    
    user.menuVC = _menuVC;
    [user getNumberOfLatestUpdate];
}


-(void)userDidSwitchToControllerAtIndexPath:(NSIndexPath*)indexPath{
    NSString *controllerIdentifier;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    controllerIdentifier = @"BoardNav";
                    break;
                case 1:
                    controllerIdentifier = @"MapNav";
                    break;
                case 2:
                    controllerIdentifier = @"SettingsNav";
                    break;
                case 3:
                    controllerIdentifier = @"NotesNav";
                    break;
                case 4:
                    controllerIdentifier = @"MapNav";
                    break;
                // invisible, user search only
                case 5:
                    controllerIdentifier = @"UserSearchNav";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    controllerIdentifier = @"AccountNav";
                    break;
                case 1:
                    controllerIdentifier = @"TopBrandsNav";
                    break;
                case 2:
                    controllerIdentifier = @"FollowersNav";
                    break;
                case 3:
                    controllerIdentifier = @"FollowingNav";
                    break;
                case 4:
                    controllerIdentifier = @"NotifyNav";
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    
    UIStoryboard *mainStoryboard;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                   bundle: nil];
    } else {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }
    UINavigationController *nav = [mainStoryboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    [_foldVC setRootViewController:nav];
    [_foldVC.paperFoldView setPaperFoldState:PaperFoldStateDefault animated:YES];
}

- (void)resetAfterTypeChange:(BOOL)cancel {
    UINavigationController *settingsNav;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeTab) {
        [self setupTabbar];
        _tabbarVC.selectedIndex = 4;
        settingsNav = [_tabbarVC.viewControllers lastObject];
        [settingsNav popToRootViewControllerAnimated:NO];
    } else {
        [self setupMenu];
        
        //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
        
        UIStoryboard *mainStoryboard;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                       bundle: nil];
        } else {
            mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        }
        
        settingsNav = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsNav"];
        [_foldVC setRootViewController:settingsNav];
        [_foldVC setLeftViewController:_menuVC width:260];
    }
    
    self.window.rootViewController = self.mainVC;
    
    if (!cancel) {
        UIViewController *settingsVC = settingsNav.viewControllers[0];
        [settingsVC performSegueWithIdentifier:@"selectNavigationTypeNoAnim" sender:settingsVC];
    }
}

+ (AppDelegate *)sharedDelegate {
    if (!sharedDelegate) {
        sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return sharedDelegate;
}


+ (void)customizeTabsForController:(UITabBarController *)tabVC {
    NSArray *items = tabVC.tabBar.items;
    for (int idx = 0; idx < items.count; idx++) {
        UITabBarItem *item = items[idx];
        [ADVThemeManager customizeTabBarItem:item forTab:((SSThemeTab)idx)];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:0.37f green:0.38f blue:0.42f alpha:1.00f], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"OpenSans" size:9], NSFontAttributeName,
      nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"OpenSans" size:9], NSFontAttributeName,
      nil]
                                             forState:UIControlStateSelected];
}


+ (void)tabBarController:(NGTabBarController *)tabBarC setupItemsForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSArray *VCs = tabBarC.viewControllers;
    for (int idx = 0; idx < VCs.count; idx++) {
        UIViewController *VC = VCs[idx];
        
        NSString *imageName = [NSString stringWithFormat:@"tabbar-tab%d", idx+1];
        NSString *selectedImageName = [NSString stringWithFormat:@"tabbar-tab%d-selected", idx+1];
        UIFont *font = nil;
        CGFloat imageOffset = 0;
        //        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        //            imageName = [imageName stringByAppendingString:@"-landscape"];
        //            selectedImageName = [selectedImageName stringByAppendingString:@"-landscape"];
        //            font = [UIFont boldSystemFontOfSize:6];
        //            imageOffset = 2;
        //        }
        VC.ng_tabBarItem.image = [UIImage imageNamed:imageName];
        VC.ng_tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
        
        VC.ng_tabBarItem.titleColor = [UIColor colorWithRed:0.80f green:0.85f blue:0.89f alpha:1.00f];
        VC.ng_tabBarItem.selectedTitleColor = [UIColor whiteColor];
        
        VC.ng_tabBarItem.titleFont = font;
        VC.ng_tabBarItem.imageOffset = imageOffset;
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    AppConfig *config = [AppConfig getInstance];
    
    if (config.userIsLogin == 1) {
        
        NSDictionary *values = @{@"user_uuid":[[User getInstance] userUUID], @"enable":@"1"};
        [[User getInstance] enableAPN:values];
    }    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
#if 0
    AppConfig *config = [AppConfig getInstance];
    
    if (config.userIsLogin == 1) {
        
        NSDictionary *values = @{@"user_uuid":[[User getInstance] userUUID], @"enable":@"1"};
        [[User getInstance] enableAPN:values];
    }
#endif
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // NSLog(@"app = become active");
    [FBSession.activeSession handleDidBecomeActive];
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
}

@end
