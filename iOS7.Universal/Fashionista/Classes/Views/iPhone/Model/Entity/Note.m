//
//  Note.m
//  Gaje
//
//  Created by hello on 14-7-19.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Note.h"

@implementation Note

+ (id)getInstance {
    static Note *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

//=======================
//
//=======================

- (BOOL)fetchList:(NSMutableArray *)noteArray Token:(NSString *)token
{
    
       
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = @{};
    
    
    [manager POST:[NSString stringWithFormat:API_NOTE_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *resultArray = [data objectForKey:@"notes"];
                NSInteger i = 0;
                
                if ([resultArray count] > 0) {
                    
                    [noteArray removeAllObjects];
                }
                
                for (NSDictionary *item in resultArray) {
                    
                    Note *note = [[Note alloc] init];
                    
                    note.noteUUID = [item objectForKey:@"note_uuid"];
                    note.name = [item objectForKey:@"name"];
                    note.desc = [item objectForKey:@"description"];
                    
                    if (i == 0) {
                        
                        note.selected = YES;
                        i++;
                    } else {
                        
                        note.selected = NO;
                    }
                    
                    [noteArray addObject:note];
                    note = nil;
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
           
        
        // NSLog(@"%@", error);
        // NSLog(@"%@", [operation responseObject]);
        
        self.errorMessage = @"We encounter a network issue, you may check your network connectity or try it later";
        
        [self.delegate onCallback:1];
        
    }];
    
    
    return YES;
}

@end
