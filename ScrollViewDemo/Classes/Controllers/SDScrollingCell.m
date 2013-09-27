//
//  SDScrollingCell.m
//  ScrollViewDemo
//
//  Created by Misa Sakamoto on 2013-09-26.
//
//

#import "SDScrollingCell.h"

#pragma mark - Constants

#define PULL_THRESHOLD 60.f


#pragma mark - Class Interface

@interface SDScrollingCell () <UIScrollViewDelegate>
{
    @private __strong UIScrollView *_scrollView;
    @private __strong UIView *_colorView;
    
    @private BOOL _pulling;
    
    // used to track deceleration so that outer scrollview can decelerate at same rate
    @private BOOL _decceleratingBackToZero;
    CGFloat _decelerationDistanceRatio;
}

@end


#pragma mark - Class Implementation

@implementation SDScrollingCell


#pragma mark - Constructor

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _colorView = [[UIView alloc]
            init];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.contentView addSubview: _scrollView];
        [_scrollView addSubview: _colorView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder: aDecoder])
    {
        _colorView = [[UIView alloc]
            init];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.contentView addSubview: _scrollView];
        [_scrollView addSubview: _colorView];
    }
    return self;
}


#pragma mark - Properties

- (void)setColor: (UIColor *)color
{
    _color = color;
    _colorView.backgroundColor = color;
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    
    // check if user started pulling
    if (offset > PULL_THRESHOLD
        && _pulling == NO)
    {
        [_delegate scrollingCellDidBeginPulling: self];
        _pulling = YES;
    }
    
    if (_pulling == YES)
    {
        // determine delta beyond catch point
        CGFloat pullOffset = MAX(0, offset - PULL_THRESHOLD);
        
        // adjust parent content offset by delta
        if (_decceleratingBackToZero == YES)
        {
            pullOffset = offset * _decceleratingBackToZero;
        }
        else
        {
            pullOffset = MAX(0.f, offset - PULL_THRESHOLD);
        }
        [_delegate scrollingCell: self
            didChangePullOffset: pullOffset];

        
        // translate child by delta
        _scrollView.transform = CGAffineTransformMakeTranslation(pullOffset, 0.f);
    }
}

- (void)scrollViewDidEndDragging: (UIScrollView *)scrollView
    willDecelerate: (BOOL)decelerate
{
    if (decelerate == NO)
    {
        [self SD_scrollingEnded];
    }
}

- (void)scrollViewDidEndDecelerating: (UIScrollView *)scrollView
{
    [self SD_scrollingEnded];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offset = _scrollView.contentOffset.x;
    
    if (targetContentOffset->x == 0 && offset > 0)
    {
        _decceleratingBackToZero = YES;
        
        // figure out ratio of the distances that are being scrolled
        CGFloat pullOffset = MAX(0.f, offset - PULL_THRESHOLD);
        _decelerationDistanceRatio = pullOffset / offset;
    }
}


#pragma mark - Overridden Methods

- (void)layoutSubviews
{
    UIView *contentView = self.contentView;
    CGRect bounds = contentView.bounds;
    
    CGFloat pageWidth = bounds.size.width + PULL_THRESHOLD;
    _scrollView.frame = CGRectMake(0.f, 0.f, pageWidth, bounds.size.height);
    _scrollView.contentSize = CGSizeMake(pageWidth * 2, bounds.size.height);
    
    _colorView.frame = [_scrollView convertRect: bounds fromView: contentView];
}


#pragma mark - Private Methods

- (void)SD_scrollingEnded
{
    [_delegate scrollingCellDidEndPulling: self];
    _pulling = NO;
    
    // set content offset back to zero so that scrollview isn't scrolled off
    _scrollView.contentOffset = CGPointZero;
    
    // set transform state back to identitity
    _scrollView.transform = CGAffineTransformIdentity;
}

@end
