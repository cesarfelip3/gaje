//
//  AppConfig.h
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppConfig : NSObject

@property (atomic, assign) int screenWidth;
@property (atomic, assign) int screenHeight;
@property (atomic, assign) NSInteger userIsLogin;
@property (atomic, assign) NSInteger imageIsUploaded;
@property (atomic, assign) NSInteger imageIsUploading;

@property (atomic, retain) NSString *dbPath;

@property (atomic, retain) NSString *token;
@property (atomic, retain) NSString *uuid;
@property (atomic, assign) NSInteger fbstage;
@property (atomic, strong) NSString *fbfrom;

@property (assign) NSInteger numberOfNotifications;

@property (atomic, strong) NSString *userSearchKeyword;

@property (atomic, assign) BOOL applicationLaunched;

+ (id)getInstance;

@end
