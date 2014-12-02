//
//  MasterViewController.h
//  PandoraUI-Orange
//
//  Created by Valentin Filip on 10/23/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardItemCell.h"
#import "UploadController.h"
#import "Brander.h"
#import "BoardThemeItemCell.h"

@interface BoardController : UIViewController <UITableViewDataSource, UITableViewDelegate, StoreCellDelegate, NetworkCallbackDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain) NSMutableArray *imageArray;
@property (retain) Image *photo;
@property (retain) Image *currentPhoto;

@property (atomic, retain) UIRefreshControl *refreshControl;
@property (retain) UploadController *uploadController;

@end
