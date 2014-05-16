//
//  UploadController.h
//  Gaje
//
//  Created by hello on 14-5-14.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkCallbackDelegate.h"
#import "DiskCache.h"
#import "Image.h"

@interface UploadController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, NetworkCallbackDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (retain) IBOutlet UIBarButtonItem *chooseButton;
@property (retain) IBOutlet UIProgressView *progressBar;
@property (retain) Image *photo;
@property (retain) UIImage *image;

- (IBAction)onBottombarButtonTouched:(id)sender;

@end
