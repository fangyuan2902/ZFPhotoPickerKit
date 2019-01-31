//
//  ZFAssetCell.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZFAssetModel;
@interface ZFAssetCell : UICollectionViewCell

@property (nonatomic, copy)   BOOL(^willChangeSelectedStateBlock)(UIButton *button);

@property (nonatomic, copy)   void(^didChangeSelectedStateBlock)(BOOL selected, ZFAssetModel *asset);

@property (nonatomic, strong, readonly) ZFAssetModel *asset;


- (void)configCellWithItem:(ZFAssetModel *)item;

@end

NS_ASSUME_NONNULL_END
