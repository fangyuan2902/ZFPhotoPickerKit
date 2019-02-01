//
//  ZFPhotoPreviewCell.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZFAssetModel;
@interface ZFPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, copy)   void(^singleTapBlock)(void); 

- (void)configCellWithItem:(ZFAssetModel *)item;

- (void)pausePlayer;

@end

NS_ASSUME_NONNULL_END
