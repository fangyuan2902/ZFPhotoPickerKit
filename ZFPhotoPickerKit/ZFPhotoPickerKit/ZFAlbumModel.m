//
//  ZFAlbumModel.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFAlbumModel.h"
#import "ZFPhotoPickerDefine.h"

@interface ZFAlbumModel ()

@property (nonatomic, copy)   NSString *name;//相册的名称
@property (nonatomic, assign) NSUInteger count;//照片的数量
@property (nonatomic, strong) PHFetchResult *fetchResult;//PHFetchResult<PHAsset>

@end

@implementation ZFAlbumModel

+ (ZFAlbumModel *)albumWithResult:(PHFetchResult *)result name:(NSString *)name {
    ZFAlbumModel *model = [[ZFAlbumModel alloc] init];
    model.fetchResult = result;
    model.name = [self albumNameWithOriginName:name];
    model.count = result.count;
    
    return model;
}

+ (NSString *)albumNameWithOriginName:(NSString *)name {
    NSString *newName;
    if ([name containsString:@"Roll"]) {
        newName = @"相机胶卷";
    } else if ([name containsString:@"Stream"]){
        newName = @"我的照片流";
    } else if ([name containsString:@"Added"]){
        newName = @"最近添加";
    } else if ([name containsString:@"Selfies"]){
        newName = @"自拍";
    } else if ([name containsString:@"shots"]){
        newName = @"截屏";
    } else if ([name containsString:@"Videos"]){
        newName = @"视频";
    } else {
        newName = name;
    }
    return newName;
}

@end
