//
//  Image+ImageApi.m
//  Gaje
//
//  Created by hello on 14-9-7.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Image+ImageApi.h"

@implementation Image (ImageApi)

- (BOOL)fetchLatest:(NSMutableArray *)imageArray Token:(NSString *)token
{
    
    NSMutableArray *tempImageArray = [[NSMutableArray alloc] init];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    User *user = [User getInstance];
    
    NSString *uuid = user.userUUID;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSDictionary *parameters = @{@"user_uuid":@""};
    
    if (user.userUUID) {
        
        parameters = @{@"user_uuid":uuid};
    }
    
    NSString *api = [NSString stringWithFormat:API_IMAGE_LATEST, API_BASE_URL, API_BASE_VERSION];
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            User *user = [User getInstance];
            
            @try {
                
                NSArray *$imageArray = [data objectForKey:@"images"];
                
                for (NSDictionary *item in $imageArray) {
                    
                    Image *image = [[Image alloc] init];
                    
                    image.imageUUID = [item objectForKey:@"image_uuid"];
                    image.name = [item objectForKey:@"name"];
                    image.desc = [item objectForKey:@"description"];
                    
                    image.width = [[item objectForKey:@"width"] integerValue];
                    image.height = [[item objectForKey:@"height"] integerValue];
                    
                    NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                    image.created = [self stringFromTimestamp:timestamp];
                    
                    timestamp = [[item objectForKey:@"modified_date"] integerValue];
                    image.modified = [self stringFromTimestamp:timestamp];
                    
                    image.fileName = [item objectForKey:@"file_name"];
                    image.url = [item objectForKey:@"url_file"];
                    
                    image.thumbnailName = [item objectForKey:@"thumbnail"];
                    image.thumbnail = [item objectForKey:@"url_thumbnail"];
                    
                    image.userUUID = [item objectForKey:@"user_uuid"];
                    image.username = [item objectForKey:@"username"];
                    image.usertoken = [item objectForKey:@"user_token"];
                    
                    image.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
                    
                    image.branderCount = [[item objectForKey:@"brander_count"] integerValue];
                    image.enableBrandIt = [[item objectForKey:@"enable_brander"] integerValue];
                    image.isTracking = [[item objectForKey:@"is_tracking"] integerValue];
                    
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
                            
                            if ([brander.userUUID isEqualToString:user.userUUID]) {
                                image.enableBrandIt = 0;
                            }
                            
                            [image.branderArray addObject:brander];
                            
                        }
                        
                    }
                    
                    //// NSLog(@"icon = %@", image.usericon);
                    [tempImageArray addObject:image];
                }
                
                NSDictionary *theme = [data objectForKey:@"theme"];
                
                [imageArray removeAllObjects];
                for (Image *image in tempImageArray) {
                    [imageArray addObject:image];
                }
                
                AppConfig *config = [AppConfig getInstance];
                config.theme = [theme objectForKey:@"name"];
                
                
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
        
        // NSLog(@"%@", [operation responseObject]);
        // NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:1];
        
    }];
    
    
    return YES;
}

// page, pagesize, data, created
// http://stackoverflow.com/questions/19466291/afnetworking-2-0-add-headers-to-get-request

- (BOOL)fetchAllByKeywords:(NSMutableArray *)imageArray Keywords:(NSString *)keywords Token:(NSString *)token
{
    
    return YES;
}

- (BOOL)fetchAllByUser:(NSMutableArray *)imageArray Token:(NSString *)token UserId:(NSInteger)userId
{
    
    return YES;
}

//==================

- (BOOL)fetchLatestTopBrander:(NSMutableArray *)imageArray Token:(NSString *)token
{
    
    NSMutableArray *tempImageArray = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    User *user = [User getInstance];
    
    NSString *uuid = user.userUUID;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSDictionary *parameters = @{@"user_uuid":@""};
    
    if (user.userUUID) {
        
        parameters = @{@"user_uuid":uuid};
    }
    
    NSString *api = [NSString stringWithFormat:API_IMAGE_BRANDER_TOP, API_BASE_URL, API_BASE_VERSION];
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            User *user = [User getInstance];
            
            @try {
                
                NSArray *$imageArray = [data objectForKey:@"images"];
                
                for (NSDictionary *item in $imageArray) {
                    
                    Image *image = [[Image alloc] init];
                    
                    image.imageUUID = [item objectForKey:@"image_uuid"];
                    image.name = [item objectForKey:@"name"];
                    image.desc = [item objectForKey:@"description"];
                    
                    image.width = [[item objectForKey:@"width"] integerValue];
                    image.height = [[item objectForKey:@"height"] integerValue];
                    
                    NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                    image.created = [self stringFromTimestamp:timestamp];
                    
                    timestamp = [[item objectForKey:@"modified_date"] integerValue];
                    image.modified = [self stringFromTimestamp:timestamp];
                    
                    image.fileName = [item objectForKey:@"file_name"];
                    image.url = [item objectForKey:@"url_file"];
                    
                    image.thumbnailName = [item objectForKey:@"thumbnail"];
                    image.thumbnail = [item objectForKey:@"url_thumbnail"];
                    
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
                            
                            if ([brander.userUUID isEqualToString:user.userUUID]) {
                                image.enableBrandIt = 0;
                            }
                            
                            [image.branderArray addObject:brander];
                            
                        }
                        
                    }
                    
                    //// NSLog(@"icon = %@", image.usericon);
                    [tempImageArray addObject:image];
                }
                
                [imageArray removeAllObjects];
                for (Image *image in tempImageArray) {
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
        
        // NSLog(@"%@", [operation responseObject]);
        // NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:1];
        
    }];
    
    
    return YES;
}


//=================================
// comment
//=================================

- (BOOL)addComment:(NSDictionary *)values Token:(NSString*)token
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;
    
    NSString *api = [NSString stringWithFormat:API_IMAGE_COMMENT_ADD, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [(self.delegate) onCallback:0];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // NSLog(@"Error: %@", error);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    return YES;
    
}

- (BOOL)fetchCommentList:(NSMutableArray *)commentArray Token:(NSString *)token
{
    [commentArray removeAllObjects];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = @{@"image_uuid":self.imageUUID};
    
#if false
    [manager POST:[NSString stringWithFormat:API_IMAGE_COMMENT_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif
        
        NSString *api = [NSString stringWithFormat:API_IMAGE_COMMENT_LIST, API_BASE_URL, API_BASE_VERSION];
        [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            // NSLog(@"%@", responseObject);
            
            if ([status isEqualToString:@"success"]) {
                
                NSDictionary *data = [responseObject objectForKey:@"data"];
                
                @try {
                    
                    NSArray *resultArray = [data objectForKey:@"comments"];
                    
                    if ([resultArray count] <= 0) {
                        
                    } else {
                        
                        for (NSDictionary *item in resultArray) {
                            
                            
                            Comment *comment = [[Comment alloc] init];
                            
                            comment.content = [item objectForKey:@"content"];
                            comment.userUUID = [item objectForKey:@"user_uuid"];
                            comment.username = [item objectForKey:@"username"];
                            comment.usericon = [item objectForKey:@"usericon"];
                            
                            NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                            
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            
                            formatter.timeZone = [NSTimeZone defaultTimeZone];
                            formatter.dateStyle = NSDateFormatterLongStyle;
                            
                            comment.create = [formatter stringFromDate:date];
                            
                            [commentArray addObject:comment];
                            
                        }
                        
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
            self.delegate == nil || [(self.delegate) onCallback:1];
            
            return;
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            // NSLog(@"%@", error);
            
            self.errorMessage = @"Network failed";
            
            [self.delegate onCallback:1];
            
        }];
        
        
        return YES;
    }
     
     //==================================
     // brander
     //-=================================
     
     - (BOOL)addBrander:(NSDictionary *)values Token:(NSString*)token
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        token = [self getToken];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
        
        NSDictionary *parameters = values;
        
#if false
        [manager POST:[NSString stringWithFormat:API_IMAGE_BRANDER_ADD, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif
            
            NSString *api = [NSString stringWithFormat:API_IMAGE_BRANDER_ADD, API_BASE_URL, API_BASE_VERSION];
            [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                // NSLog(@"Success: %@", responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status isEqualToString:@"success"]) {
                    
                    //self.uploadedImageId = [responseObject objectForKey:@"id"];
                    
                }
                
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self changeUploadStatus:@"1"];
                
                [(self.delegate) onCallback:0];
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                //// NSLog(@"Error: %@", error);
                // NSLog(@"%@", [operation responseObject]);
                
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                self.errorMessage = @"Network failed";
                
                [(self.delegate) onCallback:0];
                
            }];
            
            return YES;
            
        }
         
         - (BOOL)fetchBranderList:(NSMutableArray *)branderArray Token:(NSString *)token
        {
            [branderArray removeAllObjects];
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            token = [self getToken];
            
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
            
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            NSDictionary *parameters = @{@"image_uuid":self.imageUUID};
            
#if false
            [manager POST:[NSString stringWithFormat:API_IMAGE_BRANDER_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#endif
                
                NSString *api = [NSString stringWithFormat:API_IMAGE_BRANDER_LIST, API_BASE_URL, API_BASE_VERSION];
                [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                    // NSLog(@"%@", responseObject);
                    
                    if ([status isEqualToString:@"success"]) {
                        
                        NSDictionary *data = [responseObject objectForKey:@"data"];
                        
                        @try {
                            
                            NSArray *resultArray = [data objectForKey:@"branders"];
                            
                            if ([resultArray count] <= 0) {
                                
                            } else {
                                
                                for (NSDictionary *item in resultArray) {
                                    
                                    Brander *brander = [[Brander alloc] init];
                                    
                                    brander.userUUID = [item objectForKey:@"user_uuid"];
                                    brander.username = [item objectForKey:@"username"];
                                    brander.fullname = [item objectForKey:@"fullname"];
                                    brander.iconurl = [item objectForKey:@"facebook_icon"];
                                    brander.token = [item objectForKey:@"facebook_token"];
                                    
                                    [branderArray addObject:brander];
                                    
                                }
                                
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
                    self.delegate == nil || [(self.delegate) onCallback:1];
                    
                    return;
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                    // NSLog(@"%@", error);
                    
                    self.errorMessage = @"Network failed";
                    
                    [self.delegate onCallback:1];
                    
                }];
                
                
                return YES;
            }
             
             
             //===================
             //
             //===================
             
             - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
            {
                if ([keyPath isEqualToString:@"fractionCompleted"]) {
                    
                    NSProgress *progress = (NSProgress *)object;
                    ////// NSLog(@"Progress… %f", progress.fractionCompleted);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.progress.progress = progress.fractionCompleted;//(float)(progress.completedUnitCount / progress.totalUnitCount);
                    });
                    
                    
                } else {
                    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
                }
            }
             
             - (BOOL)upload:(NSDictionary *)values ProgressBar:(UIProgressView *)progressBar
            {
                // @{@"file_path":filePath, @"file_name":self.photo.fileName, @"name":self.photo.name, @"description":self.photo.desc, @"user_uuid":config.uuid, @"theme_array":themes};
                
#if false
                
                NSString *filePath = [values objectForKey:@"file_path"];
                NSString *fileName = [values objectForKey:@"file_name"];
                NSString *name = [values objectForKey:@"name"];
                NSString *desc = [values objectForKey:@"description"];
                NSString *user_uuid = [values objectForKey:@"user_uuid"];
                NSString *theme_array = [values objectForKey:@"theme_array"];
                
                self.progress = progressBar;
                
                if (self.progress.tag == 1) {
                    return YES;
                }
                
                self.progress.progress = 0;
                self.progress.tag = 1;
                
                
                // form file name and parameter name would be determined by the web API
                NSDictionary *parameters =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [FSNData withDataPath:filePath fileName:fileName],     @"fileinfo",
                 user_uuid, @"user_uuid",
                 name, @"name",
                 desc, @"description",
                 theme_array, @"theme_array",
                 nil];
                
                NSString *api = [NSString stringWithFormat:API_IMAGE_UPLOAD, API_BASE_URL, API_BASE_VERSION];
                NSURL *url = [NSURL URLWithString:api];
                
                FSNConnection *connection =
                [FSNConnection withUrl:url
                                method:FSNRequestMethodPOST
                               headers:nil
                            parameters:parameters
                            parseBlock:^id(FSNConnection *c, NSError **error) {
                                
                                // NSLog(@"%@", [c.responseData dictionaryFromJSONWithError:error]);
                                return [c.responseData dictionaryFromJSONWithError:error];
                            }
                       completionBlock:^(FSNConnection *c) {
                           
                           // NSLog(@"%@", c.parseResult);
                           
                           NSDictionary *result = (NSDictionary *)(c.parseResult);
                           NSString *status = [result objectForKey:@"status"];
                           
                           if ([status isEqualToString:@"success"]) {
                               
                               [self.delegate onCallback:0];
                               
                           } else {
                               
                               [self.delegate onCallback:1];
                           }
                           
                       }
                         progressBlock:^(FSNConnection *c) {
                             
                             self.progress.progress = c.uploadProgress;
                             
                         }];
                
                [connection start];
                
#else
                self.progress = progressBar;
                
                if (self.progress.tag == 1) {
                    return YES;
                }
                
                self.progress.progress = 0;
                self.progress.tag = 1;
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                
                NSDictionary *parameters = values;
                NSString *filePath = [values objectForKey:@"file_path"];
                NSString *fileName = [values objectForKey:@"file_name"];
                
                NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:API_IMAGE_UPLOAD, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"fileinfo" fileName:fileName mimeType:@"image/jpg" error:nil];
                    
                } error:nil];
                
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                
                NSProgress *progress = nil;
                
                NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    self.progress.tag = 0;
                    
                    if (error) {
                        
                        // NSLog(@"%@", response);
                        // NSLog(@"%@", responseObject);
                        
                        
                        self.errorMessage = [responseObject objectForKey:@"message"];
                        self.errorMessage = [self escape:self.errorMessage];
                        
                        [self.delegate onCallback:1];
                        
                    } else {
                        
                        // NSLog(@"Success: %@", responseObject);
                        
                        NSDictionary *data = [responseObject objectForKey:@"data"];
                        
                        if (data == nil || [data isEqual:[NSNull null]]) {
                            
                        } else {
                            self.imageUUID = [data objectForKey:@"image_uuid"];
                        }
                        
                        [self.delegate onCallback:0];
                    }
                    
                    
                    
                }];
                
                [uploadTask resume];
                
                [progress addObserver:self
                           forKeyPath:@"fractionCompleted"
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
                
#endif
                
                return YES;
            }
             
             
             
             
             - (BOOL)changeUploadStatus:(NSString *)status
            {
                
                if (![self.db open]) {
                    return NO;
                }
                
                [self.db executeUpdate:@"DELETE FROM setting WHERE name='image_upload_update'"];
                [self.db executeUpdate:@"INSERT INTO setting (name, value) VALUES ('image_upload_update', '1')"];
                
                
                AppConfig *config = [AppConfig getInstance];
                
                config.userIsLogin = 1;
                config.imageIsUploaded = 1;
                
                return YES;
                
            }
             
             
             @end
