//
//  ZFPhotoPickerController.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZFAssetModel;
@protocol ZFPhotoPickerControllerDelegate;

@interface ZFPhotoPickerController : UINavigationController

#pragma mark - Properties

/** 是否允许选择视频 默认YES*/
@property (nonatomic, assign) BOOL selectVideoEnable;
/** 是否自动push到相册页面 默认YES*/
@property (nonatomic, assign) BOOL autoPushToPhotoCollection;
/** 每次最多可以选择带图片数量 默认9*/
@property (nonatomic, assign) NSUInteger maxCount;

/** delegate 回调 */
@property (nonatomic, weak) id<ZFPhotoPickerControllerDelegate> photoPickerDelegate;

/** 用户选择完照片的回调 images<previewImage>  assets<PHAsset or ALAsset>*/
@property (nonatomic, copy) void(^didFinishPickingPhotosBlock)(NSArray<UIImage *>* images, NSArray<ZFAssetModel *>*assets);

/** 用户选择完视频的回调 coverImage:视频的封面,asset 视频资源地址 */
@property (nonatomic, copy) void(^didFinishPickingVideoBlock)(UIImage *coverImage, id asset);
/** 用户点击取消的block 回调 */
@property (nonatomic, copy) void(^didCancelPickingPhotosBlock)(void);


#pragma mark - Life Cycle

- (instancetype)initWithMaxCount:(NSUInteger)maxCount delegate:(id<ZFPhotoPickerControllerDelegate>)delegate;

#pragma mark - Methods

- (void)didFinishPickingPhoto:(NSArray<ZFAssetModel *> *)assets;
- (void)didFinishPickingVideo:(ZFAssetModel *)asset;
- (void)didCancelPickingPhoto;

- (void)showAlertWithTitle:(NSString *)title;

@end


@protocol ZFPhotoPickerControllerDelegate <NSObject>

@optional

/**
 *  photoPickerController 点击确定后 代理回调
 *
 *  @param picker 具体的pickerController
 *  @param photos 选择的照片 -- 预览图
 *  @param assets 选择的原图数组  NSArray<PHAsset *>  or NSArray<ALAsset *> or nil
 */
- (void)photoPickerController:(ZFPhotoPickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets;

/**
 *  photoPickerController 点击取消后回调
 *
 *  @param picker 具体的pickerController
 */
- (void)photoPickerControllerDidCancel:(ZFPhotoPickerController *)picker;

/**
 *  photoPickerController选择一个视频后的回调
 *
 *  @param picker     具体的photoPickerController
 *  @param coverImage 视频的预览图
 *  @param asset      视频的具体资源 PHAsset or ALAsset
 */
- (void)photoPickerController:(ZFPhotoPickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset;

@end

NS_ASSUME_NONNULL_END
