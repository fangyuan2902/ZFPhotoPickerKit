//
//  ZFBottomBar.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZFBottomBarType) {
    ZFCollectionBottomBar,
    ZFPreviewBottomBar,
};

@interface ZFBottomBar: UIView

@property (nonatomic, assign, readonly) ZFBottomBarType barType;
@property (nonatomic, copy)   void(^confirmBlock)(void);


- (instancetype)initWithBarType:(ZFBottomBarType)barType;

- (void)updateBottomBarWithAssets:(NSArray *)assets;

@end

NS_ASSUME_NONNULL_END
