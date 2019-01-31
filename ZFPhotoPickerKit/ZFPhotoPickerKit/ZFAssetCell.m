//
//  ZFAssetCell.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFAssetCell.h"
#import "ZFAssetModel.h"
#import "ZFPhotoManager.h"
#import "UIView+ZFAnimations.h"
#import "Masonry.h"

@interface ZFAssetCell ()

@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) UIButton *stateButton;
@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation ZFAssetCell
@synthesize asset = _asset;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.photoImageView];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.equalTo(self.contentView);
        }];
        
        self.stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.stateButton setImage:[UIImage imageNamed:@"photo_state_normal"] forState:UIControlStateNormal];
        [self.stateButton setImage:[UIImage imageNamed:@"photo_state_selected"] forState:UIControlStateSelected];
        [self.stateButton addTarget:self action:@selector(_handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.stateButton];
        [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView);
        }];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self.contentView).offset(-5);
        }];
    }
    return self;
}

#pragma mark - Methods

- (void)configCellWithItem:(ZFAssetModel *)item {
    _asset = item;
    self.stateButton.selected = item.selected;
    if (item.asset.mediaType == PHAssetMediaTypeVideo) {
        self.timeLabel.text = item.timeLength;
        self.timeLabel.hidden = NO;
    } else {
        self.timeLabel.hidden = YES;
    }
    
    [[ZFPhotoManager sharedManager] getThumbnailWithAsset:item.asset size:self.bounds.size completionBlock:^(UIImage *image) {
        self.photoImageView.image = image;
    }];
    
}

- (void)_handleButtonAction:(UIButton *)sender {
    BOOL originState = sender.selected;
    self.stateButton.selected = self.willChangeSelectedStateBlock ? self.willChangeSelectedStateBlock(sender) : NO;
    if (self.stateButton.selected) {
        [UIView animationWithLayer:self.stateButton.layer];
    }
    if (originState != self.stateButton.selected) {
        self.didChangeSelectedStateBlock ? self.didChangeSelectedStateBlock(self.stateButton.selected, self.asset) : nil;
    }
}

@end

