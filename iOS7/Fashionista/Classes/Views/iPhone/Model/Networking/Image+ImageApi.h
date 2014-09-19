//
//  Image+ImageApi.h
//  Gaje
//
//  Created by hello on 14-9-7.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Image.h"
#import "FSNConnection.h"

@interface Image (ImageApi)


// methods

- (BOOL)fetchLatest:(NSMutableArray *)imageArray Token:(NSString *)token;
- (BOOL)upload:(NSDictionary *)values ProgressBar:(UIProgressView *)progressBar;

- (BOOL)addComment:(NSDictionary *)values Token:(NSString*)token;
- (BOOL)fetchCommentList:(NSMutableArray *)commentArray Token:(NSString *)token;

- (BOOL)addBrander:(NSDictionary *)values Token:(NSString*)token;
- (BOOL)fetchBranderList:(NSMutableArray *)branderArray Token:(NSString *)token;


@end
