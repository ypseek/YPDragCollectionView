//
//  ViewController.m
//  YPDragCollectionView
//
//  Created by seek on 2018/9/27.
//  Copyright © 2018 seek. All rights reserved.
//

#import "ViewController.h"
#import "YPDragCollectionView.h"
#import "YPDragCollectionViewCell.h"

@interface ViewController ()<YPDragCollectionViewDelegate,YPDragCollectionViewDataSource>

@property (nonatomic, strong)NSMutableArray *data;

@property (nonatomic, strong)YPDragCollectionView *dragView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.dragView];
    
    for (int i = 1; i <= 15; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i%10 + 1]];
        [self.data addObject:img];
    }
}


#pragma mark - YPDragCollectionViewDataSource
- (UICollectionViewCell *)dragCollectionView:(YPDragCollectionView *)dragCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YPDragCollectionViewCell *cell = (YPDragCollectionViewCell *)[dragCollectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.img = _data[indexPath.row];
    return cell;
}

- (NSInteger)dragCollectionView:(YPDragCollectionView *)dragCollectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

#pragma mark - YPDragCollectionViewDelegate
- (void)dragCollectionView:(YPDragCollectionView *)dragCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击");
}

- (void)dragCollectionView:(YPDragCollectionView *)dragCollectionView didRightDismissItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"push");
}

- (void)dragCollectionView:(YPDragCollectionView *)dragCollectionView didLeftDismissItemAtIndexPath:(NSIndexPath *)indexPath {
    [_data removeObjectAtIndex:indexPath.row];
    [dragCollectionView reloadData];
}

- (YPDragCollectionView *)dragView{
    if (!_dragView) {
        _dragView = [[YPDragCollectionView alloc]initWithFrame:self.view.bounds];
        _dragView.dataSource = self;
        _dragView.delegate = self;
        [_dragView registerClass:[YPDragCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return _dragView;
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
