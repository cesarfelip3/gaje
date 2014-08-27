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
        instance.returnCode = 0;
        
    });
    return instance;
}

// when we get FB id, we will login to server and create user for it
// then we will use this user uuid to upload image

- (BOOL)login:(NSDictionary *)data {
    
    self.returnCode = 1;
    self.errorMessage = @"";
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *api = [NSString stringWithFormat:API_USER_LOGIN, API_BASE_URL, API_BASE_VERSION];
    NSDictionary *parameters = data;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
            
            if ([uuid isEqual:[NSNull null]]) {
                self.returnCode = 1;
                self.errorMessage = @"server return invalid uuid";
                [self.delegate onCallback:0];
                return;
            }
            
            AppConfig *config = [AppConfig getInstance];
            config.uuid = uuid;
          
            self.userUUID = uuid;
            [self updateUUID];
            
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
        
        NSLog(@"Error: %@", operation.response);
        NSLog(@"Error: %@", operation.responseObject);
        
        NSString *message = [operation.responseObject objectForKey:@"message"];
        
        self.returnCode = 1;
        
        if (message != nil && ![message isEqual:[NSNull null]]) {
            
            self.errorMessage = message;
            //return;
        }
            
        self.errorMessage = [NSString stringWithFormat:@"We got unknow error from server, and networking functionality in app will be not available, you can go 'setting' page and try to re-connect to the server, if there are any question, please send us email %@", CONTACT_EMAIL];
        
        
        [self.delegate onCallback:0];
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
    self.description = [self escape:self.description];
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
    
    self.userUUID = [self escape:self.userUUID];
    
    
    [self.db executeUpdateWithFormat:@"DELETE FROM user WHERE token=%@", self.token];
    
    [self.db executeUpdateWithFormat:@"INSERT INTO user (user_uuid, username, description, fullname, email, token) VALUES (%@, %@, %@, %@, %@, %@);", self.userUUID, self.username, self.description, self.fullname, self.email, self.token];
    
    
    return YES;
}

- (BOOL)update
{
    if (![self.db open]) {
        return NO;
    }
    
    self.username = [self escape:self.username];
    self.description = [self escape:self.description];
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
    
    [self.db executeUpdateWithFormat:@"UPDATE user SET username=%@, description=%@, fullname=%@, email=%@, city=%@, state=%@, country=%@, address=%@, zipcode＝%@, phone=%@, picture=%@, token=%@ WHERE user_id=%ld", self.username, self.description, self.fullname, self.email, self.city, self.state, self.country, self.address, self.postcode, self.phone, self.icon, self.token, (long)(self.userId)];
    
    return YES;
}

- (BOOL)updateUUID
{
    if (![self.db open]) {
        return NO;
    }
    
    [self.db executeUpdateWithFormat:@"UPDATE user SET user_uuid=%@ WHERE token=%@", self.userUUID, self.token];
    
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
        self.description = [result stringForColumn:@"description"];
        
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
        self.description = [result stringForColumn:@"description"];
        
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

//============================
//
//============================

- (BOOL)fetchImageList:(NSMutableArray *)imageArray Parameters:(NSDictionary *)values Token:(NSString *)token
{
    
    NSMutableArray *tempImageArray = [[NSMutableArray alloc] init];
    
    _returnCode = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = values;
    NSString *url = [NSString stringWithFormat:API_USER_IMAGE_LIST, API_BASE_URL, API_BASE_VERSION];
    
    NSLog(@"url = %@", url);
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *$imageArray = [data objectForKey:@"images"];
                
                for (NSDictionary *item in $imageArray) {
                    
                    Image *image = [[Image alloc] init];
                    
                    image.imageUUID = [item objectForKey:@"image_uuid"];
                    image.name = [item objectForKey:@"name"];
                    image.description = [item objectForKey:@"description"];
                    
                    image.width = [[item objectForKey:@"width"] integerValue];
                    image.height = [[item objectForKey:@"height"] integerValue];
                    
                    NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    formatter.timeZone = [NSTimeZone defaultTimeZone];
                    formatter.dateStyle = NSDateFormatterLongStyle;
                    
                    image.created = [formatter stringFromDate:date];
                    
                    timestamp = [[item objectForKey:@"modified_date"] integerValue];
                    date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    image.modified = [formatter stringFromDate:date];
                    image.fileName = [item objectForKey:@"file_name"];
                    image.url = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.fileName];
                    
                    image.thumbnailName = [item objectForKey:@"thumbnail"];
                    image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.thumbnailName];
                    
                    image.userUUID = [item objectForKey:@"user_uuid"];
                    image.username = [item objectForKey:@"username"];
                    image.usertoken = [item objectForKey:@"user_token"];
                    
                    image.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
                    
                    image.branderCount = [[item objectForKey:@"brander_count"] integerValue];
                    
                    NSArray *resultArray = [item objectForKey:@"branders"];
                    
                    if ([resultArray count] <= 0) {
                        
                    } else {
                        
                        image.branderArray = [[NSMutableArray alloc] init];
                        
                        
                        for (NSDictionary *item2 in resultArray) {
                            
                            Brander *brander = [[Brander alloc] init];
                            
                            brander.userUUID = [item2 objectForKey:@"user_uuid"];
                            brander.username = [item2 objectForKey:@"username"];
                            brander.fullname = [item2 objectForKey:@"fullname"];
                            brander.iconurl = [item2 objectForKey:@"facebook_icon"];
                            brander.token = [item2 objectForKey:@"facebook_token"];
                            
                            
                            [image.branderArray addObject:brander];
                            
                        }
                        
                    }
                    
                    //NSLog(@"icon = %@", image.usericon);
                    [tempImageArray addObject:image];
                }
                
                [imageArray removeAllObjects];
                for (Image *image in tempImageArray) {
                    [imageArray addObject:image];
                }
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
        self.returnCode = 1;
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        NSLog(@"%@", [operation responseObject]);
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:0];
        
    }];
    
    
    return YES;
}

//===========================
//
//===========================

- (BOOL)addFollow:(NSDictionary *)values Token:(NSString*)token
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;
    
    [manager POST:[NSString stringWithFormat:API_USER_FOLLOW, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        self.returnCode = 0;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [(self.delegate) onCallback:0];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        self.returnCode = 1;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    return YES;
    
}

- (BOOL)removeFollow:(NSDictionary *)values Token:(NSString*)token
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;
    
    [manager POST:[NSString stringWithFormat:API_USER_UNFOLLOW, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        self.returnCode = 0;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [(self.delegate) onCallback:0];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        self.returnCode = 1;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    return YES;
    
}

- (BOOL)fetchFollowerList:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Token:(NSString *)token
{
    
    _returnCode = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = values;
    
    [manager POST:[NSString stringWithFormat:API_USER_FOLLOWER_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *resultArray = [data objectForKey:@"followers"];
                
                //if ([resultArray count] > 0) {
                    [followerArray removeAllObjects];
                //}
                
                for (NSDictionary *item in resultArray) {
                    
                    User *follower = [[User alloc] init];
                    
                    follower.userUUID = [item objectForKey:@"user_uuid"];
                    follower.username = [item objectForKey:@"username"];
                    follower.fullname = [item objectForKey:@"fullname"];
                    
                    follower.token = [item objectForKey:@"facebook_token"];
                    follower.icon = follower.token;
                    follower.iconurl = [item objectForKey:@"facebook_icon"];
                    follower.isMutual = [[item objectForKey:@"is_mutual"] integerValue];
                    
                    NSDictionary *image = [item objectForKey:@"image"];
                    
                    if ([image count] > 0) {
                        
                        if (!follower.imageArray) {
                            
                            follower.imageArray = [[NSMutableArray alloc] init];
                            
                        }
                        
                        Image *_image = [[Image alloc] init];
                        
                        _image.name = [image objectForKey:@"name"];
                        _image.description = [image objectForKey:@"description"];
                        _image.fileName = [image objectForKey:@"file_name"];
                        _image.thumbnailName = [image objectForKey:@"thumbnail"];
                        _image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, _image.thumbnailName];
                        
                        _image.width = [[image objectForKey:@"width"] integerValue];
                        _image.height = [[image objectForKey:@"height"] integerValue];
                        
                        [follower.imageArray addObject:_image];
                        
                    }
                    
                    [followerArray addObject:follower];
                }
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
        self.returnCode = 1;
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        NSLog(@"%@", [operation responseObject]);
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:0];
        
    }];
    
    
    return YES;
}

- (BOOL)fetchFollowingList:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Token:(NSString *)token
{
    
    _returnCode = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = values;
    
    [manager POST:[NSString stringWithFormat:API_USER_FOLLOWIN_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *resultArray = [data objectForKey:@"followings"];
                
                //if ([resultArray count] > 0) {
                    [followerArray removeAllObjects];
                //}
                
                for (NSDictionary *item in resultArray) {
                    
                    User *follower = [[User alloc] init];
                    
                    follower.userUUID = [item objectForKey:@"user_uuid"];
                    follower.username = [item objectForKey:@"username"];
                    follower.fullname = [item objectForKey:@"fullname"];
                    
                    follower.token = [item objectForKey:@"facebook_token"];
                    follower.icon = follower.token;
                    follower.iconurl = [item objectForKey:@"facebook_icon"];
                    follower.isMutual = [[item objectForKey:@"is_mutual"] integerValue];
                    
                    NSDictionary *image = [item objectForKey:@"image"];
                    
                    if ([image count] > 0) {
                        
                        if (!follower.imageArray) {
                            
                            follower.imageArray = [[NSMutableArray alloc] init];
                            
                        }
                        
                        Image *_image = [[Image alloc] init];
                        
                        _image.name = [image objectForKey:@"name"];
                        _image.description = [image objectForKey:@"description"];
                        _image.fileName = [image objectForKey:@"file_name"];
                        _image.thumbnailName = [image objectForKey:@"thumbnail"];
                        _image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, _image.thumbnailName];
                        
                        _image.width = [[image objectForKey:@"width"] integerValue];
                        _image.height = [[image objectForKey:@"height"] integerValue];
                        
                        [follower.imageArray addObject:_image];
                        
                    }
                    
                    [followerArray addObject:follower];
                }
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
        self.returnCode = 1;
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        NSLog(@"%@", [operation responseObject]);
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:0];
        
    }];
    
    
    return YES;
}

// block

- (BOOL)addBlock:(NSDictionary *)values Token:(NSString*)token
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;
    
    [manager POST:[NSString stringWithFormat:API_USER_BLOCK_ADD, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        self.returnCode = 0;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [(self.delegate) onCallback:0];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSLog(@"error : %@", [operation responseObject]);
        self.returnCode = 1;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    return YES;
    
}

- (BOOL)search:(NSDictionary *)values ResultArray:(NSMutableArray *)userArray Token:(NSString *)token
{
    _returnCode = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSDictionary *parameters = values;
    
    [manager POST:[NSString stringWithFormat:API_USER_SEARCH, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *resultArray = [data objectForKey:@"users"];
                
                //if ([resultArray count] > 0) {
                [userArray removeAllObjects];
                //}
                
                for (NSDictionary *item in resultArray) {
                    
                    User *user = [[User alloc] init];
                    
                    user.userUUID = [item objectForKey:@"user_uuid"];
                    user.username = [item objectForKey:@"username"];
                    user.fullname = [item objectForKey:@"fullname"];
                    
                    user.token = [item objectForKey:@"facebook_token"];
                    user.icon = user.token;
                    user.iconurl = [item objectForKey:@"facebook_icon"];
                    user.isMutual = [[item objectForKey:@"is_mutual"] integerValue];
                    
                    [userArray addObject:user];
                }
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
        self.returnCode = 1;
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        NSLog(@"%@", [operation responseObject]);
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:0];
        
    }];
    
    
    return YES;
}

// notification

- (BOOL)prepareNotification
{
    
    if (!self.userUUID) {
        
        return NO;
    }
    
    NSDictionary *data = @{@"user_uuid":self.userUUID};
    
    NSString *api = [NSString stringWithFormat:API_USER_PRE_NOTIFY, API_BASE_URL, API_BASE_VERSION];
    NSDictionary *parameters = data;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"Error: %@", operation.response);
        NSLog(@"Error: %@", operation.responseObject);
    }];
    
    return YES;
}

- (BOOL)getLatestUpdate:(NSDictionary *)updateDictionary
{
    if (!self.userUUID) {
        
        return NO;
    }
    
    NSDictionary *data = @{@"user_uuid":self.userUUID};
    
    NSString *api = [NSString stringWithFormat:API_USER_GET_NOTIFY, API_BASE_URL, API_BASE_VERSION];
    NSDictionary *parameters = data;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"JSON: %@", responseObject);
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                
                NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
                NSMutableArray *branderArray = [[NSMutableArray alloc] init];
                
                NSArray *$imageArray = [data objectForKey:@"comments"];
                
                for (NSDictionary *item in $imageArray) {
                    
                    Image *image = [[Image alloc] init];
                    
                    image.imageUUID = [item objectForKey:@"image_uuid"];
                    image.name = [item objectForKey:@"name"];
                    image.description = [item objectForKey:@"description"];
                    
                    image.width = [[item objectForKey:@"width"] integerValue];
                    image.height = [[item objectForKey:@"height"] integerValue];
                    
                    NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    formatter.timeZone = [NSTimeZone defaultTimeZone];
                    formatter.dateStyle = NSDateFormatterLongStyle;
                    
                    image.created = [formatter stringFromDate:date];
                    
                    timestamp = [[item objectForKey:@"modified_date"] integerValue];
                    date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    image.modified = [formatter stringFromDate:date];
                    image.fileName = [item objectForKey:@"file_name"];
                    image.url = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.fileName];
                    
                    
                    image.thumbnailName = [item objectForKey:@"thumbnail"];
                    image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.thumbnailName];
                    
                    image.userUUID = [item objectForKey:@"user_uuid"];
                    image.username = [item objectForKey:@"username"];
                    image.usertoken = [item objectForKey:@"user_token"];
                    
                    image.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
                    
                    image.branderCount = [[item objectForKey:@"brander_count"] integerValue];
                    image.enableBrandIt = [[item objectForKey:@"enable_brander"] integerValue];
                    
                    NSArray *resultArray = [item objectForKey:@"branders"];
                    
                    if ([resultArray count] <= 0) {
                        
                    } else {
                        
                        image.branderArray = [[NSMutableArray alloc] init];
                        
                        
                        for (NSDictionary *item2 in resultArray) {
                            
                            Brander *brander = [[Brander alloc] init];
                            
                            brander.userUUID = [item2 objectForKey:@"user_uuid"];
                            brander.username = [item2 objectForKey:@"username"];
                            brander.fullname = [item2 objectForKey:@"fullname"];
                            brander.iconurl = [item2 objectForKey:@"facebook_icon"];
                            brander.token = [item2 objectForKey:@"facebook_token"];
                            
                            
                            [image.branderArray addObject:brander];
                            
                        }
                        
                    }
                    
                    [commentsArray addObject:image];
                    
                }
                
                
                $imageArray = [data objectForKey:@"branders"];
                
                for (NSDictionary *item in $imageArray) {
                    
                    Image *image = [[Image alloc] init];
                    
                    image.imageUUID = [item objectForKey:@"image_uuid"];
                    image.name = [item objectForKey:@"name"];
                    image.description = [item objectForKey:@"description"];
                    
                    image.width = [[item objectForKey:@"width"] integerValue];
                    image.height = [[item objectForKey:@"height"] integerValue];
                    
                    NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    formatter.timeZone = [NSTimeZone defaultTimeZone];
                    formatter.dateStyle = NSDateFormatterLongStyle;
                    
                    image.created = [formatter stringFromDate:date];
                    
                    timestamp = [[item objectForKey:@"modified_date"] integerValue];
                    date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    image.modified = [formatter stringFromDate:date];
                    image.fileName = [item objectForKey:@"file_name"];
                    image.url = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.fileName];
                    
                    
                    image.thumbnailName = [item objectForKey:@"thumbnail"];
                    image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.thumbnailName];
                    
                    image.userUUID = [item objectForKey:@"user_uuid"];
                    image.username = [item objectForKey:@"username"];
                    image.usertoken = [item objectForKey:@"user_token"];
                    
                    image.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
                    
                    image.branderCount = [[item objectForKey:@"brander_count"] integerValue];
                    image.enableBrandIt = [[item objectForKey:@"enable_brander"] integerValue];
                    
                    NSArray *resultArray = [item objectForKey:@"branders"];
                    
                    if ([resultArray count] <= 0) {
                        
                    } else {
                        
                        image.branderArray = [[NSMutableArray alloc] init];
                        
                        
                        for (NSDictionary *item2 in resultArray) {
                            
                            Brander *brander = [[Brander alloc] init];
                            
                            brander.userUUID = [item2 objectForKey:@"user_uuid"];
                            brander.username = [item2 objectForKey:@"username"];
                            brander.fullname = [item2 objectForKey:@"fullname"];
                            brander.iconurl = [item2 objectForKey:@"facebook_icon"];
                            brander.token = [item2 objectForKey:@"facebook_token"];
                            
                            
                            [image.branderArray addObject:brander];
                            
                        }
                        
                    }
                    
                    [branderArray addObject:image];
                    
                }
                
                NSArray *resultArray = [data objectForKey:@"followers"];
                NSMutableArray *followerArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *item in resultArray) {
                    
                    User *follower = [[User alloc] init];
                    
                    follower.userUUID = [item objectForKey:@"user_uuid"];
                    follower.username = [item objectForKey:@"username"];
                    follower.fullname = [item objectForKey:@"fullname"];
                    
                    follower.token = [item objectForKey:@"facebook_token"];
                    follower.icon = follower.token;
                    follower.iconurl = [item objectForKey:@"facebook_icon"];
                    follower.isMutual = [[item objectForKey:@"is_mutual"] integerValue];
                    
                    NSDictionary *image = [item objectForKey:@"image"];
                    
                    if ([image count] > 0) {
                        
                        if (!follower.imageArray) {
                            
                            follower.imageArray = [[NSMutableArray alloc] init];
                            
                        }
                        
                        Image *_image = [[Image alloc] init];
                        
                        _image.name = [image objectForKey:@"name"];
                        _image.description = [image objectForKey:@"description"];
                        _image.fileName = [image objectForKey:@"file_name"];
                        _image.thumbnailName = [image objectForKey:@"thumbnail"];
                        _image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, _image.thumbnailName];
                        
                        _image.width = [[image objectForKey:@"width"] integerValue];
                        _image.height = [[image objectForKey:@"height"] integerValue];
                        
                        [follower.imageArray addObject:_image];
                        
                    }
                    
                    [followerArray addObject:follower];
                }
                
                [updateDictionary setValue:commentsArray forKey:@"comments"];
                [updateDictionary setValue:branderArray forKey:@"branders"];
                [updateDictionary setValue:followerArray forKey:@"followers"];

                //NSLog(@"update = %d", [commentsArray count]);
                
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                self.returnCode = 0;
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
        self.returnCode = 1;
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:0];
        
        return;

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"Error: %@", operation.response);
        NSLog(@"Error: %@", operation.responseObject);
    }];
    
    return YES;
}

//

- (BOOL)getNumberOfLatestUpdate
{
    if (!self.userUUID) {
        
        return NO;
    }
    
    NSDictionary *data = @{@"user_uuid":self.userUUID};
    
    NSString *api = [NSString stringWithFormat:API_USER_NUMBER_NOTIFY, API_BASE_URL, API_BASE_VERSION];
    NSDictionary *parameters = data;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"JSON: %@", responseObject);
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            NSInteger total = [[[responseObject objectForKey:@"data"] objectForKey:@"total"] integerValue];
            
            AppConfig *config = [AppConfig getInstance];
            config.numberOfNotifications = total;
            
            NSDictionary *item = ((MenuViewController *)(self.menuVC)).menu[1][@"rows"][3];
            
#if true
            NSString *title = [item objectForKey:@"title"];
            
            if ([title isEqualToString:@"Notification"]) {
                
                AppConfig *config = [AppConfig getInstance];
                
                title = [NSString stringWithFormat:@"Notifications(%ld)", (long)config.numberOfNotifications];
                item = @{@"image":@"", @"title":title};
                
                //((MenuViewController *)(self.menuVC)).menu[1][@"rows"][3] = item;
            }
#endif
            
        }
        
        self.returnCode = 1;
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"Error: %@", operation.response);
        NSLog(@"Error: %@", operation.responseObject);
    }];
    
    return YES;
}

@end
