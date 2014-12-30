//
//  Notification.m
//  Gaje
//
//  Created by hello on 14-12-30.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Notification.h"

@implementation Notification

+ (id)getInstance {
    static Notification *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

//=======================
//
//=======================

- (BOOL)fetchList:(NSMutableArray *)notificationArray Token:(NSString *)token
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = @{};
    
    
    [manager POST:[NSString stringWithFormat:API_NOTIFICATION_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *resultArray = [data objectForKey:@"notifications"];
                NSInteger i = 0;
                
                if ([resultArray count] > 0) {
                    
                    [notificationArray removeAllObjects];
                }
                
                for (NSDictionary *item in resultArray) {
                    
                    Notification *notification = [[Notification alloc] init];
                    
                    notification.notificationUUID = [item objectForKey:@"notification_uuid"];
                    notification.name = [item objectForKey:@"name"];
                    notification.desc = [item objectForKey:@"description"];
                    
                    if (i == 0) {
                        
                        notification.selected = YES;
                        i++;
                    } else {
                        
                        notification.selected = NO;
                    }
                    
                    [notificationArray addObject:notification];
                    notification = nil;
                }
                
                
                
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                
                self.errorMessage = @"";
                
            }
            
            self.delegate == nil || [self.delegate onCallback:0];
            return;
            
        }
        
        
        self.errorMessage = [responseObject objectForKey:@"message"];
        self.delegate == nil || [self.delegate onCallback:1];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        
        NSLog(@"%@", error);
        NSLog(@"%@", [operation responseObject]);
        
        self.errorMessage = @"We encounter a network issue, you may check your network connectity or try it later";
        
        [self.delegate onCallback:1];
        
    }];
    
    
    return YES;
}

@end
