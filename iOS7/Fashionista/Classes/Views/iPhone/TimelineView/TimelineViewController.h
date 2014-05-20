//
//  MasterViewController.h
//  PandoraUI-Orange
//
//  Created by Valentin Filip on 10/23/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreCell.h"
#import "UploadController.h"

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, StoreCellDelegate, NetworkCallbackDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain) NSMutableArray *imageArray;
@property (retain) Image *photo;


@property (retain) UploadController *uploadController;

@end
