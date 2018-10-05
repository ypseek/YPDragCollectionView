//
//  YPDragCollectionViewCell.m
//  YPDragCollectionView
//
//  Created by seek on 2018/9/27.
//  Copyright © 2018 seek. All rights reserved.
//

#import "YPDragCollectionViewCell.h"

@implementation YPDragCollectionViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self.contentView addSubview:self.imgView];
        
        self.imgView.autoresizesSubviews = YES;
        self.imgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
        
        self.imgView.autoresizesSubviews = YES;
        self.imgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
    }
    return self;
}


- (void)setImg:(UIImage *)img {
    _img  = img;
    self.imgView.image = img;
}


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imgView.userInteractionEnabled = YES;
        _imgView.backgroundColor = [UIColor yellowColor];
    }
    return _imgView;
}

@end
