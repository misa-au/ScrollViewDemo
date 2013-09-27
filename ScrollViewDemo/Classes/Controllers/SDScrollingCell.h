//
//  SDScrollingCell.h
//  ScrollViewDemo
//
//  Created by Misa Sakamoto on 2013-09-26.
//
//

#import <UIKit/UIKit.h>

static NSString * const SDScrollingCellIdentifier = @"SDScrollingCellIdentifier";

@protocol SDScrollingCellDelegate;

@interface SDScrollingCell : UICollectionViewCell

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, weak) id<SDScrollingCellDelegate> delegate;

@end

@protocol SDScrollingCellDelegate <NSObject>

- (void)scrollingCellDidBeginPulling: (SDScrollingCell *)cell;
- (void)scrollingCell: (SDScrollingCell *)cell
    didChangePullOffset: (CGFloat)offset;
- (void)scrollingCellDidEndPulling: (SDScrollingCell *)cell;

@end