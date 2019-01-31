//
//  ZFPhotoManager.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "ZFPhotoPickerDefine.h"
#import "ZFAlbumModel.h"
#import "ZFAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFPhotoManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - Methods

/**
 *  判断用户是否打开了图片授权
 *
 *  @return YES or NO
 */
- (BOOL)hasAuthorized;

/// ========================================
/// @name   获取Album相册相关方法
/// ========================================

/**
 *  获取所有的相册
 *
 *  @param pickingVideoEnable 是否允许选择视频
 *  @param completionBlock    回调block
 */
- (void)getAlbumsPickingVideoEnable:(BOOL)pickingVideoEnable completionBlock:(void(^)(NSArray<ZFAlbumModel *> *albums))completionBlock;

/**
 *  获取相册中的所有图片,视频
 *
 *  @param result             对应相册  PHFetchResult or ALAssetsGroup<ALAsset>
 *  @param pickingVideoEnable 是否允许选择视频
 *  @param completionBlock    回调block
 */
- (void)getAssetsFromResult:(id)result pickingVideoEnable:(BOOL)pickingVideoEnable completionBlock:(void(^)(NSArray<ZFAssetModel *> * assets))completionBlock;

/// ========================================
/// @name   获取Asset对应信息相关方法
/// ========================================

- (void)getOriginImageWithAsset:(PHAsset *)asset completionBlock:(void(^)(UIImage *image))completionBlock;
- (void)getThumbnailWithAsset:(PHAsset *)asset size:(CGSize)size completionBlock:(void(^)(UIImage *image))completionBlock;
- (void)getPreviewImageWithAsset:(PHAsset *)asset completionBlock:(void(^)(UIImage *image))completionBlock;
- (void)getImageOrientationWithAsset:(PHAsset *)asset completionBlock:(void(^)(UIImageOrientation imageOrientation))completionBlock;
- (void)getAssetSizeWithAsset:(PHAsset *)asset completionBlock:(void(^)(CGFloat size))completionBlock;
- (void)getVideoInfoWithAsset:(PHAsset *)asset completionBlock:(void(^)(AVPlayerItem *playerItem,NSDictionary *playetItemInfo))completionBlock;

@end

NS_ASSUME_NONNULL_END
