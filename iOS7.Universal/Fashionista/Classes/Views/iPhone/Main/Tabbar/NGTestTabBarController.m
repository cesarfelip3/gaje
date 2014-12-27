//
//  NGTestTabBarController.m
//  NGVerticalTabBarControllerDemo
//
//  Created by Tretter Matthias on 24.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGTestTabBarController.h"

#import "ADVTheme.h"

#import "AppDelegate.h"

@interface NGTestTabBarController ()

- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

@implementation NGTestTabBarController

- (id)initWithDelegate:(id<NGTabBarControllerDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        
        self.animation = NGTabBarControllerAnimationNone;
        self.tabBar.tintColor = [UIColor colorWithRed:143.f/255.f green:39.f/255.f blue:47.f/255.f alpha:1.f];
        self.tabBar.itemPadding = 0.f;
        [self setupForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
    return self;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self setupForInterfaceOrientation:toInterfaceOrientation];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation; {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.tabBarPosition = NGTabBarPositionBottom;
        self.tabBar.drawItemHighlight = YES;
        self.tabBar.layoutStrategy = NGTabBarLayoutStrategyCentered;
        self.tabBar.drawGloss = YES;
    } else {
        self.tabBarPosition = NGTabBarPositionBottom;
        self.tabBar.drawItemHighlight = YES;
        self.tabBar.drawGloss = NO;
        self.tabBar.layoutStrategy = NGTabBarLayoutStrategyStrungTogether;
    }
    self.tabBar.backgroundImage = [[ADVThemeManager sharedTheme] tabBarBackground];
    self.tabBar.itemHighlightColor = [UIColor colorWithPatternImage:[[ADVThemeManager sharedTheme] tabBarSelectionIndicator]];
    self.tabBar.clipsToBounds = NO;
    
    [AppDelegate tabBarController:self setupItemsForOrientation:interfaceOrientation];
}

@end
