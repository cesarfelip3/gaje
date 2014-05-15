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

@interface UploadController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, NetworkCallbackDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (retain) IBOutlet UIBarButtonItem *chooseButton;
@property (retain) IBOutlet UIProgressView *progressBar;

- (IBAction)onBottombarButtonTouched:(id)sender;

@end
