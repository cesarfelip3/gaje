//
//  Post.m
//  Pixcell8
//
//  Created by  on 13-10-27.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "Image.h"
#import "User.h"
#import "DiskCache.h"
#import "Comment.h"
#import "Brander.h"

@implementation Image


- (BOOL)fetchLatest:(NSMutableArray *)imageArray Token:(NSString *)token
{
    
    NSMutableArray *tempImageArray = [[NSMutableArray alloc] init];
    
    _returnCode = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSDictionary *parameters = @{@"user_uuid":@""};
    
    [manager POST:[NSString stringWithFormat:API_IMAGE_LATEST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
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
        NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:0];
        
    }];
    
    
    return YES;
}

// page, pagesize, data, created
// http://stackoverflow.com/questions/19466291/afnetworking-2-0-add-headers-to-get-request

- (BOOL)fetchAllByKeywords:(NSMutableArray *)imageArray Keywords:(NSString *)keywords Token:(NSString *)token
{
    _returnCode = 1;
    
    
    
    
    return YES;
}

- (BOOL)fetchAllByUser:(NSMutableArray *)imageArray Token:(NSString *)token UserId:(NSInteger)userId
{
    self.returnCode = 1;
    
    
    
    return YES;
}

//==================




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
    
    [manager POST:[NSString stringWithFormat:API_IMAGE_COMMENT_ADD, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
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

- (BOOL)fetchCommentList:(NSMutableArray *)commentArray Token:(NSString *)token
{
    [commentArray removeAllObjects];
    
    _returnCode = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
   
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = @{@"image_uuid":self.imageUUID};
    
    [manager POST:[NSString stringWithFormat:API_IMAGE_COMMENT_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"%@", responseObject);
        
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
        self.delegate == nil || [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:0];
        
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
    
    [manager POST:[NSString stringWithFormat:API_IMAGE_BRANDER_ADD, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        self.returnCode = 0;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self changeUploadStatus:@"1"];
        
        [(self.delegate) onCallback:0];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //NSLog(@"Error: %@", error);
        NSLog(@"%@", [operation responseObject]);
        
        self.returnCode = 1;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    return YES;
    
}

- (BOOL)fetchBranderList:(NSMutableArray *)branderArray Token:(NSString *)token
{
    [branderArray removeAllObjects];
    
    _returnCode = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = @{@"image_uuid":self.imageUUID};
    
    [manager POST:[NSString stringWithFormat:API_IMAGE_BRANDER_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"%@", responseObject);
        
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
        self.delegate == nil || [(self.delegate) onCallback:0];
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [self.delegate onCallback:0];
        
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
        ////NSLog(@"Progress… %f", progress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progress.progress = progress.fractionCompleted;//(float)(progress.completedUnitCount / progress.totalUnitCount);
        });
        
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (BOOL)upload:(NSDictionary *)values ProgressBar:(UIProgressView *)progressBar
{
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
        
            NSLog(@"%@", response);
            NSLog(@"%@", responseObject);
            
            self.returnCode = 1;
            self.errorMessage = [responseObject objectForKey:@"message"];
            self.errorMessage = [self escape:self.errorMessage];
        
        } else {
            
            NSLog(@"Success: %@", responseObject);
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            if (data == nil || [data isEqual:[NSNull null]]) {
                
            } else {
                self.imageUUID = [data objectForKey:@"image_uuid"];
            }
            
            self.returnCode = 0;
        }
        
        
        [self.delegate onCallback:0];
    }];
    
    [uploadTask resume];
    
    [progress addObserver:self
               forKeyPath:@"fractionCompleted"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
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
