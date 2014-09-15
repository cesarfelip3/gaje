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
#import "User.h"
#import "DiskCache.h"
#import "Comment.h"
#import "Brander.h"


@interface Image : Model

@property (atomic, assign) NSInteger imageId;
@property (atomic, retain) NSString *imageUUID;
@property (atomic, retain) NSString *userUUID;
@property (atomic, retain) NSString *username;
@property (atomic, retain) NSString *usertoken;
@property (atomic, retain) NSString *usericon;

@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *description;
@property (atomic, retain) NSString *tags;
@property (atomic, assign) NSInteger height;
@property (atomic, assign) NSInteger width;

@property (atomic, retain) NSString *fileName;

@property (atomic, retain) NSString *url;
@property (atomic, retain) NSString *thumbnail;
@property (atomic, strong) NSString *thumbnailName;

@property (atomic, retain) NSString *created;
@property (atomic, retain) NSString *modified;

// table relationship properties

@property (strong) NSString *commentUUID;
@property (strong) NSString *branderUUID;

@property (atomic, assign) NSInteger branderCount;
@property (atomic, strong) NSMutableArray *branderArray;
@property (atomic, assign) NSInteger enableBrandIt;
@property (atomic, assign) NSInteger brandIt;

// update

@property (assign) NSInteger status;

// accessory properties

@property (atomic, assign) NSString *errorMessage;

@property (atomic, retain) NSString *delegateType;
@property (atomic, retain) id<NetworkCallbackDelegate> delegate;

@property (atomic, retain) UIProgressView *progress;

@end
