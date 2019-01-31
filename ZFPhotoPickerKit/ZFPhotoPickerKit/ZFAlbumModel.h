//
//  ZFAlbumModel.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PHFetchResult.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFAlbumModel : NSObject

@property (nonatomic, copy, readonly)   NSString *name;//相册的名称
@property (nonatomic, assign, readonly) NSUInteger count;//照片的数量
@property (nonatomic, strong, readonly) PHFetchResult *fetchResult;//PHFetchResult<PHAsset>

+ (ZFAlbumModel *)albumWithResult:(PHFetchResult *)result name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
