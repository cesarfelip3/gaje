//
//  BrandListView.m
//  Gaje
//
//  Created by hello on 14-7-12.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "BrandListView.h"


#import "DataSource.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"
#import "Brander.h"

@implementation BrandListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        for (UIImageView *imageView in self.imageArray) {
            imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            imageView.layer.borderWidth = 1;
        }
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        for (UIImageView *imageView in self.imageArray) {
            imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            imageView.layer.borderWidth = 1;
        }
    }
    return self;
}

- (BOOL)cleanBranderIcons
{
    for (UIImageView *image in self.imageArray) {
        
        image.image = nil;
    }
    
    return YES;
}

- (BOOL)loadBranderIcons
{
    
    NSInteger i = 0;
    NSInteger count = [self.photo.branderArray count] - 1;
    
    for (i = 0; i < [self.photo.branderArray count]; i++) {
    
        UIImageView *imageView = [self.imageArray objectAtIndex:i];
        //imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //imageView.layer.borderWidth = 1;
        
        Brander *brander = [self.photo.branderArray objectAtIndex: count - i];
        
        [self loadImage:brander.iconurl fileName:brander.token ImageView:imageView];
    
        if (i >= 9) {
            break;
        }
    }
    
    return YES;
}

- (BOOL)loadImage:(NSString *)url fileName:(NSString *)filename ImageView:(UIImageView *)imageView
{
    
    if (!self.cache) {
        self.cache = [DiskCache getInstance];
    }
    
    if (self.cache) {
        
        UIImage *image = [self.cache getImage:filename];
        
        if (image) {
            [imageView setImage:image];
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
            
            [imageView setImage:image];
            DiskCache *cache = [DiskCache getInstance];
            [cache addImage:responseObject fileName:filename];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    [requestOperation start];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
