//
//  YPDragCollectionViewCell.h
//  YPDragCollectionView
//
//  Created by seek on 2018/9/27.
//  Copyright © 2018 seek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPDragCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIImageView *imgView;

@property (nonatomic,strong)UIImage *img;

@end
