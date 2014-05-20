//
//  LoginController.m
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//
#import "LoginController.h"
#import "AppDelegate.h"

@interface LoginController ()

@end

@implementation LoginController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO];
    
    [self setup];
}

- (void)setup
{
    
#if true
    UINavigationBar *navbar = self.navigationController.navigationBar;
    
    navbar.layer.shadowColor = [UIColor blackColor].CGColor;
    navbar.layer.shadowOpacity = 0.2f;
    navbar.layer.shadowRadius = 0.1f;
    navbar.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    //[navbar setBackgroundImage:[UIImage imageNamed:@"navigationBackground-7"] forBarMetrics:UIBarMetricsDefault];

    //[navbar setTintColor:[UIColor whiteColor]];
    
#endif
    
#if true
    self.view.backgroundView = nil;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]]];
#endif
    
    // why everytime is automatically login?
    // FB saved some state in application....
    // and everytime you will get delegate called....
    // and user info too
    
    [AppDelegate sharedDelegate].loginView = self.loginView;
    
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginView.delegate = [AppDelegate sharedDelegate];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI completionHandler:(FBSessionStateHandler)handler {
    
    // We pass this permissions array into our request.
    // I only request email, but there are many more options.
    //
    NSArray *permissions = @[@"email", @"basic_info"];
    
    return [FBSession
            openActiveSessionWithReadPermissions:permissions
            allowLoginUI:allowLoginUI
            completionHandler:^(FBSession *session,
                                FBSessionState state,
                                NSError *error) {
                
                if (handler)
                    handler(session, state, error);
            }];
}

- (void) loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    AppConfig *config = [AppConfig getInstance];
    config.userIsLogin = 0;
    
    NSLog(@"FB Login error");
    
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
        
        [$user add];
        
        
    }
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    
    AppConfig *config = [AppConfig getInstance];
    config.userIsLogin = 1;
    
    NSLog(@"FB Login");
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    User *user = [User getInstance];
    [user logout];
    
    
    NSLog(@"FB Logout");
    
}

- (void)success {
    
#if false
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    MainController *initialSettingsVC = [settingsStoryboard instantiateInitialViewController];
    initialSettingsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:initialSettingsVC animated:YES completion:nil];
#endif
    //[[Posts getInstance] loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
