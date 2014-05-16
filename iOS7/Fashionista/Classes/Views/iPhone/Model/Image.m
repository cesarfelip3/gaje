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

@implementation Image


- (BOOL)fetchLatest:(NSMutableArray *)imageArray Token:(NSString *)token
{
    _returnCode = 1;
    
    self.imageArray = [[NSMutableArray alloc] init];
    //[self.imageArray removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager GET:[NSString stringWithFormat:@"%@%d", API_IMAGE_LATEST, 120] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
        } else {
            self.returnCode = 1;
            self.errorMessage = [responseObject objectForKey:@"error"];
            
            [(self.delegate) onCallback:0];
            
            return;
        }
        
        NSMutableArray *posts = [(NSDictionary *)responseObject objectForKey:@"images"];
        
        if ([posts count] > 1) {
            
        }
        
        for (NSDictionary *post in posts) {
            Image *image = [[Image alloc] init];
            
            image.imageId = [[post objectForKey:@"id"] intValue];
            image.name = [self escape:[post objectForKey:@"name"]];
            
            image.description = [self escape:[post objectForKey:@"description"]];
            image.tags = [self escape:[post objectForKey:@"tags"]];
            
            image.created = [self escape:[post objectForKey:@"created_at"]];
            image.modified = [self escape:[post objectForKey:@"updated_at"]];
            
            image.username = [self escape:[post objectForKey:@"username"]];
            image.useremail = [self escape:[post objectForKey:@"email"]];
            
            image.fileName = [self escape:[post objectForKey:@"image"]];
            image.thumbnail = [self escape:[NSString stringWithFormat:@"iphone_thumb_%@", image.fileName]];
            
            if ([image.thumbnail isEqualToString:@""]) {
                image.imageUrl = nil;
            } else {
                image.imageUrl = [self escape:[NSString stringWithFormat:@"%@%@", URL_IMAGE_PATH, image.thumbnail]];
            }
            
            image.imageWithWatermarkUrl = @"";
            
            image.height = [((NSString *)[post objectForKey:@"height"]) integerValue];
            image.width = [((NSString *)[post objectForKey:@"width"]) integerValue];
            
            image.licenseArray = [[NSMutableArray alloc] init];
            
            [self getLicense:image.licenseArray License:[self escape:[post objectForKey:@"image_license"]]];
            
            [self.imageArray addObject:image];
            
            image = nil;
        }
        
        if ([self.imageArray count] >= 1) {
            [imageArray removeAllObjects];
            for (Image *image in self.imageArray) {
                [imageArray addObject:image];
            }
        }
        
        _returnCode = 0;
        [self.delegate onCallback:0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        //NSLog(@"%@", error);
        
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
    
    self.imageArray = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager GET:[NSString stringWithFormat:@"%@%@", API_IMAGE_SEARCH, [keywords stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            [self.imageArray removeAllObjects];
        
        } else {
            self.returnCode = 1;
            self.errorMessage = [responseObject objectForKey:@"error"];
            
            [(self.delegate) onCallback:0];
            
            return;
        }
        
        NSMutableArray *posts = [(NSDictionary *)responseObject objectForKey:@"images"];
        
        for (NSDictionary *post in posts) {
            Image *image = [[Image alloc] init];
            
            image.imageId = [[post objectForKey:@"id"] intValue];
            image.name = [self escape:[post objectForKey:@"name"]];
            
            image.description = [self escape:[post objectForKey:@"description"]];
            image.tags = [self escape:[post objectForKey:@"tags"]];
            
            image.created = [self escape:[post objectForKey:@"created_at"]];
            image.modified = [self escape:[post objectForKey:@"updated_at"]];
            
            image.username = [self escape:[post objectForKey:@"username"]];
            image.useremail = [self escape:[post objectForKey:@"email"]];
            
            image.fileName = [self escape:[post objectForKey:@"image"]];
            image.thumbnail = [self escape:[NSString stringWithFormat:@"iphone_thumb_%@", image.fileName]];
            
            if ([image.thumbnail isEqualToString:@""]) {
                image.imageUrl = nil;
            } else {
                image.imageUrl = [self escape:[NSString stringWithFormat:@"%@%@", URL_IMAGE_PATH, image.thumbnail]];
            }
            
            image.imageWithWatermarkUrl = @"";
            
            image.height = [((NSString *)[post objectForKey:@"height"]) integerValue];
            image.width = [((NSString *)[post objectForKey:@"width"]) integerValue];
            
            image.licenseArray = [[NSMutableArray alloc] init];
            [self getLicense:image.licenseArray License:[self escape:[post objectForKey:@"image_license"]]];
            
            [self.imageArray addObject:image];
            
            image = nil;
        }
        
        if ([self.imageArray count] >= 1) {
            [imageArray removeAllObjects];
            for (Image *image in self.imageArray) {
                [imageArray addObject:image];
            }
        }
        
        _returnCode = 0;
        [(self.delegate) onCallback:0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
    
    }];
    
    
    return YES;
}

- (BOOL)fetchAllByUser:(NSMutableArray *)imageArray Token:(NSString *)token UserId:(NSInteger)userId
{
    self.returnCode = 1;
    
    self.imageArray = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager GET:[NSString stringWithFormat:API_IMAGE_USER, 0, 200, userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
           
            self.returnCode = 0;
            [self.imageArray removeAllObjects];
        
        } else {
            self.returnCode = 1;
            self.errorMessage = [responseObject objectForKey:@"error"];
            
            [(self.delegate) onCallback:0];
            
            return;
        }
        
        NSMutableArray *posts = [(NSDictionary *)responseObject objectForKey:@"images"];
        
        
        for (NSDictionary *post in posts) {
            Image *image = [[Image alloc] init];
            
            image.imageId = [[post objectForKey:@"id"] intValue];
            image.name = [self escape:[post objectForKey:@"name"]];
            
            image.description = [self escape:[post objectForKey:@"description"]];
            image.tags = [self escape:[post objectForKey:@"tags"]];
            
            image.created = [self escape:[post objectForKey:@"created_at"]];
            image.modified = [self escape:[post objectForKey:@"updated_at"]];
            
            image.username = [self escape:[post objectForKey:@"username"]];
            image.useremail = [self escape:[post objectForKey:@"email"]];
            
            image.fileName = [self escape:[post objectForKey:@"image"]];
            image.thumbnail = [self escape:[NSString stringWithFormat:@"iphone_thumb_%@", image.fileName]];
            
            if ([image.thumbnail isEqualToString:@""]) {
                image.imageUrl = nil;
            } else {
                image.imageUrl = [self escape:[NSString stringWithFormat:@"%@%@", URL_IMAGE_PATH, image.thumbnail]];
            }
            
            image.imageWithWatermarkUrl = @"";
            
            image.height = [((NSString *)[post objectForKey:@"height"]) integerValue];
            image.width = [((NSString *)[post objectForKey:@"width"]) integerValue];
            
            image.licenseArray = [[NSMutableArray alloc] init];
            [self getLicense:image.licenseArray License:[self escape:[post objectForKey:@"image_license"]]];
            
            //NSLog(@"image license = %@", image.licenseArray);
            
            [self.imageArray addObject:image];
            
            image = nil;
        }
        
        if ([self.imageArray count] >= 1) {
            [imageArray removeAllObjects];
            for (Image *image in self.imageArray) {
                [imageArray addObject:image];
            }
        }
        
        self.returnCode = 0;
        [(self.delegate) onCallback:0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.returnCode = 1;
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    
    return YES;
}

- (BOOL)fetchPurchaseByUser:(NSMutableArray *)imageArray Token:(NSString *)token UserId:(NSInteger)userId
{
    _returnCode = 1;
    
    self.imageArray = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager GET:[NSString stringWithFormat:@"%@%ld", API_IMAGE_USER_PURCHASE, (long)userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            [self.imageArray removeAllObjects];
        } else {
            self.returnCode = 1;
            self.errorMessage = [responseObject objectForKey:@"error"];
            
            [(self.delegate) onCallback:0];
            
            return;
        }
        
        NSMutableArray *posts = [responseObject objectForKey:@"images"];
        
        if (posts == nil || [posts count] <= 0) {
            self.returnCode = 1;
            self.errorMessage = [responseObject objectForKey:@"error"];
            
            [(self.delegate) onCallback:0];
            
            return;
        }
        
        for (NSDictionary *post in posts) {
            Image *image = [[Image alloc] init];
            
            image.imageId = [[post objectForKey:@"id"] intValue];
            image.name = [self escape:[post objectForKey:@"name"]];
            
            image.description = [self escape:[post objectForKey:@"description"]];
            image.tags = [self escape:[post objectForKey:@"tags"]];
            
            image.created = [self escape:[post objectForKey:@"created_at"]];
            image.modified = [self escape:[post objectForKey:@"updated_at"]];
            
            image.username = [self escape:[post objectForKey:@"username"]];
            image.useremail = [self escape:[post objectForKey:@"email"]];
            
            image.fileName = [self escape:[post objectForKey:@"image"]];
            image.thumbnail = [self escape:[NSString stringWithFormat:@"iphone_thumb_%@", image.fileName]];
            
            if ([image.thumbnail isEqualToString:@""]) {
                image.imageUrl = nil;
            } else {
                image.imageUrl = [self escape:[NSString stringWithFormat:@"%@%@", URL_IMAGE_PATH, image.thumbnail]];
            }
            
            image.imageWithWatermarkUrl = @"";
            
            image.height = [((NSString *)[post objectForKey:@"height"]) integerValue];
            image.width = [((NSString *)[post objectForKey:@"width"]) integerValue];
            
            image.licenseArray = [[NSMutableArray alloc] init];
            [self getLicense:image.licenseArray License:[self escape:[post objectForKey:@"image_license"]]];
            
            [self.imageArray addObject:image];
            
            image = nil;
        }
        
        if ([self.imageArray count] >= 1) {
            [imageArray removeAllObjects];
            for (Image *image in self.imageArray) {
                [imageArray addObject:image];
            }
        }
        
        _returnCode = 0;
        [(self.delegate) onCallback:0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    
    return YES;
}

- (BOOL)fetchSalesByUser:(NSMutableArray *)imageArray Token:(NSString *)token UserId:(NSInteger)userId
{
    _returnCode = 1;
    
    self.imageArray = imageArray;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager GET:[NSString stringWithFormat:API_IMAGE_USER_SALES, 0, 200, userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            [self.imageArray removeAllObjects];
        } else {
            self.returnCode = 1;
            self.errorMessage = [responseObject objectForKey:@"error"];
            
            [(self.delegate) onCallback:0];
            
            return;
        }
        
        NSMutableArray *posts = [responseObject objectForKey:@"images"];
        
        if (posts == nil || [posts count] <= 0) {
            self.returnCode = 1;
            [(self.delegate) onCallback:0];
            
            return;
        }
        
        for (NSDictionary *post in posts) {
            Image *image = [[Image alloc] init];
            
            image.imageId = [[post objectForKey:@"id"] intValue];
            image.name = [self escape:[post objectForKey:@"name"]];
            
            image.description = [self escape:[post objectForKey:@"description"]];
            image.tags = [self escape:[post objectForKey:@"tags"]];
            
            image.created = [self escape:[post objectForKey:@"created_at"]];
            image.modified = [self escape:[post objectForKey:@"updated_at"]];
            
            image.username = [self escape:[post objectForKey:@"username"]];
            image.useremail = [self escape:[post objectForKey:@"email"]];
            
            image.fileName = [self escape:[post objectForKey:@"image"]];
            image.thumbnail = [self escape:[NSString stringWithFormat:@"iphone_thumb_%@", image.fileName]];
            
            if ([image.thumbnail isEqualToString:@""]) {
                image.imageUrl = nil;
            } else {
                image.imageUrl = [self escape:[NSString stringWithFormat:@"%@%@", URL_IMAGE_PATH, image.thumbnail]];
            }
            
            image.imageWithWatermarkUrl = @"";
            
            image.height = [((NSString *)[post objectForKey:@"height"]) integerValue];
            image.width = [((NSString *)[post objectForKey:@"width"]) integerValue];
            
            image.licenseArray = [[NSMutableArray alloc] init];
            [self getLicense:image.licenseArray License:[self escape:[post objectForKey:@"image_license"]]];
            
            image.price = [self escape:[post objectForKey:@"price"]];
            image.quantity = [self escape:[post objectForKey:@"quantity"]];
            
            [self.imageArray addObject:image];
            
            image = nil;
        }
        
        _returnCode = 0;
        [(self.delegate) onCallback:0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    return YES;
}

- (BOOL)fetchSalesByMonth:(NSMutableArray *)imageArray Month:(NSInteger)month Year:(NSInteger)year Token:(NSString *)token UserId:(NSInteger)userId
{
    _returnCode = 1;
    
    self.imageArray = imageArray;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager GET:[NSString stringWithFormat:API_IMAGE_USER_SALES_BYMONTH, userId, month, year] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            [self.imageArray removeAllObjects];
        } else {
            self.returnCode = 1;
            self.errorMessage = [responseObject objectForKey:@"error"];
            
            [(self.delegate) onCallback:0];
            
            return;
        }
        
        NSMutableArray *posts = [responseObject objectForKey:@"sales"];
        
        if (posts == nil || [posts count] <= 0) {
            self.returnCode = 1;
            [(self.delegate) onCallback:0];
            
            return;
        }
        
        for (NSDictionary *post in posts) {
            Image *image = [[Image alloc] init];
            
            image.imageId = [[post objectForKey:@"id"] intValue];
            image.name = [self escape:[post objectForKey:@"name"]];
            
            image.description = [self escape:[post objectForKey:@"description"]];
            image.tags = [self escape:[post objectForKey:@"tags"]];
            
            image.created = [self escape:[post objectForKey:@"created_at"]];
            image.modified = [self escape:[post objectForKey:@"updated_at"]];
            
            image.username = [self escape:[post objectForKey:@"username"]];
            image.useremail = [self escape:[post objectForKey:@"email"]];
            
            image.fileName = [self escape:[post objectForKey:@"image"]];
            image.thumbnail = [self escape:[NSString stringWithFormat:@"iphone_thumb_%@", image.fileName]];
            
            if ([image.thumbnail isEqualToString:@""]) {
                image.imageUrl = nil;
            } else {
                image.imageUrl = [self escape:[NSString stringWithFormat:@"%@%@", URL_IMAGE_PATH, image.thumbnail]];
            }
            
            image.imageWithWatermarkUrl = @"";
            
            image.height = [((NSString *)[post objectForKey:@"height"]) integerValue];
            image.width = [((NSString *)[post objectForKey:@"width"]) integerValue];
            
            image.licenseArray = [[NSMutableArray alloc] init];
            [self getLicense:image.licenseArray License:[self escape:[post objectForKey:@"image_license"]]];
            
            image.price = [self escape:[post objectForKey:@"price"]];
            image.quantity = [self escape:[post objectForKey:@"quantity"]];
            
            [self.imageArray addObject:image];
            
            image = nil;
        }
        
        _returnCode = 0;
        [(self.delegate) onCallback:0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _returnCode = 1;
        //NSLog(@"%@", error);
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    return YES;
}

- (BOOL)updateInfo:(NSDictionary *)values
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = values;
    
    [manager POST:[NSString stringWithFormat:@"%@%d", API_IMAGE_UPDATE_INFO, self.imageId] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
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
        self.returnCode = 1;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    return YES;

}

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
    
#if true
    
    NSDictionary *parameters = values;
    NSString *filePath = [values objectForKey:@"file_path"];
    NSString *fileName = [values objectForKey:@"file_name"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:API_IMAGE_UPLOAD, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"fileinfo" fileName:fileName mimeType:@"image/jpg" error:nil];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
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
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.delegate onCallback:0];
    }];
    
    [uploadTask resume];
    
    [progress addObserver:self
               forKeyPath:@"fractionCompleted"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
#else
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"userId":[NSString stringWithFormat:@"%ld", (long)user.userId]};
    NSURL *filePath = [NSURL fileURLWithPath:photoPath];
    
    AFHTTPRequestOperation *operation = [manager POST:API_IMAGE_UPLOAD parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:filePath name:@"media" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            
        } else {
            
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.progress.tag = 0;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //NSLog(@"Error: %@", error);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.progress.tag = 0;
        
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        self.progress.progress = (float)(totalBytesWritten) / totalBytesExpectedToWrite;
    }];
    
#endif
    
    return YES;
}

- (BOOL)upload2:(NSDictionary *)values
{
#if false
    'name' => 'api image',
    'description' => 'api description',
    'place' => 'api place',
    'tags' => 'api tags',
    'image_license[]' => 'Editorial',
    'photo_shoot_type' => 'Chess'
#endif
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = values;
    
    [manager POST:[NSString stringWithFormat:@"%@/%d", API_IMAGE_UPLOAD2, self.uploadedId] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"Success: %@", responseObject);
        
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
        self.returnCode = 1;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.errorMessage = @"Network failed";
        
        [(self.delegate) onCallback:0];
        
    }];
    
    
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

- (BOOL)getLicense:(NSMutableArray *)licenseArray License:(NSString *)license
{
    [licenseArray removeAllObjects];
    [licenseArray addObject:license];
    return YES;
    
    if ([[license stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Editorial"]) {
        [licenseArray addObject:@"Editorial"];
    }
    
    if ([[license stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Commercial"]) {
        [licenseArray addObject:@"Commercial"];
    } else {
        [licenseArray addObject:@"Editorial"];
        [licenseArray addObject:@"Commercial"];
    }
    
    return YES;
    
}


@end
