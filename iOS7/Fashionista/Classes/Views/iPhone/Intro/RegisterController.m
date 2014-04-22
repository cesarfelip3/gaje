//
//  RegisterController.m
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import "RegisterController.h"

@interface RegisterController ()

@end

@implementation RegisterController

@synthesize navigation = _navigation;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigation = (InitController *)[self navigationController];
    [self.navigation setNavigationBarHidden:NO];
    [self setup];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigation setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:YES];
}

- (void)setup
{
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8]];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8]];
    
    //self.view.backgroundView = nil;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundView = nil;
    self.view.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    //self.view.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_rest"]];
    
    self.email.borderStyle = UITextBorderStyleNone;
    self.username.borderStyle = UITextBorderStyleNone;
    self.password.borderStyle = UITextBorderStyleNone;
    
    self.username.tag = 0;
    self.password.tag = 1;
    self.email.tag = 2;
    
    self.cellEmail.imageView.image = [UIImage imageNamed:@"email"];
    self.cellUsername.imageView.image = [UIImage imageNamed:@"cell_username"];
    self.cellPassword.imageView.image = [UIImage imageNamed:@"cell_password"];
    
    [self.email setText:@"Your Email"];
    [self.username setText:@"Your Username"];
    [self.password setText:@"Your password"];
    
    [self.email setTextColor:[UIColor lightGrayColor]];
    [self.username setTextColor:[UIColor lightGrayColor]];
    [self.password setTextColor:[UIColor lightGrayColor]];
    
    [self.email setDelegate:self];
    [self.username setDelegate:self];
    [self.password setDelegate:self];
    
    [self.email setFrame:CGRectMake(44, 0, 250, 44)];
    [self.cellEmail.contentView addSubview:self.email];
    
    [self.username setFrame:CGRectMake(44, 0, 250, 44)];
    [self.cellUsername.contentView addSubview:self.username];
    
    [self.password setFrame:CGRectMake(44, 0, 250, 44)];
    [self.cellPassword.contentView addSubview:self.password];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [textField setText:@""];
    [textField setTextColor:[UIColor grayColor]];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
        
        if ([textField.text length] <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                               message:@"User name shouldn't be empty"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z]{1,}$"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:textField.text options:0 range:NSMakeRange(0, [textField.text length])];
        
        if (numberOfMatches <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                               message:@"User name is letters a-z or A-Z"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        
        [textField resignFirstResponder];
        [self.email becomeFirstResponder];
    }
    
    if (textField.tag == 1) {
        if ([textField.text length] <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                               message:@"Password shouldn't be empty"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        [textField resignFirstResponder];
    }
    
    if (textField.tag == 2) {
        
        if ([textField.text length] <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                               message:@"Email shouldn't be empty"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:textField.text options:0 range:NSMakeRange(0, [textField.text length])];
        
        if (numberOfMatches <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                               message:@"Email format is not valid"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        
        [textField resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onCompleteAction:(id)sender
{
    
    if ([self.username.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                           message:@"User name shouldn't be empty"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alert show];
    }
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z]{1,}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.username.text options:0 range:NSMakeRange(0, [self.username.text length])];
    
    if (numberOfMatches <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                           message:@"User name is letters a-z or A-Z"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.email.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                           message:@"Email shouldn't be empty"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alert show];
    }
    
    error = NULL;
    regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    numberOfMatches = 0;
    numberOfMatches = [regex numberOfMatchesInString:self.email.text options:0 range:NSMakeRange(0, [self.email.text length])];
    
    if (numberOfMatches <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                           message:@"Email format is not valid"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alert show];
    }
    
    if ([self.password.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                           message:@"Password shouldn't be empty"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.user = [User getInstance];
    self.user.delegate = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 2)];
    
    [self.user signup:self.username.text Email:self.email.text Password:self.password.text];
    
    //_timeout = 0;
    //[self performSelector:@selector(dataIsReady) withObject:nil afterDelay:1];
}


- (BOOL)onCallback:(NSInteger)type
{
    
    if (type == 0) {
        
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


@end
