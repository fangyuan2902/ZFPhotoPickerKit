//
//  ZFAlbumCell.h
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZFAlbumModel;

@interface ZFAlbumCell : UITableViewCell

- (void)configCellWithItem:(ZFAlbumModel *)item;

@end

NS_ASSUME_NONNULL_END
