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

static AppDelegate *sharedDelegate;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    Bootstrap *bootstrap = [Bootstrap getInstance];
    [bootstrap bootstrap];
    
    AppConfig *config = [AppConfig getInstance];
    
    
    config.fbfrom = @"application";
    
    User *user = [User getInstance];
    [user auth];
    
#if true
    
    if (config.userIsLogin == 1) {
    
        [ADVThemeManager customizeAppAppearance];
        // Override point for customization after application launch.

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            //self.mainVC = (((UINavigationController *)self.window.rootViewController).viewControllers)[0];
        } else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            
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
    } else {
        
    }
    
    [FBLoginView class];
#endif
    
    return YES;
}

#if true
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    NSLog(@"%d", wasHandled);
    
    // You can add your app-specific url handling code here if needed
    return wasHandled;
}
#endif

//===============================
//
//===============================
- (void) loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    AppConfig *config = [AppConfig getInstance];
    config.userIsLogin = 0;
    
    NSLog(@"FB Login error %@", error);
    
}

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"FB user = %@", user);
    
    // here we store user id, but only one of them
    // suppose there are different FB ids
    // and we only retain the last one
    
    if (user) {
        
        NSString *username = [user objectForKey:@"first_name"];
        NSString *email = [user objectForKey:@"email"];
        NSString *fullname = [user objectForKey:@"name"];
        NSString *token = [user objectForKey:@"id"];
        
        User *$user = [User getInstance];
        $user.username = username;
        $user.email = email;
        $user.fullname = fullname;
        $user.token = token;
        
        if ([$user exits]) {
            
            AppConfig *config = [AppConfig getInstance];
            config.userIsLogin = 1;
            config.token = token;
            $user.returnCode = 0;
            return;
        
        }
        
        [$user add];
        NSDictionary *data = @{@"username":username, @"email":email, @"fullname":fullname, @"facebook_token":token, @"facebook_icon": [NSString stringWithFormat:FB_PROFILE_ICON, token]};
        $user.delegate = self;
        [$user login:data];
        
    }
    
    
}

- (BOOL)onCallback:(NSInteger)type
{
    User *user = [User getInstance];
    
    if (user.returnCode > 0) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:user.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    AppConfig *config = [AppConfig getInstance];
    config.userIsLogin = 1;
    
#if true
    
    if (config.userIsLogin != 1) {
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"intro" bundle:nil];
        UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"intro_init"];
        self.window.rootViewController = controller;
        [self.window makeKeyAndVisible];
        [FBLoginView class];
        return NO;
    }
    
    
    if (config.userIsLogin == 1 && [config.fbfrom isEqualToString:@"application"]) {
        
        
        [ADVThemeManager customizeAppAppearance];
        // Override point for customization after application launch.
        
#if true
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            //self.mainVC = (((UINavigationController *)self.window.rootViewController).viewControllers)[0];
        } else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            
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
#endif
    } else {
        
    }
    
    [FBLoginView class];
    
#endif
    
    return YES;
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    
    AppConfig *config = [AppConfig getInstance];
    config.fbstage = 2;
    NSLog(@"FB Login");

}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    AppConfig *config = [AppConfig getInstance];
    config.fbstage = 1;
    
    NSLog(@"FB Logout");
    
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


//===============================
//
//===============================

- (void)setupTabbar {
    if (!self.tabbarVC) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                                 bundle: nil];
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
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    if (!self.foldVC) {
        self.foldVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PaperFoldController"];
    }
    
    UINavigationController *navMag1 = [mainStoryboard instantiateViewControllerWithIdentifier:@"BoardNav"];
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
                    controllerIdentifier = @"FollowersNav";
                    break;
                case 3:
                    controllerIdentifier = @"FollowingNav";
                    break;
                case 4:
                    controllerIdentifier = @"MapNav";
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
                    controllerIdentifier = @"SettingsNav";
                    break;
                case 2:
                    controllerIdentifier = @"NotesNav";
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
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
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                                 bundle: nil];
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
      [UIColor colorWithRed:0.37f green:0.38f blue:0.42f alpha:1.00f], UITextAttributeTextColor,
      [UIFont fontWithName:@"OpenSans" size:9], UITextAttributeFont,
      nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIFont fontWithName:@"OpenSans" size:9], UITextAttributeFont,
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
    
    AppConfig *config = [AppConfig getInstance];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    AppConfig *config = [AppConfig getInstance];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"app = become active");
    
    AppConfig *config = [AppConfig getInstance];
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    AppConfig *config = [AppConfig getInstance];
    
}

@end
