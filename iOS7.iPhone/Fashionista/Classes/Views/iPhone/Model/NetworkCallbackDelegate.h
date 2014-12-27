//
//  NetworkCallbackDelegate.h
//  Pixcell8
//
//  Created by hello on 14-3-18.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkCallbackDelegate <NSObject>

@required

- (BOOL)onCallback:(NSInteger)type;

@end