//
//  Auth.m
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import "User.h"
#import "LoginController.h"
#import "Image.h"
#import "Brander.h"
#import "MenuViewController.h"

@implementation User


+ (id)getInstance {
    static User *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

// when we get FB id, we will login to server and create user for it
// then we will use this user uuid to upload image

- (BOOL)login:(NSDictionary *)data {
    
    self.errorMessage = @"";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSString *api = [NSString stringWithFormat:API_USER_LOGIN, API_BASE_URL, API_BASE_VERSION];
    NSDictionary *parameters = data;
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"User.login: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
    
           
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            if ([data count] <= 0) {
                self.errorMessage = @"empty data from API";
                [self.delegate onCallback:1];
                return;
            }
           
            NSString *uuid = [data objectForKey:@"user_uuid"];
            
            if ([uuid isEqual:[NSNull null]]) {
                self.errorMessage = @"User identifier error";
                [self.delegate onCallback:1];
                return;
            }
            
            AppConfig *config = [AppConfig getInstance];
            config.uuid = uuid;
          
            self.userUUID = uuid;
            uuid = [data objectForKey:@"theme_uuid"];
            
            self.themeUUID = uuid;
            [self updateUUID];
            
            self.errorMessage = @"";
            [self.delegate onCallback:0];
            
        } else {
            
            self.errorMessage = [responseObject objectForKey:@"message"];
            [self.delegate onCallback:1];
        }
        
        return;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"Error: %@", operation.response);
        NSLog(@"Error: %@", operation.responseObject);
        
        NSString *message = [operation.responseObject objectForKey:@"message"];
        
        if (message != nil && ![message isEqual:[NSNull null]]) {
            
            self.errorMessage = message;
            //return;
        }
            
        self.errorMessage = [NSString stringWithFormat:@"We got unknow error from server, and networking functionality in app will be not available, you can go 'setting' page and try to re-connect to the server, if there are any question, please send us email %@", CONTACT_EMAIL];
        [self.delegate onCallback:1];
        
    }];
    
    return NO;
}

- (BOOL)logout
{
    if (![self.db open]) {
        return NO;
    }
    
    [self remove];
    
    AppConfig *config = [AppConfig getInstance];
    config.userIsLogin = 0;
    config.token = @"";
    
    return YES;
}

- (BOOL)add
{
    if (![self.db open]) {
        return NO;
    }
    
    self.username = [self escape:self.username];
    self.desc = [self escape:self.desc];
    self.fullname = [self escape:self.fullname];
    self.email = [self escape:self.email];
    self.city = [self escape:self.city];
    self.state = [self escape:self.state];
    self.country = [self escape:self.country];
    self.address = [self escape:self.address];
    self.postcode = [self escape:self.postcode];
    self.postcode = [self escape:self.phone];
    self.icon = [self escape:self.icon];
    self.token = [self escape:self.token];
    self.phone = [self escape:self.phone];
    self.location = [self escape:self.location];
    
    self.userUUID = [self escape:self.userUUID];
    
    self.themeUUID = [self escape:self.themeUUID];
    
    
    [self.db executeUpdateWithFormat:@"DELETE FROM user WHERE token=%@", self.token];
    
    [self.db executeUpdateWithFormat:@"INSERT INTO user (user_uuid, username, description, fullname, email, token, location, theme_uuid) VALUES (%@, %@, %@, %@, %@, %@, %@, %@);", self.userUUID, self.username, self.desc, self.fullname, self.email, self.token, self.location, self.themeUUID];
    
    
    return YES;
}

- (BOOL)update
{
    if (![self.db open]) {
        return NO;
    }
    
    self.username = [self escape:self.username];
    self.desc = [self escape:self.desc];
    self.fullname = [self escape:self.fullname];
    self.email = [self escape:self.email];
    self.city = [self escape:self.city];
    self.state = [self escape:self.state];
    self.country = [self escape:self.country];
    self.address = [self escape:self.address];
    self.postcode = [self escape:self.postcode];
    self.postcode = [self escape:self.phone];
    self.icon = [self escape:self.icon];
    self.token = [self escape:self.token];
    self.phone = [self escape:self.phone];
    
    [self.db executeUpdateWithFormat:@"UPDATE user SET username=%@, description=%@, fullname=%@, email=%@, city=%@, state=%@, country=%@, address=%@, zipcode＝%@, phone=%@, picture=%@, token=%@ WHERE user_id=%ld", self.username, self.desc, self.fullname, self.email, self.city, self.state, self.country, self.address, self.postcode, self.phone, self.icon, self.token, (long)(self.userId)];
    
    return YES;
}

- (BOOL)updateUUID
{
    if (![self.db open]) {
        return NO;
    }
    
    self.userUUID = [self escape:self.userUUID];
    self.themeUUID = [self escape:self.themeUUID];
    
    [self.db executeUpdateWithFormat:@"UPDATE user SET user_uuid=%@, theme_uuid=%@ WHERE token=%@", self.userUUID, self.themeUUID, self.token];
    
    return YES;
}

- (BOOL)remove
{
    if (![self.db open]) {
        return NO;
    }
    
    self.token = [self escape:self.token];
    [self.db executeUpdateWithFormat:@"DELETE FROM user WHERE token=%@", self.token];
    
    return YES;
}

- (BOOL)exits
{
    if (![self.db open]) {
        return NO;
    }
    
    FMResultSet *result;
    
    result = [self.db executeQueryWithFormat:@"SELECT * FROM user WHERE token=%@", self.token];
    
    self.userId = 0;
    
    while ([result next]) {
        
        return YES;
    }
    
    return NO;
}

- (BOOL)auth
{
    if (![self.db open]) {
        return NO;
    }
    
    FMResultSet *result;
    result = [self.db executeQueryWithFormat:@"SELECT * FROM user"];
    
    while ([result next]) {
        
        self.userId = [result intForColumn:@"user_id"];
        self.username = [result stringForColumn:@"username"];
        self.desc = [result stringForColumn:@"description"];
        
        self.email = [result stringForColumn:@"email"];
        
        self.fullname = [result stringForColumn:@"fullname"];
        self.city = [result stringForColumn:@"city"];
        self.state = [result stringForColumn:@"state"];
        self.country = [result stringForColumn:@"country"];
        self.address = [result stringForColumn:@"address"];
        self.postcode = [result stringForColumn:@"zipcode"];
        self.phone = [result stringForColumn:@"phone"];
        
        self.token = [result stringForColumn:@"token"];
        self.userUUID = [result stringForColumn:@"user_uuid"];
        self.location = [result stringForColumn:@"location"];
        
        self.themeUUID = [result stringForColumn:@"theme_uuid"];
        
        self.icon = self.token;
        self.iconurl = [NSString stringWithFormat:FB_PROFILE_ICON, self.token];
        
        AppConfig *config = [AppConfig getInstance];
        config.userIsLogin = 1;
        config.uuid = self.userUUID;
        config.token = self.token;        
    }
    
    return YES;
}

- (BOOL)fetchByToken:(NSString *)token
{
    if (![self.db open]) {
        return NO;
    }
    
    FMResultSet *result;
    
    token = [self escape:token];
    
    result = [self.db executeQueryWithFormat:@"SELECT * FROM user WHERE token=%@", token];
    
    self.userId = 0;
    
    while ([result next]) {
        
        self.userId = [result intForColumn:@"user_id"];
        self.username = [result stringForColumn:@"username"];
        self.desc = [result stringForColumn:@"description"];
        
        self.email = [result stringForColumn:@"email"];
        
        self.fullname = [result stringForColumn:@"fullname"];
        self.city = [result stringForColumn:@"city"];
        self.state = [result stringForColumn:@"state"];
        self.country = [result stringForColumn:@"country"];
        self.address = [result stringForColumn:@"address"];
        self.postcode = [result stringForColumn:@"zipcode"];
        self.phone = [result stringForColumn:@"phone"];
        
        self.token = [result stringForColumn:@"token"];
    }
    
    return YES;
}

@end
