//
//  UIView+ZFAnimations.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UIView+ZFAnimations.h"

@implementation UIView (ZFAnimations)

+ (void)animationWithLayer:(CALayer *)layer {
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:@(0.8) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
    }];
}

@end
