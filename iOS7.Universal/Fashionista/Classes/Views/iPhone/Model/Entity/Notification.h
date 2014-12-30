//
//  Notification.h
//  Gaje
//
//  Created by hello on 14-12-30.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Model.h"
#import "Global.h"
#import "AFNetworking.h"
#import "NetworkCallbackDelegate.h"

@interface Notification : Model

@property (atomic, assign) NSInteger *notificationId;
@property (atomic, retain) NSString *notificationUUID;
@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *desc;
@property (atomic, assign) BOOL selected;

@property (atomic, assign) NSString *errorMessage;

@property (atomic, retain) NSString *delegateType;
@property (atomic, retain) id<NetworkCallbackDelegate> delegate;

+ (id)getInstance;
- (BOOL)fetchList:(NSMutableArray *)notificationArray Token:(NSString *)token;

@end
