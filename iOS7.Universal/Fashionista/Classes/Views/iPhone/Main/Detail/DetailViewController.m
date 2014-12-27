//
//  MapViewController.m
//  
//
//  Created by Valentin Filip on 2/16/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "DetailViewController.h"

#import "ADVTheme.h"
#import "DataSource.h"
#import "ADVGalleryPlain.h"

#import "UIColor+Alpha.h"

#import <QuartzCore/QuartzCore.h>

@interface DetailViewController ()

@property (nonatomic, strong) NSMutableArray *tagViews;

@end




@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Detail";
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 40, 30);
    [btnSearch setImage:[UIImage imageNamed:@"navigation-btn-settings"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    _imageBkg.image = [[UIImage imageNamed:@"background-content"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _viewDetails.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    [self loadImage:self.photo.url fileName:self.photo.fileName ImageView:self.imageContent];
    
    //[self configureView];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setViewGallery:nil];
    [self setImageBkg:nil];
    [self setViewStage:nil];
    [self setViewDetails:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - View config

- (void)configureView {
    if (!self.item) {
        self.item = [DataSource timeline][0];
    }
    
    //[ADVThemeManager customizeView:self.view];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]]];
    
    _viewGallery.images = _item[@"images"];
    
    UILabel *lblName = (UILabel *)[_viewStage viewWithTag:1];
    lblName.text = _item[@"name"];
    lblName.textColor = [UIColor colorWithRed:0.87f green:0.23f blue:0.19f alpha:1.00f];
    lblName.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
    
    UILabel *lblDesc = (UILabel *)[_viewStage viewWithTag:2];
    lblDesc.text = _item[@"description"];
    lblDesc.textColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];
    lblDesc.font = [UIFont fontWithName:@"Avenir-Heavy" size:12];
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    fmt.numberStyle = NSNumberFormatterDecimalStyle;
    UILabel *lblPrice = (UILabel *)[_viewStage viewWithTag:3];
    lblPrice.text = [NSString stringWithFormat:@"$%@", [fmt stringFromNumber:_item[@"price"]]];
    lblPrice.textColor = [UIColor colorWithRed:0.87f green:0.23f blue:0.19f alpha:1.00f];
    lblPrice.font = [UIFont fontWithName:@"Avenir-Heavy" size:22];
    
    NSArray *sizes = _item[@"sizes"];
    UILabel *lblSizesTitle = (UILabel *)[_viewDetails viewWithTag:1];
    lblSizesTitle.textColor = [UIColor colorWithRed:0.87f green:0.23f blue:0.19f alpha:1.00f];
    lblSizesTitle.font = [UIFont fontWithName:@"Avenir-Heavy" size:12];
    
    UILabel *lblSizes = (UILabel *)[_viewDetails viewWithTag:2];
    lblSizes.text = [sizes componentsJoinedByString:@", "];
    lblSizes.textColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];
    lblSizes.font = [UIFont fontWithName:@"Avenir-Heavy" size:12];
    
    NSArray *colors = _item[@"colors"];
    UILabel *lblColorsTitle = (UILabel *)[_viewDetails viewWithTag:4];
    lblColorsTitle.textColor = [UIColor colorWithRed:0.87f green:0.23f blue:0.19f alpha:1.00f];
    lblColorsTitle.font = [UIFont fontWithName:@"Avenir-Heavy" size:12];
    
    for (UIView *subView in _viewDetails.subviews) {
        if (subView.tag >= 100) {
            [subView removeFromSuperview];
        }
    }
    
    CGFloat tag = 100;
    CGFloat offset = CGRectGetMinX(lblColorsTitle.frame);
    CGFloat padding = 5;
    for (NSString *colorHex in colors) {
        UIColor *color = [UIColor colorWithHexString:colorHex];
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(offset, CGRectGetMaxY(lblColorsTitle.frame) + padding, 15, 15)];
        colorView.backgroundColor = color;
        colorView.tag = tag++;
        
        offset = CGRectGetMaxX(colorView.frame) + padding;
        [_viewDetails addSubview:colorView];
    }
    
    UIButton *btnAdd = (UIButton *)[_viewDetails viewWithTag:5];
    btnAdd.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17];
    
    CGRect frameDetails = _viewDetails.frame;
    frameDetails.size.height = CGRectGetMaxY(btnAdd.frame) + 20;
    _viewDetails.frame = frameDetails;
    
    CGRect frameBkg = _imageBkg.frame;
    frameBkg.size.height = CGRectGetMaxY(frameDetails) - 5;
    _imageBkg.frame = frameBkg;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, CGRectGetMaxY(_viewDetails.frame) + 20);
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
            
            NSInteger width = 280;
            NSInteger height = self.photo.height * width / self.photo.width;
            
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 280, height);
            
            //width = 300;
            //height = self.photo.height * width / self.photo.width;
            _imageBkg.frame = CGRectMake(_imageBkg.frame.origin.x, _imageBkg.frame.origin.y, 300, height + 25);
            
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
            
            [imageView setImage:image];
            NSInteger width = 280;
            NSInteger height = self.photo.height * width / self.photo.width;
            
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 280, height);
            _imageBkg.frame = CGRectMake(_imageBkg.frame.origin.x, _imageBkg.frame.origin.y, 300, height + 25);
            
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
