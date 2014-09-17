//
//  User+UserApi.h
//  Gaje
//
//  Created by hello on 14-8-28.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "User.h"
#import "MenuViewController.h"

@interface User (UserApi)

// fetching images by user_uuid
- (BOOL)fetchImageList:(NSMutableArray *)imageArray Parameters:(NSDictionary *)values Token:(NSString *)token;
- (BOOL)removeImage:(NSDictionary *)values Token:(NSString*)token;
- (BOOL)excludeImage:(NSDictionary *)values Token:(NSString*)token;

// follower & following
- (BOOL)addFollow:(NSDictionary *)values Token:(NSString*)token;
- (BOOL)removeFollow:(NSDictionary *)values Token:(NSString*)token;
- (BOOL)fetchFollowerList:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Token:(NSString *)token;
- (BOOL)fetchFollowingList:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Token:(NSString *)token;

// block this user
- (BOOL)addBlock:(NSDictionary *)values Token:(NSString*)token;

// search user ??
- (BOOL)search:(NSDictionary *)values ResultArray:(NSMutableArray *)userArray Token:(NSString *)token;

// notification
- (BOOL)getLatestUpdate:(NSDictionary *)updateDictionary;
- (BOOL)getNumberOfLatestUpdate;
- (BOOL)markItRead:(NSDictionary *)values;

@end
