//
//  YPDragCollectionView.h
//  YPDragCollectionView
//
//  Created by seek on 2018/9/27.
//  Copyright © 2018 seek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPDragCollectionView;

@protocol YPDragCollectionViewDataSource<NSObject>

@required

/**
 row

 @param dragCollectionView self
 @param section 段落
 @return row
 */
- (NSInteger)dragCollectionView:(YPDragCollectionView *)dragCollectionView numberOfItemsInSection:(NSInteger)section;

/**
 返回Cell

 @param dragCollectionView self
 @param indexPath indexPath
 @return cell
 */
- (UICollectionViewCell *)dragCollectionView:(YPDragCollectionView *)dragCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 段落数
 
 @param dragCollectionView self
 @return  段落数
 */
- (NSInteger)numberOfSectionsIndragCollectionView:(YPDragCollectionView *)dragCollectionView;

@end

@protocol YPDragCollectionViewDelegate<NSObject>

@optional

/**
 达到左边临界值 default:当前滑动Cell的size.width的一半

 @param dragCollectionView self
 @param indexPath idenxPath
 */
- (void)dragCollectionView:(YPDragCollectionView *)dragCollectionView willLeftDismissItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 达到右边临界值 default:当前滑动Cell的size.width的一半
 
 @param dragCollectionView self
 @param indexPath idenxPath
 */
- (void)dragCollectionView:(YPDragCollectionView *)dragCollectionView willRightDismissItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 已经左边消失
 
 @param dragCollectionView self
 @param indexPath idenxPath
 */
- (void)dragCollectionView:(YPDragCollectionView *)dragCollectionView didLeftDismissItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 已经右边消失
 
 @param dragCollectionView self
 @param indexPath idenxPath
 */
- (void)dragCollectionView:(YPDragCollectionView *)dragCollectionView didRightDismissItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 选中Cell
 
 @param dragCollectionView self
 @param indexPath idenxPath
 */
- (void)dragCollectionView:(YPDragCollectionView *)dragCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YPDragCollectionView : UIView

/**
 辅助CollectionView 注册Cell

 @param cellClass Class
 @param identity 标识
 */
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identity;

/**
 辅助CollectionView 获取复用池Cell

 @param identifier 标识
 @param indexPath indePath
 @return cell
 */
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/**
 辅助CollectionView 获取当前Cell

 @param indexPath indexPath
 @return cell
 */
- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;


/**
 刷新视图
 */
- (void)reloadData;

@property (nonatomic, weak)id<YPDragCollectionViewDataSource> dataSource;

@property (nonatomic, weak)id<YPDragCollectionViewDelegate> delegate;

@end
