//
//  ZFPhotoCollectionController.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZFAlbumModel;
@interface ZFPhotoCollectionController : UICollectionViewController

@property (nonatomic, strong) ZFAlbumModel *album;

+ (UICollectionViewLayout *)photoCollectionViewLayoutWithWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
