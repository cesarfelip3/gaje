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
    
    self.loginView = [self.loginView initWithReadPermissions:@[@"basic_info", @"email", @"user_likes"]];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)onCallback:(NSInteger)type
{
    self.view.tag = 2;
    
    if (type == 0) {
        
        if ([self.user returnCode] != 0) {
            NSString *message = [self.user errorMessage];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        [self success];
    }
    
    if (type == 1) {
        if ([self.user returnCode] != 0) {
            NSString *message = [self.user errorMessage];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        [self success];
    }
    
    return YES;
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

@end
