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
#import "Theme.h"

@class ThemeController;

@interface UploadController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, NetworkCallbackDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (retain) IBOutlet UITableView *tableViewThemeList;
@property (retain) IBOutlet UIBarButtonItem *chooseButton;
@property (retain) IBOutlet UIProgressView *progressBar;
@property (retain) Image *photo;
@property (retain) UIImage *image;

@property (retain) ThemeController *themeController;
@property (retain) NSMutableArray *themeArray;

- (IBAction)onBottombarButtonTouched:(id)sender;

@end
