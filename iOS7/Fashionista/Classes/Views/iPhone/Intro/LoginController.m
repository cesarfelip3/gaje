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
    
    
    AppConfig *config = [AppConfig getInstance];
    if (config.userIsLogin == 1) {
        User *user = [User getInstance];
        [user reload];
        config.token = user.token;
        [self success];
    }
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setText:@""];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
        
        if ([self.username.text length] <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                               message:@"User name or email is required"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([a-zA-Z]{1,})|$"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.username.text options:0 range:NSMakeRange(0, [self.username.text length])];
        
        if (numberOfMatches <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                               message:@"Invalid username or user email"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        
        [textField resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    
    if (textField.tag == 1) {
        if ([textField.text length] <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint" message:@"Password shouldn't be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        [textField resignFirstResponder];
    }
    return YES;
}

#if false

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#endif

@end
