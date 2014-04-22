//
//  SecondViewController.m
//  
//
//  Created by Valentin Filip on 7/9/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "ElementsViewController.h"
#import "ADVTheme.h"
#import "RCSwitchOnOff.h"
#import "ADVProgressBar.h"
#import "SSTextField.h"
#import "AppDelegate.h"

#import "StoreCell.h"
#import "DataSource.h"


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.9;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

CGFloat animatedDistance;

@interface ElementsViewController ()

@property (nonatomic, strong) ADVProgressBar        *progressBar;

@end



@implementation ElementsViewController

@synthesize scrollView;
@synthesize textField;

- (void)viewDidLoad {
    [super viewDidLoad];
    [ADVThemeManager customizeView:self.view];
    
    UIImageView *titleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
    self.navigationItem.titleView = titleImageV;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeMenu) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(0, 0, 40, 30);
        [menuButton setImage:[UIImage imageNamed:@"navigation-btn-menu"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    }
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 40, 30);
    [btnSearch setImage:[UIImage imageNamed:@"navigation-btn-settings"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    self.imgVBkg.image = [[UIImage imageNamed:@"background-content"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    self.imgVBubble.image = [[UIImage imageNamed:@"baloon"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)];
    
    CGFloat switchHeight = 32, progressHeight = 10;
    
    self.progressBar = [[ADVProgressBar alloc] initWithFrame:CGRectMake(44, CGRectGetMaxY(self.sliderView.frame)  + 10, 231, progressHeight)];
    self.progressBar.progress = 0.5;
    [self.scrollView addSubview:self.progressBar];
    
    RCSwitchOnOff* onSwitch = [[RCSwitchOnOff alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(textField.frame)  + 10, 72, switchHeight)];
    [onSwitch setOn:YES];    
    [self.scrollView addSubview:onSwitch];
    
    RCSwitchOnOff* offSwitch = [[RCSwitchOnOff alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(onSwitch.frame)  + 10, 72, switchHeight)];
    [offSwitch setOn:NO];    
    [self.scrollView addSubview:offSwitch];
    
    self.buttonFirst.titleLabel.font =  [UIFont fontWithName:@"Avenir-Heavy" size:15];
    self.buttonSecond.titleLabel.font =  [UIFont fontWithName:@"Avenir-Heavy" size:15];
    
    CGRect frameSegm = self.segment.frame;
    frameSegm.size.height = 47;
    self.segment.frame = frameSegm;
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
    
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 31)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor colorWithRed:0.24f green:0.24f blue:0.24f alpha:1.00f];
    textField.placeholderTextColor = [UIColor colorWithRed:0.50f green:0.50f blue:0.50f alpha:1.00f];
    textField.font = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:15];
    
    
    CGRect frameBkg = self.imgVBkg.frame;
    frameBkg.size.height = CGRectGetMaxY(offSwitch.frame) + 10;
    self.imgVBkg.frame = frameBkg;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, CGRectGetMaxY(offSwitch.frame) + 25);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

- (IBAction)sliderValueChanged:(id)sender {    
    if([sender isKindOfClass:[UISlider class]]) {
        UISlider *s = (UISlider*)sender;
        
        if(s.value >= 0.0 && s.value <= 1.0) {
            if (self.progressBar) {
                self.progressBar.progress = s.value;
            }
        }
    }
}

- (void)viewFinishedLayout:(id)sender {
    
}

- (void)clearTextField:(id)sender {
    self.textField.text = @"";
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)aTextField {
    CGRect textFieldRect = [self.scrollView.window convertRect:aTextField.bounds fromView:textField];
    CGRect viewRect = [self.scrollView.window convertRect:self.scrollView.bounds fromView:self.scrollView];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = 
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.scrollView setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.scrollView setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
    [aTextField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setSearchBar:nil];
    [self setButtonFirst:nil];
    [self setButtonSecond:nil];
    [self setImgVBkg:nil];
    [self setImgVBubble:nil];
    [super viewDidUnload];
}

#pragma mark - Utils

- (BOOL)isTall {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
        && [UIScreen mainScreen].bounds.size.height == 568)
    {
        return YES;
    }
    return NO;
}


@end
