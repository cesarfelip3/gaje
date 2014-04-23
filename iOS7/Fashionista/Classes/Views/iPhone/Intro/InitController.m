//
//  initController.m
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import "InitController.h"

@interface InitController ()

@end

@implementation InitController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setup];
}

- (void)setup
{
    NSLog(@"InitController.setup");
    
#if false
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8],
      NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:14.0],
      NSFontAttributeName,
      nil]];
    
#else
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
