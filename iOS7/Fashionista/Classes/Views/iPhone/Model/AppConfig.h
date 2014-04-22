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
@property (atomic, assign) NSInteger stage;

+ (id)getInstance;

@end
