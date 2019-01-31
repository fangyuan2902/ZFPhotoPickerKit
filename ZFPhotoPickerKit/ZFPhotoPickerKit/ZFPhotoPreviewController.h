//
//  ZFPhotoPreviewController.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class ZFAssetModel;
@interface ZFPhotoPreviewController : UICollectionViewController

/** 所有的图片资源 */
@property (nonatomic, copy)   NSArray<ZFAssetModel *> *assets;
/** 选择的图片资源 */
@property (nonatomic, strong) NSMutableArray<ZFAssetModel *> *selectedAssets;

/** 当用户更改了选择的图片,点击返回时,回调此block */
@property (nonatomic, copy)   void(^didPreviewFinishBlock)( NSArray<ZFAssetModel *> *selectedAssets);
/** 当前显示的asset index */
@property (nonatomic, assign) NSUInteger currentIndex;

+ (UICollectionViewLayout *)photoPreviewViewLayoutWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
