//
//  Theme.m
//  Gaje
//
//  Created by hello on 14-7-2.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (id)getInstance {
    static Theme *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.returnCode = 0;
        
    });
    return instance;
}

//=======================
//
//=======================

- (BOOL)fetchList:(NSMutableArray *)themeArray Token:(NSString *)token
{
    
    _returnCode = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = @{};
    
    
    [manager POST:[NSString stringWithFormat:API_THEME_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *resultArray = [data objectForKey:@"themes"];
                NSInteger i = 0;
                
                if ([resultArray count] > 0) {
                    
                    [themeArray removeAllObjects];
                }
                
                for (NSDictionary *item in resultArray) {
                    
                    Theme *theme = [[Theme alloc] init];
                    
                    theme.themeUUID = [item objectForKey:@"theme_uuid"];
                    theme.name = [item objectForKey:@"name"];
                    theme.description = [item objectForKey:@"description"];
                    
                    if (i == 0) {
                        
                        theme.selected = YES;
                        i++;
                    } else {
                    
                        theme.selected = NO;
                    }
                    
                    [themeArray addObject:theme];
                    theme = nil;
                }
                
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            self.delegate == nil || [self.delegate onCallback:0];
            return;
            
        }
        
        self.returnCode = 1;
        self.errorMessage = [responseObject objectForKey:@"message"];
        self.delegate == nil || [self.delegate onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        
        NSLog(@"%@", error);
        NSLog(@"%@", [operation responseObject]);
        
        self.errorMessage = @"We encounter a network issue, you may check your network connectity or try it later";
        
        [self.delegate onCallback:0];
        
    }];
    
    
    return YES;
}

@end
