//
//  ProfileItemCell.m
//  Gaje
//
//  Created by hello on 14-7-30.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "ProfileItemCell.h"

#import "DataSource.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"
#import "Brander.h"
#import "Image+ImageApi.h"

@implementation ProfileItemCell

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

- (void)setData:(NSDictionary *)data {
    
    _data = data;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageVBkg.image = [[UIImage imageNamed:@"list-item-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 30, 30)];
    //self.imageVStage.image = [UIImage imageNamed:@"list-item-stage"];
    
    self.imageVImage.image = nil;
    self.imageVAvatar.image = nil;
    
    [self loadImage:self.photo.thumbnail fileName:self.photo.thumbnailName ImageView:self.imageVImage];
    [self loadImage:self.photo.usericon fileName:[NSString stringWithFormat:@"%@.jpg", self.photo.usertoken] ImageView:self.imageVAvatar];
    
    self.imageVImage.frame = CGRectMake(self.imageVImage.frame.origin.x, self.imageVImage.frame.origin.x, 280, self.photo.height * 280 / self.photo.width);
    
    NSString *name;
    NSString *brand;
    
    name = self.photo.name;
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
    
    _lblValue.text = self.photo.modified;
    _lblValue.textColor = [UIColor colorWithRed:0.42f green:0.44f blue:0.47f alpha:1.00f];
    _lblValue.font = [UIFont fontWithName:@"Cabin-Bold" size:fontSize];
    
    if ([self.photo.branderArray count] > 0) {
        
        [self.btnBrand setTitle:[NSString stringWithFormat:@"%d Brands", self.photo.branderCount] forState:UIControlStateNormal];
    } else {
        
        [self.btnBrand setTitle:[NSString stringWithFormat:@"%d Brands", self.photo.branderCount] forState:UIControlStateNormal];
    }
    
    [self.brandContainer cleanBranderIcons];
    self.brandContainer.photo = self.photo;
    [self.brandContainer loadBranderIcons];
    
    return;
    
}

- (BOOL)onBrandButtonTouched {
    
    // NSLog(@"brand clicked");
    
    // 280 / 10 = 28
    
    if (self.photo.enableBrandIt == 0) {
        return NO;
    }
    
    User *user = [User getInstance];
    
    Brander *brander = [[Brander alloc] init];
    brander.username = user.username;
    brander.iconurl = user.iconurl;
    brander.token = user.token;
    
    if (self.photo.branderArray == nil) {
        self.photo.branderArray = [[NSMutableArray alloc] init];
    }
    
    [self.photo.branderArray addObject:brander];
    [self.brandContainer loadBranderIcons];
    
    if (user.userUUID == nil) {
        return NO;
    }
    
    NSDictionary *values = @{@"image_uuid":self.photo.imageUUID, @"user_uuid":user.userUUID};
    [self.photo addBrander:values Token:@""];
    
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
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //// NSLog(@"Response: %@", responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        UIImage *image = responseObject;
        
        if (image) {
            
            if (imageView == self.imageVAvatar) {
                image = [[User getInstance] crop:image];
            }
            [imageView setImage:image];
            DiskCache *cache = [DiskCache getInstance];
            [cache addImage:image fileName:filename];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    [requestOperation start];
    return YES;
}

@end
