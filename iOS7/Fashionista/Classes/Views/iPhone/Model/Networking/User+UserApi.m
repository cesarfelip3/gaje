//
//  User+UserApi.m
//  Gaje
//
//  Created by hello on 14-8-28.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "User+UserApi.h"
#import "Image.h"
#import "Brander.h"

@implementation User (UserApi)


- (BOOL)fetchImageList:(NSMutableArray *)imageArray Parameters:(NSDictionary *)values Token:(NSString *)token
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;
    
#if false
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif
        
    NSString *api = [NSString stringWithFormat:API_USER_IMAGE_LIST, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"User.fetchImageList : %@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSMutableArray *_result = [[NSMutableArray alloc] init];
            
            @try {
                
                NSArray *$imageArray = [data objectForKey:@"images"];
                
                for (NSDictionary *item in $imageArray) {
                    
                    Image *image = [[Image alloc] init];
                    
                    image.imageUUID = [item objectForKey:@"image_uuid"];
                    image.name = [item objectForKey:@"name"];
                    image.desc = [item objectForKey:@"description"];
                    
                    image.width = [[item objectForKey:@"width"] integerValue];
                    image.height = [[item objectForKey:@"height"] integerValue];
                    
                    image.fileName = [item objectForKey:@"file_name"];
                    image.url = [item objectForKey:@"url_file"];
                    
                    image.thumbnailName = [item objectForKey:@"thumbnail"];
                    image.thumbnail = [item objectForKey:@"url_thumbnail"];
                    
                    image.userUUID = [item objectForKey:@"user_uuid"];
                    image.username = [item objectForKey:@"username"];
                    image.usertoken = [item objectForKey:@"user_token"];
                    image.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
                    image.branderCount = [[item objectForKey:@"brander_count"] integerValue];
                    
                    // time & date
                                        
                    NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                    image.created = [self stringFromTimestamp:timestamp];
                    
                    timestamp = [[item objectForKey:@"modified_date"] integerValue];
                    image.modified = [self stringFromTimestamp:timestamp];
                    
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
                    [_result addObject:image];
                }
                
                [imageArray removeAllObjects];
                
                for (Image *image in _result) {
                    [imageArray addObject:image];
                }
                
                
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
          
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:1];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"%@", [operation responseObject]);
        NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:1];
        
    }];
    
    
    return YES;
}

// block

- (BOOL)removeImage:(NSDictionary *)values Token:(NSString*)token
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;
    
#if false
    [manager POST:[NSString stringWithFormat:API_USER_REMOVE_IMAGE, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#endif
   
    NSString *api = [NSString stringWithFormat:API_USER_REMOVE_IMAGE, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        NSInteger type = 0;
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        } else {
            
            self.errorMessage = [responseObject objectForKey:@"message"];
            type = 1;
        }
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [(self.delegate) onCallback:type];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSLog(@"error : %@", [operation responseObject]);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:1];
        
    }];
    
    return YES;
    
}

// exclude image

- (BOOL)excludeImage:(NSDictionary *)values Token:(NSString*)token
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;

#if false
    [manager POST:[NSString stringWithFormat:API_USER_EXCLUDE_IMAGE, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif
        
    NSString *api = [NSString stringWithFormat:API_USER_EXCLUDE_IMAGE, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        NSInteger type = 0;
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        } else {
            
            self.errorMessage = [responseObject objectForKey:@"message"];
            type = 1;
        }
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [(self.delegate) onCallback:type];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSLog(@"error : %@", [operation responseObject]);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:1];
        
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

#if false
    [manager POST:[NSString stringWithFormat:API_USER_FOLLOW, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif

    NSString *api = [NSString stringWithFormat:API_USER_FOLLOW, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [(self.delegate) onCallback:0];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
          
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:1];
        
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

#if false
    [manager POST:[NSString stringWithFormat:API_USER_UNFOLLOW, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif
    
    NSString *api = [NSString stringWithFormat:API_USER_UNFOLLOW, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [(self.delegate) onCallback:0];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
          
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:1];
        
    }];
    
    return YES;
    
}

- (BOOL)fetchFollowerList:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Token:(NSString *)token
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = values;

#if false
    [manager POST:[NSString stringWithFormat:API_USER_FOLLOWER_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif

    NSString *api = [NSString stringWithFormat:API_USER_FOLLOWER_LIST, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
                        _image.desc = [image objectForKey:@"description"];
                        _image.fileName = [image objectForKey:@"file_name"];
                        _image.thumbnailName = [image objectForKey:@"thumbnail"];
                        _image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, _image.thumbnailName];
                        
                        _image.width = [[image objectForKey:@"width"] integerValue];
                        _image.height = [[image objectForKey:@"height"] integerValue];
                        
                        [follower.imageArray addObject:_image];
                        
                    }
                    
                    [followerArray addObject:follower];
                }
                
                
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
          
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          
        NSLog(@"%@", [operation responseObject]);
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        [self.delegate onCallback:1];
        
    }];
    
    
    return YES;
}

- (BOOL)fetchFollowingList:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Token:(NSString *)token
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = values;

#if false
    [manager POST:[NSString stringWithFormat:API_USER_FOLLOWIN_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif
        
    NSString *api = [NSString stringWithFormat:API_USER_FOLLOWIN_LIST, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
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
                        _image.desc = [image objectForKey:@"description"];
                        _image.fileName = [image objectForKey:@"file_name"];
                        _image.thumbnailName = [image objectForKey:@"thumbnail"];
                        _image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, _image.thumbnailName];
                        
                        _image.width = [[image objectForKey:@"width"] integerValue];
                        _image.height = [[image objectForKey:@"height"] integerValue];
                        
                        [follower.imageArray addObject:_image];
                        
                    }
                    
                    [followerArray addObject:follower];
                }
                
                
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
          
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"%@", [operation responseObject]);
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:1];
        
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

#if false
    [manager POST:[NSString stringWithFormat:API_USER_BLOCK_ADD, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif
        
    NSString *api = [NSString stringWithFormat:API_USER_BLOCK_ADD, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [(self.delegate) onCallback:0];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSLog(@"error : %@", [operation responseObject]);
          
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:1];
        
    }];
    
    return YES;
    
}

- (BOOL)search:(NSDictionary *)values ResultArray:(NSMutableArray *)userArray Token:(NSString *)token
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSDictionary *parameters = values;

#if false
    [manager POST:[NSString stringWithFormat:API_USER_SEARCH, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif

    NSString *api = [NSString stringWithFormat:API_USER_SEARCH, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
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
                
                
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
          
        self.errorMessage = [responseObject objectForKey:@"message"];
        [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"%@", [operation responseObject]);
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        [self.delegate onCallback:1];
        
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
                    image.desc = [item objectForKey:@"description"];
                    
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
                    
                    image.commentUUID = [item objectForKey:@"comment_uuid"];
                    image.status = [[item objectForKey:@"is_read"] integerValue];
                    
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
                    image.desc = [item objectForKey:@"description"];
                    
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
                    
                    image.branderUUID = [item objectForKey:@"brander_user_uuid"];
                    image.status = [[item objectForKey:@"is_read"] integerValue];
                    
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
                        _image.desc = [image objectForKey:@"description"];
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
                
                
                
                self.errorMessage = @"";
                
            }
            
            @catch (NSException *e) {
                
                
                self.errorMessage = @"";
                
            }
            
            [self.delegate onCallback:0];
            return;
            
        }
        
          
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

#if true
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
        return;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"Error: %@", operation.response);
        NSLog(@"Error: %@", operation.responseObject);
    }];
    
    return YES;
}

#endif

#if true

- (BOOL)markItRead:(NSDictionary *)values
{
    if (!self.userUUID) {
        
        return NO;
    }
    
    NSDictionary *data = values;
    
    NSString *api = [NSString stringWithFormat:API_USER_UPDATE_NOTIFY, API_BASE_URL, API_BASE_VERSION];
    NSDictionary *parameters = data;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        return;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", operation.response);
        NSLog(@"Error: %@", operation.responseObject);
    }];
    
    return YES;
}

#endif

@end
