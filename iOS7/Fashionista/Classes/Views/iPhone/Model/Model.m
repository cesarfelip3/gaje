//
//  Model.m
//  Pixcell8
//
//  Created by  on 14-2-8.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "Model.h"

@implementation Model

- (id)init {
    
    self = [super init];
    if (self) {
        AppConfig *config = [AppConfig getInstance];
        self.db = [FMDatabase databaseWithPath:config.dbPath];
        
    }
    return self;
}

- (NSString *)escape:(NSString *)string
{
    
    if (string == nil || (NSNull *)string == [NSNull null] || string == NULL) {
        string = @"";
    }
    
    return string;
}

@end
