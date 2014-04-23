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
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8],
      NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Helvetica-Bold" size:16.0],
      NSFontAttributeName,
      nil]];

#if false
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8]];
    
    [self.navigationBar setTintColor:[UIColor colorWithRed:125/255.0 green:178/255.0 blue:15/255.0 alpha:0.8]];
    self.navigationBar.translucent = NO;
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
