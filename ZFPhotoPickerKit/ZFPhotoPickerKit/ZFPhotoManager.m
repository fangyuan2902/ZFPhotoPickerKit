//
//  ZFPhotoManager.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFPhotoManager.h"

@interface ZFPhotoManager ()

@property (nonatomic, strong)  PHCachingImageManager *imageManager;

@end

@implementation ZFPhotoManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static id manager;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (BOOL)hasAuthorized {
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

/// ========================================
/// @name   获取Album相册相关方法
/// ========================================

- (void)getAlbumsPickingVideoEnable:(BOOL)pickingVideoEnable completionBlock:(void(^)(NSArray<ZFAlbumModel *> *))completionBlock {
    NSMutableArray *albumArr = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!pickingVideoEnable) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    }
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumVideos;
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle containsString:@"最近删除"]) continue;
        
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"]) {
            [albumArr insertObject:[ZFAlbumModel albumWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
        } else {
            [albumArr addObject:[ZFAlbumModel albumWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum | PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    for (PHAssetCollection *collection in albums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle isEqualToString:@"My Photo Stream"]) {
            [albumArr insertObject:[ZFAlbumModel albumWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
        } else {
            [albumArr addObject:[ZFAlbumModel albumWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    completionBlock ? completionBlock(albumArr) : nil;
} 

- (void)getAssetsFromResult:(id)result pickingVideoEnable:(BOOL)pickingVideoEnable completionBlock:(void(^)(NSArray<ZFAssetModel *> *))completionBlock {
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        for (PHAsset *asset in result) {
            [photoArr addObject:[ZFAssetModel modelWithAsset:asset]];
        }
        completionBlock ? completionBlock(photoArr) : nil;
    }
}

/// ========================================
/// @name   获取Asset对应信息相关方法
/// ========================================
- (void)getOriginImageWithAsset:(PHAsset *)asset completionBlock:(void (^)(UIImage *))completionBlock {
    PHImageRequestOptions *imageRequestOption = [[PHImageRequestOptions alloc] init];
    imageRequestOption.synchronous = YES;
    imageRequestOption.networkAccessAllowed = YES;
    [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOption resultHandler:^(UIImage *result, NSDictionary *info) {
        UIImage *resultImage = result;
        completionBlock ? completionBlock(resultImage) : nil;
    }];
}

- (void)getThumbnailWithAsset:(PHAsset *)asset size:(CGSize)size completionBlock:(void(^)(UIImage *image))completionBlock {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    imageRequestOptions.networkAccessAllowed = YES;
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(size.width * screenScale, size.height *screenScale) contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        completionBlock ? completionBlock(result) : nil;
    }];
}

- (void)getPreviewImageWithAsset:(PHAsset *)asset completionBlock:(void(^)(UIImage *image))completionBlock {
    [self getThumbnailWithAsset:asset size:[UIScreen mainScreen].bounds.size completionBlock:completionBlock];
}

- (void)getImageOrientationWithAsset:(PHAsset *)asset completionBlock:(void (^)(UIImageOrientation))completionBlock {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    imageRequestOptions.networkAccessAllowed = YES;
    [self.imageManager requestImageDataForAsset:asset options:imageRequestOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        completionBlock ? completionBlock(orientation) : nil;
    }];
}

- (void)getAssetSizeWithAsset:(PHAsset *)asset completionBlock:(void(^)(CGFloat size))completionBlock {
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        completionBlock ? completionBlock(imageData.length) : nil;
    }];
}

- (void)getVideoInfoWithAsset:(PHAsset *)asset completionBlock:(void (^)(AVPlayerItem *, NSDictionary *))completionBlock {
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        completionBlock ? completionBlock(playerItem,info) : nil;
    }];
}

#pragma mark - Getters
- (PHCachingImageManager *)imageManager {
    return [[PHCachingImageManager alloc] init];
}

@end
