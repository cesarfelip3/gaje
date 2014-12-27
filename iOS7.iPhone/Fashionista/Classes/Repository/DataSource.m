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

+ (NSMutableDictionary *)userAccount {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"User-Account" ofType:@"plist"];
    return [[NSMutableDictionary alloc] initWithContentsOfFile:path];
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
                 @"title": @"",
                 @"rows": @[
                            @{
                                @"title": @"Board",
                                @"image": @"" //@"menu-icon1"
                                },
                            @{
                                @"title": @"Theme",
                                @"image": @"" //@"menu-icon2"
                                },
                            @{
                                @"title": @"Settings",
                                @"image": @"" //@"menu-icon5"
                                },
                            @{
                                @"title": @"Notes",
                                @"image": @"" //@"menu-icon5"
                                }

                            ]
                 },
             @{
                 @"title": @"",
                 @"rows": @[
                         @{
                             @"title": @"Profile",
                             @"image": @"" //@"menu-icon4"
                             },
                        @{
                             @"title": @"Top Brands",
                             @"image": @"" //@"menu-icon5"
                             },
                         @{
                             @"title": @"Tracks",
                             @"image": @"" //@"menu-icon3"
                             },
                         @{
                             @"title": @"Tracking",
                             @"image": @"" //@"menu-icon3"
                             },
                         @{
                             @"title": @"Notification",
                             @"image": @"" //@"menu-icon3"
                             },

                         ]
                 }
             ];
}

@end
