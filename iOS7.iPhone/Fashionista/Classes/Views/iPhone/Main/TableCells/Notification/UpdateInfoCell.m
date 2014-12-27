//
//  UpdateInfoCell.m
//  Gaje
//
//  Created by hello on 14-8-13.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "UpdateInfoCell.h"

@implementation UpdateInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)loadImage:(NSString *)url fileName:(NSString *)filename
{
    if (!self.cache) {
        self.cache = [DiskCache getInstance];
    }
    
    if (self.cache) {
        
        UIImage *image = [self.cache getImage:filename];
        
        if (image) {
            [self.imageIcon setImage:image];
            //self.imageVAvatar.frame = CGRectMake(0, 0, 30, 30);
            return YES;
        }
    }
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //// NSLog(@"Response: %@", responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        UIImage *image = responseObject;
        
        if (image) {
            
            [self.imageIcon setImage:image];
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
