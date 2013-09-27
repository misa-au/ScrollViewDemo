//
//  SDViewController.m
//  ScrollViewDemo
//
//  Created by Misa Sakamoto on 2013-09-26.
//
//

#import "SDViewController.h"
#import "SDScrollingCell.h"

@interface SDViewController ()
<UIScrollViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
SDScrollingCellDelegate>

@end

@implementation SDViewController


#pragma mark - Overridden Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    self.outerScrollView.contentSize = CGSizeMake(640, 0.f);
    self.outerScrollView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIScrollViewDelegate Methods



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDScrollingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"scrollingCell" forIndexPath: indexPath];
    
    cell.delegate = self;
    
    cell.color = [UIColor colorWithRed: arc4random() % 11 * 0.1 green: arc4random() % 11 * 0.1 blue: arc4random() % 11 * 0.1 alpha: 1.f];
    return cell;
}


#pragma mark - SDScrollingCellDelegate Methods

- (void)scrollingCellDidBeginPulling: (SDScrollingCell *)cell
{
    [_outerScrollView setScrollEnabled: NO];
}

- (void)scrollingCell: (SDScrollingCell *)cell
    didChangePullOffset: (CGFloat)offset
{
    [_outerScrollView setContentOffset: CGPointMake(offset, 0.f)];
}

- (void)scrollingCellDidEndPulling: (SDScrollingCell *)cell
{
    [_outerScrollView setScrollEnabled: YES];
}

@end
