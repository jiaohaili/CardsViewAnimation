//
//  ViewController.m
//  CardsViewAnimation
//
//  Created by LMSJ_iOS on 2018/8/6.
//  Copyright © 2018年 LMSJ_iOS. All rights reserved.
//

#import "ViewController.h"
#import "CardsAnimationView.h"

@interface ViewController ()

@property (nonatomic, strong) CardsAnimationView *cardsAnimationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cardsAnimationView];
}

- (CardsAnimationView *)cardsAnimationView {
    if (_cardsAnimationView == nil) {
        _cardsAnimationView = [[CardsAnimationView alloc] initWithFrame:CGRectMake(20, 100, self.view.width - 20 *2, self.view.height - 100 *2)];
        
    }
    return _cardsAnimationView;
}

@end
