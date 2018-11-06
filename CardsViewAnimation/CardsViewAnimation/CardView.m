//
//  CardView.m
//  CardAnimation
//
//  Created by jiaohaili on 2018/7/17.
//  Copyright © 2018年 jiao. All rights reserved.
//

#import "CardView.h"
@interface CardView()

@property (nonatomic, strong) UIImageView *cardImgView;

@end

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cardImgView];
        [self.cardImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"image_%d.png",arc4random() % 39]]];
        
    }
    return self;
}

- (void)updateImage {
    [self.cardImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"image_%d.png",arc4random() % 39]]];
}

- (UIImageView *)cardImgView {
    if (!_cardImgView) {
        _cardImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _cardImgView.backgroundColor = [UIColor yellowColor];
        _cardImgView.contentMode = UIViewContentModeScaleAspectFill;
        _cardImgView.clipsToBounds = YES;
        [_cardImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        // 保证图片随着cardView 的 frame 改变而改变
        _cardImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _cardImgView;
}

@end
