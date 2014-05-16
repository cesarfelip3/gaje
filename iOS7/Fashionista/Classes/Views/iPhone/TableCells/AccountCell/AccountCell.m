//
//  AccountCell.m
//
//  Created by Valentin Filip on 4/13/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "AccountCell.h"
#import "UIImage+StackBlur.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"

#import <QuartzCore/QuartzCore.h>

@implementation AccountCell

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

+ (void)initialize {
    
}

- (void)initialize {
    [[self class] initialize];
    
}


#pragma mark - Accessors

- (void)setData:(NSDictionary *)data {
    UIImage *imgCover = [UIImage imageNamed:data[@"cover"]];
    
//    dispatch_queue_t blurThread = dispatch_queue_create("blurThread", NULL);
//    dispatch_async(blurThread, ^{
//        UIImage *imgBkg = [imgCover stackBlur:30];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.imageVBkg.image = imgBkg;
//        });
//    });
    
    self.imageVBkg.image = imgCover;
    
    _lblTitle.text = data[@"name"];
    _lblTitle.font = [UIFont fontWithName:@"Avenir-Heavy" size:17];
    
    //NSNumber *followers = data[@"followers"];
    //NSNumber *following = data[@"following"];
    
    _lblStats.text = @""; //[NSString stringWithFormat:@"%@ Following, %@ Followers", following, followers];
    _lblStats.font = [UIFont fontWithName:@"Avenir-Heavy" size:10];
    
    User *user = [User getInstance];
    
    NSString *url = [NSString stringWithFormat:FB_PROFILE_ICON, user.token];
    NSLog(@"profile icon url = %@", url);
    
    self.imageVAvatar.contentMode = UIViewContentModeScaleAspectFit;
    [self loadImage:url fileName:user.token];
}

- (BOOL)loadImage:(NSString *)url fileName:(NSString *)filename
{
    if (!self.cache) {
        self.cache = [DiskCache getInstance];
    }
    
    if (self.cache) {
        
        UIImage *image = [self.cache getImage:filename];
        
        if (image) {
            [self.imageVAvatar setImage:image];
            //self.imageVAvatar.frame = CGRectMake(0, 0, 30, 30);
            return YES;
        }
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Response: %@", responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        UIImage *image = responseObject;
      
        if (image) {
            
            [self.imageVAvatar setImage:image];
            DiskCache *cache = [DiskCache getInstance];
            [cache addImage:responseObject fileName:filename];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    [requestOperation start];
    return YES;
}


@end
