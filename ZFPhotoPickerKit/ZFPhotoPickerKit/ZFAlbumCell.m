//
//  ZFAlbumCell.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFAlbumCell.h"
#import "ZFAlbumModel.h"
#import "ZFPhotoManager.h"
#import "Masonry.h"

@interface ZFAlbumCell ()

@property (strong, nonatomic) UIImageView *albumImageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation ZFAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.albumImageView = [[UIImageView alloc] init];
        self.albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.albumImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.albumImageView];
        [self.albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.equalTo(@60);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.albumImageView.mas_right).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
    }
    return self;
}

- (void)configCellWithItem:(ZFAlbumModel *)item {
    self.titleLabel.text = item.name;
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:item.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",item.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.titleLabel.attributedText = nameString;
    
    [[ZFPhotoManager sharedManager] getThumbnailWithAsset:[item.fetchResult lastObject] size:CGSizeMake(60, 60) completionBlock:^(UIImage *image) {
        self.albumImageView.image = image;
    }];
    
}

@end

