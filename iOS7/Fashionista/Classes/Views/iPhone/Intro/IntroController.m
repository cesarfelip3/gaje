//
//  IntroController.m
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import "IntroController.h"

@interface IntroController ()

@end

@implementation IntroController

@synthesize navigation = _navigation;
@synthesize banner = _banner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    self.navigation = (InitController *)[self navigationController];
    [self.navigation setNavigationBarHidden:YES];
    
    AppConfig *config = [AppConfig getInstance];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = (CGFloat)(config.screenWidth);
    CGFloat height = (CGFloat)(config.screenHeight) - 140;
    
    CGRect size = CGRectMake(x, y, width, height);
    
    [self.banner setFrame:size];
    
    [self.cellRegister.textLabel setText:@"Register"];
    [self.cellLogin.textLabel setText:@"Login"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
