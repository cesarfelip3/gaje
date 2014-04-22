//
//  Model.h
//  Pixcell8
//
//  Created by  on 14-2-8.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "AppConfig.h"

@interface Model : NSObject

@property (atomic, retain) FMDatabase *db;
- (NSString *)escape:(NSString *)string;

@end
