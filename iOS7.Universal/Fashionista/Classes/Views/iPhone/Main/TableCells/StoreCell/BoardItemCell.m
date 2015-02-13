//
//  StoreCell.m
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "BoardItemCell.h"

#import "DataSource.h"
#import "DiskCache.h"
#import "AFNetworking.h"
#import "Global.h"
#import "User.h"
#import "Brander.h"
#import "Image+ImageApi.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation BoardItemCell

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
    
    _data = data;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageVBkg.image = [[UIImage imageNamed:@"list-item-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 30, 30)];
    self.imageVStage.image = [UIImage imageNamed:@"list-item-stage"];
    
    self.imageVImage.image = nil;
    self.imageVAvatar.image = nil;
    
    [self loadImage:self.photo.thumbnail fileName:self.photo.thumbnailName ImageView:self.imageVImage];
    [self loadImage:self.photo.usericon fileName:[NSString stringWithFormat:@"%@.jpg", self.photo.usertoken] ImageView:self.imageVAvatar];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 35;
    
    self.imageVImage.frame = CGRectMake(35, self.brandContainer.frame.origin.y + self.brandContainer.frame.size.height, width, self.photo.height * width / self.photo.width);
    
    self.imageVImage.contentMode = UIViewContentModeScaleAspectFill;
    //[self.imageVImage setBackgroundColor:[UIColor yellowColor]];
    
    
    CGRect frame = self.imageVBkg.frame;
    frame.size.width = width + 35;
    if (self.photo.name == nil || [[self.photo.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
        frame.size.height = 44 + 42 + self.imageVImage.frame.size.height;
        self.actionListView.frame = CGRectMake(35, self.imageVImage.frame.origin.y + self.imageVImage.frame.size.height, width, self.actionListView.frame.size.height);
        [self.labelTitle setHidden:YES];
        
    } else {
        
        frame.size.height = 44 + 44 + 42 + self.imageVImage.frame.size.height;
        self.actionListView.frame = CGRectMake(35, self.imageVImage.frame.origin.y + self.imageVImage.frame.size.height + 44, width, self.actionListView.frame.size.height);

        [self.labelTitle setHidden:NO];
        [self.labelTitle setText:self.photo.name];
        self.labelTitle.frame = CGRectMake(40, self.actionListView.frame.origin.y - 44 + 10, self.actionListView.frame.size.width, 21);;
    }
    
    self.imageVBkg.frame = frame;
    
    NSString *name;
    NSString *brand;
    
    name = self.photo.username;
    brand = @"";
    
    NSString *text = [NSString stringWithFormat:@"by %@", name];
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

- (IBAction)onShareButtonTouched:(id)sender
{
    //NSLog(@"sharebutton pressed");
    
    if ([FBDialogs canPresentShareDialogWithPhotos]) {
        
        FBPhotoParams *params = [[FBPhotoParams alloc] init];
        
        // Note that params.photos can be an array of images.  In this example
        // we only use a single image, wrapped in an array.
        
        UIImage *image = [self.cache getImage:self.photo.thumbnailName];
        
        if (image == nil) {
         
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please wait the image displayed first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        params.photos = @[image];
        
        [FBDialogs presentShareDialogWithPhotoParams:params
                                         clientState:nil
                                             handler:^(FBAppCall *call,
                                                       NSDictionary *results,
                                                       NSError *error) {
                                                 if (error) {
                                                     NSLog(@"Error: %@",
                                                           error.description);
                                                 } else {
                                                     NSLog(@"Success!");
                                                 }
                                             }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"To share photo to Facebook, you will have to install Facebook app on your iOS device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
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
                [imageView setImage:image];
                
            } else {
                [imageView setImage:image];
            }
            
            DiskCache *cache = [DiskCache getInstance];
            [cache addImage:image fileName:filename];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // NSLog(@"%@", error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    [requestOperation start];
    return YES;
}

@end
