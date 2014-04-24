//
//  LoginController.m
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//
#import "LoginController.h"

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
    
    self.loginView.readPermissions = @[@"basic_info", @"email", @"user_likes", @"user_location"];
    self.loginView.delegate = self;
    
    AppConfig *config = [AppConfig getInstance];
    if (config.userIsLogin == 1) {
        User *user = [User getInstance];
        [user reload];
        config.token = user.token;
        [self success];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@", self.loginView);
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
    AppConfig *config = [AppConfig getInstance];
    config.userIsLogin = 0;
    
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


#if false

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
