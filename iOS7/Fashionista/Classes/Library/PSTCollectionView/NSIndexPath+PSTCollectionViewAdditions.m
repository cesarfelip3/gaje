//
//  NSIndexPath+PSTCollectionViewAdditions.m
//  PSTCollectionView
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "NSIndexPath+PSTCollectionViewAdditions.h"


@implementation NSIndexPath (PSTCollectionViewAdditions)

#if false

//__IPHONE_OS_VERSION_MIN_REQUIRED < 60000 AND false

// Simple NSIndexPath addition to allow using "item" instead of "row".
+ (NSIndexPath *)indexPathForItem:(NSInteger)item inSection:(NSInteger)section {
    return [NSIndexPath indexPathForRow:item inSection:section];
}

- (NSInteger)item {
    return self.row;
}

#endif

@end
