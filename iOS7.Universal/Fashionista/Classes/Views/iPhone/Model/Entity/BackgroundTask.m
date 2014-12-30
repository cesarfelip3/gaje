//
//  BackgroundTask.m
//  Gaje
//
//  Created by hello on 14-12-31.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "BackgroundTask.h"
#import "Notification.h"

@implementation BackgroundTask

+ (id)getInstance {
    static BackgroundTask *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (void)initTask
{
    
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                        target:self
                                                      selector:@selector(task)
                                                      userInfo:nil
                                                       repeats:YES];
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    self.data = [[NSMutableArray alloc] init];
    
    //
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.view = [[UIView alloc] init];
    self.view.frame = CGRectMake(0, 64, width, 44);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.view.alpha = 0.8;
    
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(-20, 20);
    self.view.layer.shadowRadius = 2.0f;
    
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 1;
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
 
    [self.view addSubview:self.messageLabel];
    
    
}

- (void)task
{
    NSLog(@"hello");
    
    Notification *n = [Notification getInstance];
    
    n.delegate = self;
    [n fetchList:self.data Token:@""];    
}

- (BOOL)onCallback:(NSInteger)type
{
    NSLog(@"callback");
    
    if ([self.data count] > 0) {
        NSLog(@"%@", self.data);
        
        AppConfig *config = [AppConfig getInstance];
        Notification *notification = [self.data objectAtIndex:0];
        
        if ([notification.notificationUUID isEqualToString:config.notificationUUID]){
            return NO;
        }
        
        config.notificationUUID = notification.notificationUUID;
        
        //[self.messageLabel setText:@"hello world"];
        //[[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.view];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:notification.desc delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    
    return NO;
}

@end
