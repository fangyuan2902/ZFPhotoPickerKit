//
//  ZFBottomBar.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFBottomBar.h"
#import "ZFAssetModel.h"
#import "ZFPhotoManager.h"
#import "UIView+ZFAnimations.h"

@interface ZFBottomBar ()

@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UILabel *numberLabel;

@end

@implementation ZFBottomBar

- (instancetype)initWithBarType:(ZFBottomBarType)barType {
    ZFBottomBar *bottomBar = [[ZFBottomBar alloc] init];
    bottomBar ? [bottomBar setupWithType:barType] : nil;
    return bottomBar;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        float width = [UIScreen mainScreen].bounds.size.width;
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.frame = CGRectMake(width - 70, 10, 50, 40);
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.confirmButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.confirmButton.enabled = NO;
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmButton setTitle:@"确定" forState:UIControlStateDisabled];
        [self.confirmButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0f] forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:.5f] forState:UIControlStateDisabled];
        [self.confirmButton addTarget:self action:@selector(_handleConfirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.confirmButton];
        
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberLabel.frame = CGRectMake(width - 100, 18, 24, 24);
        self.numberLabel.backgroundColor = [UIColor greenColor];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.font = [UIFont systemFontOfSize:14];
        self.numberLabel.layer.masksToBounds = YES;
        self.numberLabel.layer.cornerRadius = 12;
        [self addSubview:self.numberLabel];
        self.numberLabel.hidden = YES;
    }
    return self;
}

#pragma mark - Methods


- (void)updateBottomBarWithAssets:(NSArray *)assets {
    
    self.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)assets.count];
    
    self.numberLabel.hidden = (assets.count <= 0);
    self.confirmButton.enabled = (assets.count >= 1);
}

- (void)setupWithType:(ZFBottomBarType)barType {
    _barType = barType;
    
    self.backgroundColor = barType == ZFPreviewBottomBar ? [UIColor colorWithRed:34/255.0f green:34/255.0f blue:34/255.0f alpha:.7f] : [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0 alpha:1.0f];
}

- (void)_handleConfirmAction {
    self.confirmBlock ? self.confirmBlock() : nil;
}

@end
