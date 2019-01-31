//
//  ZFAssetModel.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFAssetModel.h"
#import "ZFPhotoPickerDefine.h"
#import "ZFPhotoManager.h"

@interface ZFAssetModel ()

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) UIImage *originImage;//获取照片asset对应的原图
@property (nonatomic, strong) UIImage *thumbnail;//获取照片asset对应的缩略图
@property (nonatomic, strong) UIImage *previewImage;//获取照片asset的预览图
@property (nonatomic, assign) UIImageOrientation imageOrientation;//获取照片的方向

@property (nonatomic, copy)   NSString *timeLength;//asset为Video时 video的时长
@property (nonatomic, strong) AVPlayerItem *playerItem;//视频的播放item
@property (nonatomic, copy)   NSDictionary *playerItemInfo;//视频播放item的信息

@end

@implementation ZFAssetModel

/**
 *  根据asset,type获取ZFAssetModel实例
 *
 *  @param asset 具体的Asset类型 PHAsset
 *
 *  @return ZFAssetModel实例
 */
+ ( ZFAssetModel *)modelWithAsset:(PHAsset *)asset {
    NSString *duration = [self getDuration:(PHAsset *)asset];
    NSLog(@"duration======%@",duration);
    return [self modelWithAsset:asset timeLength:duration];
}

+ (NSString *)getDuration:(PHAsset *)asset {
    if (asset.mediaType != PHAssetMediaTypeVideo) return @"";
    NSInteger duration = (NSInteger)round(asset.duration);
    if (duration < 60) {
        return [NSString stringWithFormat:@"00:%02ld", duration];
    } else if (duration < 3600) {
        NSInteger m = duration / 60;
        NSInteger s = duration % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld", m, s];
    } else {
        return @"";
    }
}

/**
 *  根据asset,type,timeLength获取ZFAssetModel实例
 *
 *  @param asset      asset 非空
 *  @param timeLength video时长
 *
 *  @return ZFAssetModel实例
 */
+ ( ZFAssetModel *)modelWithAsset:(PHAsset *)asset timeLength:(NSString *)timeLength {
    ZFAssetModel *model = [[ZFAssetModel alloc] init];
    model.asset = asset;
    model.timeLength = timeLength;
    return model;
}

#pragma mark - Getters

- (UIImage *)originImage {
    if (_originImage) {
        return _originImage;
    }
    __block UIImage *resultImage;
    [[ZFPhotoManager sharedManager] getOriginImageWithAsset:self.asset completionBlock:^(UIImage *image){
        resultImage = image;
    }];
    _originImage = resultImage;
    return resultImage;
}

- (UIImage *)thumbnail {
    if (_thumbnail) {
        return _thumbnail;
    }
    __block UIImage *resultImage;
    [[ZFPhotoManager sharedManager] getThumbnailWithAsset:self.asset size:kThumbnailSize completionBlock:^(UIImage *image){
        resultImage = image;
    }];
    _thumbnail = resultImage;
    return _thumbnail;
}

- (UIImage *)previewImage {
    if (_previewImage) {
        return _previewImage;
    }
    __block UIImage *resultImage;
    [[ZFPhotoManager sharedManager] getPreviewImageWithAsset:self.asset completionBlock:^(UIImage *image) {
        resultImage = image;
    }];
    _previewImage = resultImage;
    return _previewImage;
}

- (UIImageOrientation)imageOrientation {
    if (_imageOrientation) {
        return _imageOrientation;
    }
    __block UIImageOrientation resultOrientation;
    [[ZFPhotoManager sharedManager] getImageOrientationWithAsset:self.asset completionBlock:^(UIImageOrientation imageOrientation) {
        resultOrientation = imageOrientation;
    }];
    _imageOrientation = resultOrientation;
    return _imageOrientation;
}

- (AVPlayerItem *)playerItem {
    if (_playerItem) {
        return _playerItem;
    }
    __block AVPlayerItem *resultItem;
    __block NSDictionary *resultItemInfo;
    [[ZFPhotoManager sharedManager] getVideoInfoWithAsset:self.asset completionBlock:^(AVPlayerItem *playerItem, NSDictionary *playerItemInfo) {
        resultItem = playerItem;
        resultItemInfo = [playerItemInfo copy];
    }];
    _playerItem = resultItem;
    _playerItemInfo = resultItemInfo ? : _playerItemInfo;
    return _playerItem;
}

- (NSDictionary *)playerItemInfo {
    if (_playerItemInfo) {
        return _playerItemInfo;
    }
    __block AVPlayerItem *resultItem;
    __block NSDictionary *resultItemInfo;
    [[ZFPhotoManager sharedManager] getVideoInfoWithAsset:self.asset completionBlock:^(AVPlayerItem *playerItem, NSDictionary *playerItemInfo) {
        resultItem = playerItem;
        resultItemInfo = [playerItemInfo copy];
    }];
    _playerItem = resultItem ? : _playerItem;
    _playerItemInfo = resultItemInfo;
    return _playerItemInfo;
}

@end
