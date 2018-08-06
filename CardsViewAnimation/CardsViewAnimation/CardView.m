//
//  CardView.m
//  CardAnimation
//
//  Created by jiaohaili on 2018/7/17.
//  Copyright © 2018年 jiao. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arr = @[[UIColor redColor],
                         [UIColor yellowColor],
                         [UIColor cyanColor],
                         [UIColor orangeColor],
                         [UIColor brownColor],
                         [UIColor purpleColor],
                         [UIColor blueColor]];
        self.backgroundColor = arr[arc4random()% 6];
    }
    return self;
}

@end
