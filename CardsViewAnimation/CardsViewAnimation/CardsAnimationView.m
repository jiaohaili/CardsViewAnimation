//
//  CardsAnimationView.m
//  CardAnimation
//
//  Created by jiaohaili on 2018/7/17.
//  Copyright © 2018年 jiao. All rights reserved.
//

#import "CardsAnimationView.h"
#import "CardView.h"

static CGFloat const kCardsViewIntervalWidth = 12;
static CGFloat const kCardsViewIntervalHeight = 16;

@interface CardsAnimationView()

@property (nonatomic, strong) CardView *firstCardView;
@property (nonatomic, strong) CardView *secondCardView;

@property (nonatomic, strong) CardView *currentFirstCardView;
@property (nonatomic, strong) CardView *currentSecondCardView;

@property (nonatomic, assign) CGPoint toucheUpPoint;
@property (nonatomic, assign) CGFloat distenceX;

@end

@implementation CardsAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.secondCardView];
        [self addSubview:self.firstCardView];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideCardViewGesture:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark - touch方法
- (void)slideCardViewGesture:(UIPanGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:self];
    CGPoint velocity = [sender velocityInView:self];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.toucheUpPoint = touchPoint;
        self.distenceX = 0;
        self.currentFirstCardView = [self getCurrentFirstCardView];
        self.currentSecondCardView = [self getCurrentSecondCardView];
    }
    CGFloat percent = [self percentWithCurrent];
    CGRect firstFrame = [self firstCardViewFrame];
    CGRect secondFrame = [self secondCardViewFrame];
    
    CGFloat currentDirection = 0;
    if (velocity.x > 0) {
        currentDirection = 1;
    } else {
        currentDirection = -1;
    }
    
    CGFloat distenceX;
    if (self.toucheUpPoint.x > touchPoint.x) {
        distenceX = self.toucheUpPoint.x - touchPoint.x;
    } else {
        distenceX = touchPoint.x - self.toucheUpPoint.x;
    }
    
    CGFloat angle = percent * M_PI/7;

    // 第一个卡牌 随手势移动距离改变位移和旋转
    if (velocity.x > 0) {
        CGAffineTransform locationTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, self.distenceX + distenceX, 0);
        CGAffineTransform rotateTransform = CGAffineTransformRotate(locationTransform, angle);
        self.currentFirstCardView.transform = rotateTransform;
        self.distenceX = self.distenceX + distenceX;
        
    } else {
        CGAffineTransform locationTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, self.distenceX - distenceX, 0);
        CGAffineTransform rotateTransform = CGAffineTransformRotate(locationTransform, angle);
        self.currentFirstCardView.transform = rotateTransform;
        self.distenceX = self.distenceX - distenceX;
    }

    CGFloat xx1 = firstFrame.origin.x - secondFrame.origin.x;
    CGFloat yy1 = firstFrame.origin.y - secondFrame.origin.y;
    CGFloat width1 = firstFrame.size.width - secondFrame.size.width;
    CGFloat height1 = firstFrame.size.height - secondFrame.size.height;
    CGFloat scalePercent = fabs(percent);
    // 第二个卡牌动画
    self.currentSecondCardView.frame = CGRectMake(secondFrame.origin.x + (xx1 * scalePercent),
                                          secondFrame.origin.y + (yy1 * scalePercent),
                                          secondFrame.size.width + (width1 * scalePercent),
                                          secondFrame.size.height + (height1 * scalePercent));

    self.toucheUpPoint = touchPoint;
    
    //手势结束
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        //right
        if (velocity.x >= 50 || velocity.x < -50) {
            [self animationViewWithDirection:currentDirection cardAngle:angle timer:0.3];
        } else {
            [self animationViewWithDirection:0 cardAngle:angle timer:0.2];
        }
    }
}


- (CGFloat)percentWithCurrent {
    CGFloat percent = self.distenceX/SCREEN_WIDTH;
    if (percent >= 1) {
        percent = 1;
    }
    return percent;
}


- (void)animationViewWithDirection:(CGFloat)currentDirection cardAngle:(CGFloat)angle timer:(NSTimeInterval)time {
    
    [UIView animateWithDuration:time animations:^{
        if (currentDirection == 0) {
            self.currentFirstCardView.transform = CGAffineTransformIdentity;
            self.currentFirstCardView.frame = [self firstCardViewFrame];
            self.currentSecondCardView.frame = [self secondCardViewFrame];
        } else {
            self.currentSecondCardView.frame = [self firstCardViewFrame];
            self.currentFirstCardView.center = CGPointMake(self.currentFirstCardView.center.x + currentDirection * SCREEN_WIDTH, self.secondCardView.center.y);
        }
    } completion:^(BOOL finished) {
        if (currentDirection != 0) {
            [self sendSubviewToBack:self.currentFirstCardView];
            self.currentFirstCardView.hidden = YES;
            self.currentFirstCardView.transform = CGAffineTransformIdentity;
            
            self.currentFirstCardView.frame = [self secondCardViewFrame];
            self.currentFirstCardView.hidden = NO;
            self.currentFirstCardView.isFront = NO;
            self.currentSecondCardView.isFront = YES;
        } else {
        }
    }];
}

- (CardView *)getCurrentFirstCardView {
    if (self.firstCardView.isFront == YES) {
        return self.firstCardView;
    } else if (self.secondCardView.isFront == YES) {
        return self.secondCardView;
    } else {
        return self.firstCardView;
    }
}

- (CardView *)getCurrentSecondCardView {
    if (self.firstCardView.isFront == NO) {
        return self.firstCardView;
    } else if (self.secondCardView.isFront == NO) {
        return self.secondCardView;
    } else {
        return self.firstCardView;
    }
}


- (CGRect)firstCardViewFrame {
    return self.bounds;
}

- (CGRect)secondCardViewFrame {
    return CGRectMake(kCardsViewIntervalWidth, kCardsViewIntervalHeight, self.width - kCardsViewIntervalWidth *2, self.height - kCardsViewIntervalHeight *2);
}

- (CardView *)firstCardView
{
    if (_firstCardView == nil) {
        _firstCardView = [[CardView alloc] initWithFrame:[self firstCardViewFrame]];
        _firstCardView.layer.shouldRasterize = YES;
        _firstCardView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        _firstCardView.autoresizesSubviews = YES;
        _firstCardView.tag = 3000;
        _firstCardView.isFront = YES;
    }
    return _firstCardView;
}

- (CardView *)secondCardView
{
    if (_secondCardView == nil) {
        _secondCardView = [[CardView alloc] initWithFrame:[self secondCardViewFrame]];
        _secondCardView.layer.shouldRasterize = YES;
        _secondCardView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        _secondCardView.autoresizesSubviews = YES;
        _secondCardView.tag = 3001;
        _secondCardView.isFront = NO;
    }
    return _secondCardView;
}

@end


