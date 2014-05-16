//
//  Post.h
//  Pixcell8
//
//  Created by  on 13-10-27.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "Model.h"
#import "NetworkCallbackDelegate.h"

@class DiskCache;
@class User;

@interface Image : Model

@property (atomic, assign) NSInteger imageId;
@property (atomic, retain) NSString *imageUUID;

@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *description;
@property (atomic, retain) NSString *tags;
@property (atomic, retain) NSMutableArray *licenseArray;
@property (atomic, retain) NSString *shootType;

@property (atomic, retain) NSString *fileName;
@property (atomic, retain) NSString *thumbnail;

@property (atomic, retain) NSString *imageUrl;
@property (atomic, retain) NSString *imageWithWatermarkUrl;
@property (atomic, retain) NSString *created;
@property (atomic, retain) NSString *modified;

// user
@property (atomic, retain) NSString *username;
@property (atomic, retain) NSString *useremail;
@property (atomic, assign) NSInteger userId;

// price
@property (atomic, retain) NSString *price;
@property (atomic, retain) NSString *quantity;

@property (atomic, assign) NSInteger returnCode;
@property (atomic, assign) NSString *errorMessage;

@property (atomic, retain) NSMutableArray *imageArray;
@property (atomic, retain) NSMutableArray *imageArray2;
@property (atomic, retain) UITableView *tableView;

@property (atomic, retain) NSString *uploadedImageId;
@property (atomic, retain) id<NetworkCallbackDelegate> delegate;

@property (atomic, assign) NSInteger uploadStage;
@property (atomic, assign) NSInteger height;
@property (atomic, assign) NSInteger width;

@property (atomic, retain) UIProgressView *progress;

@property (atomic, assign) NSInteger uploadedId;


- (BOOL)fetchLatest:(NSMutableArray *)imageArray Token:(NSString *)token;
- (BOOL)fetchAllByKeywords:(NSMutableArray *)imageArray Keywords:(NSString *)keywords Token:(NSString *)token;

- (BOOL)fetchAllByUser:(NSMutableArray *)imageArray Token:(NSString *)token UserId:(NSInteger)userId;
- (BOOL)fetchSalesByUser:(NSMutableArray *)imageArray Token:(NSString *)token UserId:(NSInteger)userId;
- (BOOL)fetchPurchaseByUser:(NSMutableArray *)imageArray Token:(NSString *)token UserId:(NSInteger)userId;
- (BOOL)fetchSalesByMonth:(NSMutableArray *)imageArray Month:(NSInteger)month Year:(NSInteger)year Token:(NSString *)token UserId:(NSInteger)userId;

- (BOOL)updateInfo:(NSDictionary *)values;

//- (BOOL)fetchAll:(NSMutableArray *)imageArray Filters:(NSString *)filters Page:(NSInteger)page PageSize:(NSInteger)pageSize;

- (BOOL)upload:(NSDictionary *)values ProgressBar:(UIProgressView *)progressBar;
- (BOOL)upload2:(NSDictionary *)values;


@end
