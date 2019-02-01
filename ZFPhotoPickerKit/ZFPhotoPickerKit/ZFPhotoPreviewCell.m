//
//  ZFPhotoPreviewCell.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFPhotoPreviewCell.h"
#import "ZFAssetModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ZFPhotoManager.h"

@interface ZFPhotoPreviewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, weak)   UIButton *playButton;

@end

@implementation ZFPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

#pragma mark - Methods

- (void)configCellWithItem:(ZFAssetModel *)item {
    if (item.asset.mediaType == PHAssetMediaTypeVideo) {
        [self setupPlayer:item];
        self.scrollView.hidden = YES;
        self.playView.hidden = NO;
    } else {
        [self.scrollView setZoomScale:1.0f];
        self.imageView.image = item.previewImage;
        [self resizeSubviews];
        self.scrollView.hidden = NO;
        self.playView.hidden = YES;
    }
}

- (void)setupView {
    self.backgroundColor = self.contentView.backgroundColor = [UIColor blackColor];
    
    [self.containerView addSubview:self.imageView];
    [self.scrollView addSubview:self.containerView];
    [self.contentView addSubview:self.scrollView];
    
    [self.contentView addSubview:self.playView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSingleTap)];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.contentView addGestureRecognizer:singleTap];
    [self.contentView addGestureRecognizer:doubleTap];
}

- (void)resizeSubviews {
    self.containerView.frame = self.bounds;
    UIImage *image = self.imageView.image;
    if (!image) {
        return;
    }
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat widthPercent = (image.size.width / screenScale) / self.frame.size.width;
    CGFloat heightPercent = (image.size.height / screenScale) / self.frame.size.height;
    if (widthPercent <= 1.0f && heightPercent <= 1.0f) {
        self.containerView.bounds = CGRectMake(0, 0, image.size.width/screenScale, image.size.height/screenScale);
        self.containerView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    } else if (widthPercent > 1.0f && heightPercent < 1.0f) {
        self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, heightPercent * self.frame.size.width);
    }else if (widthPercent <= 1.0f && heightPercent > 1.0f) {
        self.containerView.frame = CGRectMake(0, 0, self.frame.size.height * widthPercent ,self.frame.size.height);
    }else {
        if (widthPercent > heightPercent) {
            self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, heightPercent * self.frame.size.width);
        }else {
            self.containerView.frame = CGRectMake(0, 0, self.frame.size.height * widthPercent ,self.frame.size.height);
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.scrollView.alwaysBounceVertical = self.containerView.frame.size.height <= self.frame.size.height ? NO : YES;
    self.imageView.frame = self.containerView.bounds;
    
}

- (void)_handleSingleTap {
    self.singleTapBlock ? self.singleTapBlock() : nil;
}

- (void)_handleDoubleTap:(UITapGestureRecognizer *)doubleTap {
    if (self.scrollView.zoomScale > 1.0f) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [doubleTap locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.containerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - Getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 3.0f;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
    }
    return _scrollView;
}

 - (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

/**
 *  初始化player
 *  1.获取asset对应的AVPlayerItem
 *  2.初始化AVPlayer
 *  3.添加AVPlayerLayer
 *  4.chu
 */
- (void)setupPlayer:(ZFAssetModel *)item {
    __weak typeof(self) weakSelf = self;
    [[ZFPhotoManager sharedManager] getVideoInfoWithAsset:item.asset completionBlock:^(AVPlayerItem *playerItem, NSDictionary *playetItemInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            AVURLAsset *videoURLAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"] options:nil];
//            AVPlayerItem *xjPlayerItem = [AVPlayerItem playerItemWithAsset:videoURLAsset];
            weakSelf.player = [AVPlayer playerWithPlayerItem:playerItem];
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            playerLayer.frame = weakSelf.playView.bounds;
            [weakSelf.playView.layer addSublayer:playerLayer];
            [weakSelf setupPlayButton];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayer) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        });
    }];    
}

- (void)setupPlayButton {
    UIButton *playButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [playButton setImage:[UIImage imageNamed:@"video_preview_play_normal"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"video_preview_play_highlight"] forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(handlePlayAciton) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:playButton];
    self.playButton = playButton;
}

- (UIView *)playView {
    if (!_playView) {
        _playView = [[UIView alloc] initWithFrame:self.bounds];
        _playView.clipsToBounds = YES;
    }
    return _playView;
}

- (void)handlePlayAciton {
    CMTime currentTime = self.player.currentItem.currentTime;
    CMTime durationTime = self.player.currentItem.duration;
    if (self.player.rate == 0.0f) {
        [self.playButton setImage:nil forState:UIControlStateNormal];
        if (currentTime.value == durationTime.value)
            [self.player.currentItem seekToTime:CMTimeMake(0, 1)];
        [self.player play];
    } else {
        [self pausePlayer];
    }
}

- (void)pausePlayer {
    [self.playButton setImage:[UIImage imageNamed:@"video_preview_play_normal"] forState:UIControlStateNormal];
    [self.player pause];
}

@end

