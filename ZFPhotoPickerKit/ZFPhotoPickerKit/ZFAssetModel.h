//
//  ZFAssetModel.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFAssetModel : NSObject

@property (nonatomic, strong, readonly) PHAsset *asset;
@property (nonatomic, assign) BOOL selected;//是否被选中  默认NO

@property (nonatomic, strong, readonly) UIImage *originImage;//获取照片asset对应的原图
@property (nonatomic, strong, readonly) UIImage *thumbnail;//获取照片asset对应的缩略图
@property (nonatomic, strong, readonly) UIImage *previewImage;//获取照片asset的预览图
@property (nonatomic, assign, readonly) UIImageOrientation imageOrientation;//获取照片的方向

@property (nonatomic, copy,   readonly) NSString *timeLength;//asset为Video时 video的时长
- (void)playerItemCompletionBlock:(void (^)(AVPlayerItem *, NSDictionary *))completionBlock;//视频的播放item

/**
 *  根据asset,type获取ZFAssetModel实例
 *
 *  @param asset 具体的Asset类型 PHAsset
 *
 *  @return ZFAssetModel实例
 */
+ ( ZFAssetModel *)modelWithAsset:(PHAsset *)asset;

/**
 *  根据asset,type,timeLength获取ZFAssetModel实例
 *
 *  @param asset      asset 非空
 *  @param timeLength video时长
 *
 *  @return ZFAssetModel实例
 */
+ ( ZFAssetModel *)modelWithAsset:(PHAsset *)asset timeLength:(NSString *)timeLength;

@end

NS_ASSUME_NONNULL_END
