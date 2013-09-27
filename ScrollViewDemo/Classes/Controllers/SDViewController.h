//
//  SDViewController.h
//  ScrollViewDemo
//
//  Created by Misa Sakamoto on 2013-09-26.
//
//

#import <UIKit/UIKit.h>

@interface SDViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *outerScrollView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end
