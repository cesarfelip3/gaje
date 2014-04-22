//
//  DataSource.h
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

+ (NSArray *)timeline;
+ (NSArray *)favorites;
+ (NSArray *)collections;

+ (NSDictionary *)userAccount;
+ (NSInteger)itemIsFavorite:(NSDictionary *)item;

+ (NSArray *)menu;

@end
