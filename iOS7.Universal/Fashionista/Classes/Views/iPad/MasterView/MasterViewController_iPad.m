//
//  DetailViewController.m
//  
//
//  Created by Valentin Filip on 11/7/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "MasterViewController_iPad.h"

#import "ADVTheme.h"

#import "DataSource.h"
#import "ItemCollectionCell.h"


@interface MasterViewController_iPad () {
    NSInteger columnsCount;
    NSInteger rowsCount;
}

@property (strong, nonatomic) NSArray *collectionItems;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;


@end

@implementation MasterViewController_iPad

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [ADVThemeManager customizeView:self.view];
    UIImageView *titleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
    self.navigationItem.titleView = titleImageV;
    
    self.headerView.delegate = self;
    self.headerView.dataSource = self;
    self.headerView.type = iCarouselTypeCoverFlow2;
    self.headerView.autoresizesSubviews = YES;
    
    _coverflowBkg.image = [[UIImage imageNamed:@"coverflow-background"] stretchableImageWithLeftCapWidth:150 topCapHeight:0];

    _headerView.backgroundColor = [UIColor clearColor];
    
    self.items = [DataSource collections];

    [self.headerView reloadData];
    [self.headerView scrollToItemAtIndex:1 animated:NO];
}

- (void)viewDidUnload {
    [self setCollectionView:nil];
    [self setCoverflowBkg:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)arrangeCollectionView {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    } else {
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }
    self.collectionView.collectionViewLayout = flowLayout;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self arrangeCollectionView];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self arrangeCollectionView];
}


#pragma mark - iCarousel datasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 435.0f, 257.0f)];
        view.contentMode = UIViewContentModeTop;
    }
    
    NSDictionary *item = _items[index];
    ((UIImageView *)view).image = [UIImage imageNamed:item[@"image"]];
    
    return view;
}


#pragma mark - iCarousel delegate

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    NSArray *newItems = self.items[self.headerView.currentItemIndex][@"items"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"id"
                                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    self.collectionItems = [newItems sortedArrayUsingDescriptors:sortDescriptors];
    
    [self.collectionView reloadData];
}


#pragma mark -
#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.collectionItems count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ItemCollectionCell";
    
    ItemCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *item = self.collectionItems[indexPath.row];
    
    cell.data = item;
    [cell setNeedsLayout];
    
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {    
    CGSize sizeCell = [ItemCollectionCell sizeForCellWithData:self.collectionItems[indexPath.row]];
    
    CGFloat availableHeight = collectionView.frame.size.height-14;
    if (sizeCell.height > availableHeight) {
        sizeCell.height = availableHeight;
    }
    
    return sizeCell;
}


@end
