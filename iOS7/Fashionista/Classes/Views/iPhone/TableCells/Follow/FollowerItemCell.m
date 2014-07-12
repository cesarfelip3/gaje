//
//  FollowerItemCell.m
//  Gaje
//
//  Created by hello on 14-7-12.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "FollowerItemCell.h"

#import "DataSource.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"
#import "Brander.h"

@implementation FollowerItemCell

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

- (void)setData {
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageVBkg.image = [[UIImage imageNamed:@"list-item-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 30, 30)];
    self.imageVStage.image = [UIImage imageNamed:@"list-item-stage"];
    
    if ([self.follower.imageArray count] > 0) {
        
        self.photo = [self.follower.imageArray objectAtIndex:0];
    }
    
    if (self.photo) {
        
        [self loadImage:self.photo.thumbnail fileName:self.photo.thumbnailName ImageView:self.imageVImage];
    }
    
    [self loadImage:self.follower.iconurl fileName:self.follower.icon ImageView:self.imageVAvatar];
    
    NSString *name;
    NSString *brand;
    
    name = self.follower.username;
    brand = @"";
    
    NSString *text = [NSString stringWithFormat:@"%@", name];
    // Create the attributes
    
    const CGFloat fontSize = 12;
    UIFont *boldFont = [UIFont fontWithName:@"Cabin-Bold" size:fontSize];
    UIFont *regularFont = [UIFont fontWithName:@"Cabin-Bold" size:fontSize];
    UIColor *regularColor = [UIColor colorWithRed:0.42f green:0.44f blue:0.47f alpha:1.00f];
    UIColor *boldColor = [UIColor blackColor];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           regularColor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              boldFont, NSFontAttributeName,
                              boldColor, NSForegroundColorAttributeName, nil];
    const NSRange range = NSMakeRange(0, name.length);
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    
    
    [_lblTitle setAttributedText:attributedText];
    
    _lblValue.text = @"";
    _lblValue.textColor = [UIColor colorWithRed:0.42f green:0.44f blue:0.47f alpha:1.00f];
    _lblValue.font = [UIFont fontWithName:@"Cabin-Bold" size:fontSize];
    
    [_btnFav addTarget:self action:@selector(actionToggleFav:) forControlEvents:UIControlEventTouchDown];
    
#if false
    if ([DataSource itemIsFavorite:_data] < 0) {
        [_btnFav setImage:[UIImage imageNamed:@"list-item-love"] forState:UIControlStateNormal];
    } else {
        [_btnFav setImage:[UIImage imageNamed:@"list-item-love-selected"] forState:UIControlStateNormal];
    }
#endif
    
    
    
    return;
    
}

- (IBAction)onBrandButtonTouched:(id)sender {
    
    NSLog(@"brand clicked");
    
    
#if false
    if ([_delegate respondsToSelector:@selector(cellDidToggleFavoriteState:forItem:)]) {
        [_delegate cellDidToggleFavoriteState:self forItem:_data];
    }
#endif
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

@end
