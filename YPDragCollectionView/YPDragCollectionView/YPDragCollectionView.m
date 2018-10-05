//
//  YPDragCollectionView.m
//  YPDragCollectionView
//
//  Created by seek on 2018/9/27.
//  Copyright © 2018 seek. All rights reserved.
//

#import "YPDragCollectionView.h"


@interface YPDragCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

//开始滑动位置
@property (nonatomic, assign) CGPoint pointStart;
//记录变化状态的位置
@property (nonatomic, assign) CGPoint pointChange;

@end

@implementation YPDragCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataSource dragCollectionView:self numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfSectionsIndragCollectionView:)]) {
        return [_dataSource numberOfSectionsIndragCollectionView:self];
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [_dataSource dragCollectionView:self cellForItemAtIndexPath:indexPath];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [cell addGestureRecognizer:pan];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(dragCollectionView:didSelectItemAtIndexPath:)]) {
        [_delegate dragCollectionView:self didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - pan手势
- (void)panAction:(UIPanGestureRecognizer *)pan{
    
    UICollectionViewCell * currentCell = (UICollectionViewCell *)pan.view;
    
    [_collectionView bringSubviewToFront:currentCell];
    
    NSIndexPath * indexPath = [_collectionView indexPathForCell:currentCell];
    //获取当前Cell的描述
    UICollectionViewLayoutAttributes * attribute = [_collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            //记录当前开始滑动的point
            _pointStart = [pan locationInView:self];
            _pointChange = _pointStart;
            break;
            
        case UIGestureRecognizerStateChanged:{
            //当前的位置
            CGPoint currentPoint = [pan locationInView:self];
            
            CGFloat movX = currentPoint.x - _pointChange.x;
            CGFloat movY = currentPoint.y - _pointChange.y;
            
            currentCell.center = CGPointMake(currentCell.center.x + movX, currentCell.center.y + movY);
            
            _pointChange = currentPoint;
            
            currentCell.transform = CGAffineTransformMakeRotation((_pointChange.x - attribute.center.x)/360);
            
            if (currentCell.center.x > attribute.center.x + attribute.frame.size.width/2) {
                if (_delegate && [_delegate respondsToSelector:@selector(dragCollectionView:willRightDismissItemAtIndexPath:)]) {
                    [_delegate dragCollectionView:self willRightDismissItemAtIndexPath:indexPath];
                }
            }else if (currentCell.center.x < attribute.center.x - attribute.frame.size.width/2) {
                if (_delegate && [_delegate respondsToSelector:@selector(dragCollectionView:willLeftDismissItemAtIndexPath:)]) {
                    [_delegate dragCollectionView:self willLeftDismissItemAtIndexPath:indexPath];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (currentCell.center.x > attribute.center.x + attribute.frame.size.width/2) {
                //右边消失
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:0 animations:^{
                    currentCell.center = attribute.center;
                    currentCell.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
                if (_delegate && [_delegate respondsToSelector:@selector(dragCollectionView:didRightDismissItemAtIndexPath:)]) {
                    [_delegate dragCollectionView:self didRightDismissItemAtIndexPath:indexPath];
                }
            }else if (currentCell.center.x < attribute.center.x - attribute.frame.size.width/2) {
                currentCell.center = attribute.center;
                currentCell.transform = CGAffineTransformIdentity;
                if (_delegate && [_delegate respondsToSelector:@selector(dragCollectionView:didLeftDismissItemAtIndexPath:)]) {
                    [_delegate dragCollectionView:self didLeftDismissItemAtIndexPath:indexPath];
                }
            }else {
                //恢复
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:0 animations:^{
                    currentCell.center = attribute.center;
                    currentCell.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }
            break;
        default:
            break;
    }
}


#pragma mark - public method

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identity{
    [self.collectionView registerClass:[cellClass class] forCellWithReuseIdentifier:identity];
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - 解决手势冲突问题

/*
  y轴方向  拖动距离超过 一定的数值 响应UICollectionView的拖动
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = gestureRecognizer.view;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint offset = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:view];
        if (offset.y > 4 || offset.y < -4) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - lazy

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-15*2-10)/2, ([UIScreen mainScreen].bounds.size.width-15*2-10)/2);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];        
    }
    return _collectionView;
}

@end
