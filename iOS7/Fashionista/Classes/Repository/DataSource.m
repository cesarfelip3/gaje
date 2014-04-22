//
//  DataSource.m
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource


+ (NSArray *)timeline {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Timeline" ofType:@"plist"];
    return [[NSArray alloc] initWithContentsOfFile:path];
}

+ (NSArray *)favorites {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Personal-Account" ofType:@"plist"];
    NSDictionary *timeline =  [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return timeline[@"timeline"];
}

+ (NSArray *)collections {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Collections" ofType:@"plist"];
    return [[NSArray alloc] initWithContentsOfFile:path];
}

+ (NSDictionary *)userAccount {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"User-Account" ofType:@"plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}

+ (NSInteger)itemIsFavorite:(NSDictionary *)item {
    NSArray *favorites = [DataSource favorites];
    NSInteger position = -1;
    for (int idx = 0; idx < favorites.count;idx++) {
        NSDictionary *fav = favorites[idx];
        if ([fav[@"id"] integerValue] == [item[@"id"] integerValue]) {
            position = idx;
            break;
        }
    }
    return position;
}

+ (NSArray *)menu {
    return @[
             @{
                 @"title": @"FAVOURITES",
                 @"rows": @[
                            @{
                                @"title": @"Shops",
                                @"image": @"menu-icon1"
                                },
                            @{
                                @"title": @"Likes",
                                @"image": @"menu-icon2"
                                },
                            @{
                                @"title": @"Cart",
                                @"image": @"menu-icon3"
                                },
                            ]
                 },
             @{
                 @"title": @"SETTINGS",
                 @"rows": @[
                         @{
                             @"title": @"Account",
                             @"image": @"menu-icon4"
                             },
                         @{
                             @"title": @"Settings",
                             @"image": @"menu-icon5"
                             },
                         ]
                 }
             ];
}

@end
