//
//  Auth.m
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import "User.h"
#import "LoginController.h"

@implementation User


+ (id)getInstance {
    static User *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.returnCode = 0;
        
    });
    return instance;
}

// when we get FB id, we will login to server and create user for it
// then we will use this user uuid to upload image

- (BOOL)login:(NSDictionary *)data {
    
    self.returnCode = 1;
    self.errorMessage = @"";
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = data;
    
    [manager POST:API_USER_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"JSON: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
    
           
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            if ([data count] <= 0) {
                
                self.returnCode = 1;
                self.errorMessage = @"empty data from API";
                [self.delegate onCallback:0];
                return;
            }
           
            NSString *uuid = [data objectForKey:@"user_uuid"];
            
            AppConfig *config = [AppConfig getInstance];
            config.uuid = uuid;
          
            self.returnCode = 0;
            self.errorMessage = @"";
            
            
            [self.delegate onCallback:0];
            
            return;
        } else {
            
            self.returnCode = 1;
            self.errorMessage = [responseObject objectForKey:@"message"];
            [self.delegate onCallback:0];
        }
        
        return;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"Error: %@", error);
        
        self.returnCode = 1;
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:0];
    }];
    
    return NO;
}

- (BOOL)signup:(NSString *)username Email:(NSString *)email Password:(NSString *)password {
    
    self.returnCode = 1;
    self.errorMessage = @"";
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"username": username, @"email": email, @"password": password, @"password_confirmation":password};
    [manager POST:API_USER_REGISTER parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            self.token = [responseObject objectForKey:@"token"];
            
            NSDictionary *user = [responseObject objectForKey:@"user"];
            NSDictionary *profile = [user objectForKey:@"profile"];
            
            self.userId = [((NSString *)[user objectForKey:@"userId"]) integerValue];
            self.username = [self escape:[user objectForKey:@"username"]];
            
            self.description = @"";
            
            self.email = email;
            
            if ([profile count] > 0) {
                
                self.description = [self escape:[profile objectForKey:@"profile_description"]];
                self.profileIcon = [self escape:[profile objectForKey:@"profile_picture"]];
                
                self.fullname = [self escape:[profile objectForKey:@"full_name"]];
                self.birthday = [self escape:[profile objectForKey:@"birthday"]];
                self.paypal = [self escape:[profile objectForKey:@"paypal_email"]];
                self.city = [self escape:[profile objectForKey:@"city"]];
                self.state = [self escape:[profile objectForKey:@"state"]];
                self.country = [self escape:[profile objectForKey:@"country"]];
                self.address = [self escape:[profile objectForKey:@"address"]];
                self.postcode = [self escape:[profile objectForKey:@"postal_code"]];
                self.phone = [self escape:[profile objectForKey:@"telephone"]];
                
                self.profileIcon = [self escape:[profile objectForKey:@"profile_picture"]];
                
                if ([self.profileIcon isEqualToString:@""]) {
                    self.profileIconUrl = nil;
                } else {
                    self.profileIconUrl = [NSString stringWithFormat:@"%@%@", URL_IMAGE_PROFILE_PATH, self.profileIcon];
                }
            }
            
            self.returnCode = 0;
            self.errorMessage = @"";
            
            [self add];
            //[((RegisterController *)self.delegate) onCallback:0];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return;
        }
        
        self.returnCode = 1;
        self.errorMessage = [responseObject objectForKey:@"error"];
        //[((RegisterController *)self.delegate) onCallback:0];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //NSLog(@"Error: %@", error);
        self.returnCode = 1;
        self.errorMessage = @"Network failed";
        
        //[((RegisterController *)self.delegate) onCallback:0];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    return NO;
}

- (BOOL)forget
{
 
    //NSLog(@"forget");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:API_USER_PASSWORD, self.email] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSString *status;
        
        if ([responseObject count] <= 0) {
            status = nil;
        } else {
            status = [responseObject objectForKey:@"status"];
        }
        
        if ([status isEqualToString:@"success"]) {
        }
        
        if (status == nil) {
            self.errorMessage = @"Didn't find your email at website";
        } else {
            self.errorMessage = [responseObject objectForKey:@"message"];
        }
        //[self.delegate onCallback:0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //NSLog(@"Error: %@", error);
        self.errorMessage = @"Network failed";
        
        //[self.delegate onCallback:0];
        
    }];
    
    return YES;
}

- (BOOL)updateProfile:(NSDictionary *)values {
    
    self.returnCode = 1;
    self.errorMessage = @"";

#if false
    full_name
    paypal_email
    birthday
    profile_picture
    profile_description
    sales_public (value 1 or 0)
    purchase_public (value 1 or 0)
    address
    city
    state
    postal_code
    country
    telephone
#endif
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = values;
    [manager POST:[NSString stringWithFormat:@"%@%ld", API_USER_PROFILE_UPDATE, (long)(self.userId)] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            
            self.returnCode = 0;
            self.errorMessage = @"";
            
            [self add];
            //[((LoginController *)self.delegate) onCallback:0];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return;
        }
        
        self.returnCode = 1;
        self.errorMessage = [responseObject objectForKey:@"error"];
        //[((RegisterController *)self.delegate) onCallback:0];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //NSLog(@"Error: %@", error);
        self.returnCode = 1;
        self.errorMessage = @"Network failed";
        
        //[((RegisterController *)self.delegate) onCallback:0];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    return NO;
}

- (BOOL)login
{
    if (![self.db open]) {
        return NO;
    }
    
    
    return YES;
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
    self.description = [self escape:self.description];
    self.fullname = [self escape:self.fullname];
    self.email = [self escape:self.email];
    self.birthday = [self escape:self.birthday];
    self.city = [self escape:self.city];
    self.state = [self escape:self.state];
    self.country = [self escape:self.country];
    self.address = [self escape:self.address];
    self.postcode = [self escape:self.postcode];
    self.postcode = [self escape:self.phone];
    self.profileIcon = [self escape:self.profileIcon];
    self.token = [self escape:self.token];
    self.phone = [self escape:self.phone];
    
    
    [self.db executeUpdateWithFormat:@"DELETE FROM user WHERE token=%@", self.token];
    
    [self.db executeUpdateWithFormat:@"INSERT INTO user (username, description, fullname, email, birthday, city, state, country, address, zipcode, phone, picture, token) VALUES (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@);", self.username, self.description, self.fullname, self.email, self.birthday, self.city, self.state, self.country, self.address, self.postcode, self.phone, self.profileIcon, self.token];
    
    
    return YES;
}

- (BOOL)update
{
    if (![self.db open]) {
        return NO;
    }
    
    [self.db executeUpdateWithFormat:@"UPDATE user SET username=%@, description=%@, fullname=%@, email=%@, paypal=%@, birthday=%@, city=%@, state=%@, country=%@, address=%@, zipcode＝%@, phone=%@, picture=%@, token=%@ WHERE user_id=%ld", self.username, self.description, self.fullname, self.email, self.paypal, self.birthday, self.city, self.state, self.country, self.address, self.postcode, self.phone, self.profileIcon, self.token, (long)(self.userId)];
    
    return YES;
}

- (BOOL)remove
{
    if (![self.db open]) {
        return NO;
    }
    
    self.token = [self escape:self.token];
    
    [self.db executeUpdateWithFormat:@"DELETE FROM user WHERE user_id=%d", self.userId];
    [self.db executeUpdateWithFormat:@"DELETE FROM user WHERE token=%@", self.token];
    
    return YES;
}

- (BOOL)exits
{
    if (![self.db open]) {
        return NO;
    }
    
    FMResultSet *result;
    
    result = [self.db executeQueryWithFormat:@"SELECT * FROM user"];
    
    self.userId = 0;
    
    while ([result next]) {
        
        self.userId = [result intForColumn:@"user_id"];
        self.username = [result stringForColumn:@"username"];
        self.description = [result stringForColumn:@"description"];
        
        self.email = [result stringForColumn:@"email"];
        self.profileIcon = [result stringForColumn:@"picture"];
        
        if (![[self.profileIcon stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            self.profileIconUrl = [NSString stringWithFormat:@"%@%@", URL_IMAGE_PATH, self.profileIcon];
        } else {
            self.profileIconUrl = nil;
        }
        
        self.fullname = [result stringForColumn:@"fullname"];
        self.birthday = [result stringForColumn:@"birthday"];
        self.paypal = [result stringForColumn:@"paypal"];
        self.city = [result stringForColumn:@"city"];
        self.state = [result stringForColumn:@"state"];
        self.country = [result stringForColumn:@"country"];
        self.address = [result stringForColumn:@"address"];
        self.postcode = [result stringForColumn:@"zipcode"];
        self.phone = [result stringForColumn:@"phone"];
        
        self.token = [result stringForColumn:@"token"];
        
        return YES;
    }
    
    return NO;
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
        self.description = [result stringForColumn:@"description"];
        
        self.email = [result stringForColumn:@"email"];
        self.profileIcon = [result stringForColumn:@"picture"];
        
        if (![[self.profileIcon stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            self.profileIconUrl = [NSString stringWithFormat:@"%@%@", URL_IMAGE_PATH, self.profileIcon];
        } else {
            self.profileIconUrl = nil;
        }
        
        self.fullname = [result stringForColumn:@"fullname"];
        self.birthday = [result stringForColumn:@"birthday"];
        self.paypal = [result stringForColumn:@"paypal"];
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

- (BOOL)reload
{
    if (![self.db open]) {
        return NO;
    }
    
    FMResultSet *result;
    
    result = [self.db executeQuery:@"SELECT * FROM user"];
    
    while ([result next]) {
        
        self.userId = [result intForColumn:@"user_id"];
        self.username = [result stringForColumn:@"username"];
        self.description = [result stringForColumn:@"description"];
        
        self.email = [result stringForColumn:@"email"];
        self.profileIcon = [result stringForColumn:@"picture"];
        
        if (![[self.profileIcon stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            self.profileIconUrl = [NSString stringWithFormat:@"%@%@", URL_IMAGE_PATH, self.profileIcon];
        } else {
            self.profileIconUrl = nil;
        }
        
        self.fullname = [result stringForColumn:@"fullname"];
        self.birthday = [result stringForColumn:@"birthday"];
        self.paypal = [result stringForColumn:@"paypal"];
        self.city = [result stringForColumn:@"city"];
        self.state = [result stringForColumn:@"state"];
        self.country = [result stringForColumn:@"country"];
        self.address = [result stringForColumn:@"address"];
        self.postcode = [result stringForColumn:@"zipcode"];
        self.phone = [result stringForColumn:@"phone"];
        
        self.token = [result stringForColumn:@"token"];
    }
    
    //NSLog(@"%@", self.token);
    
    return YES;
}


@end
