//
//  ResetPasswordController.m
//  Pixcell8
//
//  Created by  on 13-10-28.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "ResetPasswordController.h"

@interface ResetPasswordController ()

@end

@implementation ResetPasswordController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setup];
}

- (void)setup
{
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8]];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8]];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.view.backgroundView = nil;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_texture"]]];
    //self.view.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_rest"]];
    
    self.username.borderStyle = UITextBorderStyleNone;
    
    self.cellUsername.imageView.image = [UIImage imageNamed:@"cell_username"];
    
    [self.username setText:@"Email"];
    
    [self.username setTextColor:[UIColor lightGrayColor]];
    
    [self.username setDelegate:self];    
    [self.username setFrame:CGRectMake(44, 0, 250, 44)];
    [self.cellUsername.contentView addSubview:self.username];
}

- (IBAction)onTopbarButtonTouched:(id)sender
{
    
    User *user = [User getInstance];
    
    [self.username sendActionsForControlEvents:UIControlEventEditingDidEnd];
    [self.username resignFirstResponder];
    user.email = self.username.text;
    
    if (user.email) {
        
        user.delegate = self;
        [user forget];
    
    } else {
        
        
    }
    
    NSLog(@"%@", user.email);
    
}

- (BOOL)onCallback:(NSInteger)type
{
    User *user = [User getInstance];
    
    if (user.returnCode > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint" message:user.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint" message:user.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    self.navigationItem.rightBarButtonItem.enabled = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
