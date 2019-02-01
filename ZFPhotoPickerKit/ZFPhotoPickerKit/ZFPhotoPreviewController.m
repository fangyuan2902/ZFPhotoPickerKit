//
//  ZFPhotoPreviewController.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFPhotoPreviewController.h"
#import "ZFPhotoPickerController.h"
#import "ZFAssetModel.h"
#import "ZFPhotoPickerDefine.h"
#import "ZFBottomBar.h"
#import "ZFPhotoPreviewCell.h"
#import "UIView+ZFAnimations.h"

@interface ZFPhotoPreviewController ()

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, weak)   UIButton *stateButton;
@property (nonatomic, strong) ZFBottomBar *bottomBar;
@property (nonatomic, strong) ZFPhotoPreviewCell *currentPlayingCell;

@end

@implementation ZFPhotoPreviewController

static NSString * const kZFPhotoPreviewIdentifier = @"ZFPhotoPreviewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setup];
    [self setupCollectionView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    NSLog(@"preview dealloc");
}

#pragma mark - Methods

- (void)setup {
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.bottomBar];
    [self updateTopBarStatus];
    [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
}

- (void)setupCollectionView {
    
    [self.collectionView registerClass:[ZFPhotoPreviewCell class] forCellWithReuseIdentifier:kZFPhotoPreviewIdentifier];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width * self.assets.count, self.view.frame.size.height);
    self.collectionView.pagingEnabled = YES;
    
}

- (void)handleBackAction {
    self.didPreviewFinishBlock ? self.didPreviewFinishBlock(self.selectedAssets) : nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleStateChangeAction {
    if (self.stateButton.selected) {
        [self.selectedAssets removeObject:self.assets[self.currentIndex]];
        self.assets[self.currentIndex].selected = NO;
        [self updateTopBarStatus];
    }else {
        ZFPhotoPickerController *pickerC = (ZFPhotoPickerController *)self.navigationController;
        if (self.selectedAssets.count < pickerC.maxCount) {
            self.assets[self.currentIndex].selected = YES;
            [self.selectedAssets addObject:self.assets[self.currentIndex]];
            [self updateTopBarStatus];
            [UIView animationWithLayer:self.stateButton.layer];
        }else {
            //TODO 超过最大数量
            NSLog(@"超过最大数量");
            [pickerC showAlertWithTitle:[NSString stringWithFormat:@"最多只能选择%lu张照片",(unsigned long)pickerC.maxCount]];
        }
    }
    [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
}

- (void)updateTopBarStatus {
    ZFAssetModel *asset = self.assets[self.currentIndex];
    self.stateButton.selected = asset.selected;
}

- (void)setBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (!animated) {
        self.topBar.hidden = self.bottomBar.hidden = hidden;
        return;
    }
    [UIView animateWithDuration:.15 animations:^{
        self.topBar.alpha = self.bottomBar.alpha = hidden ? .0f : 1.0f;
    } completion:^(BOOL finished) {
        self.topBar.hidden = self.bottomBar.hidden = hidden;
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    self.currentIndex = offSet.x / self.view.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateTopBarStatus];
    NSArray *array = [self.collectionView visibleCells];
    for (ZFPhotoPreviewCell *cell in array) {
        [cell pausePlayer];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFPhotoPreviewCell *previewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFPhotoPreviewIdentifier forIndexPath:indexPath];
    [previewCell configCellWithItem:self.assets[indexPath.row]];
    __weak typeof(*&self) wSelf = self;
    [previewCell setSingleTapBlock:^{
        __weak typeof(*&self) self = wSelf;
        [self setBarHidden:!self.topBar.hidden animated:YES];
    }];
    return previewCell;
}


#pragma mark - Getters

- (UIView *)topBar {
    if (!_topBar) {
        
        CGFloat originY = 0;
        if ([UIScreen mainScreen].bounds.size.height == 812) {
            originY = 34;
        } else {
            originY = 20;
        }
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, originY + 44)];
        _topBar.backgroundColor = [UIColor colorWithRed:34/255.0f green:34/255.0f blue:34/255.0f alpha:.7f];
        
        UIButton *backButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [backButton sizeToFit];
        backButton.frame = CGRectMake(12, _topBar.frame.size.height/2 - backButton.frame.size.height/2 + originY/2, backButton.frame.size.width, backButton.frame.size.height);
        [backButton addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:backButton];
        
        UIButton *stateButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [stateButton setImage:[UIImage imageNamed:@"photo_state_normal"] forState:UIControlStateNormal];
        [stateButton setImage:[UIImage imageNamed:@"photo_state_selected"] forState:UIControlStateSelected];
        [stateButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [stateButton sizeToFit];
        stateButton.frame = CGRectMake(_topBar.frame.size.width - 12 - stateButton.frame.size.width, _topBar.frame.size.height/2 - stateButton.frame.size.height/2 + originY/2, stateButton.frame.size.width, stateButton.frame.size.height);
        
        [stateButton addTarget:self action:@selector(handleStateChangeAction) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:self.stateButton = stateButton];
        
    }
    return _topBar;
}

- (ZFBottomBar *)bottomBar {
    if (!_bottomBar) {
        CGFloat bottom = 0;
        if ([UIScreen mainScreen].bounds.size.height == 812) {
            bottom = 70;
        } else {
            bottom = 50;
        }
        _bottomBar = [[ZFBottomBar alloc] initWithBarType:ZFPreviewBottomBar];
        _bottomBar.frame = CGRectMake(0, self.view.frame.size.height - bottom, self.view.frame.size.width, bottom);
        [_bottomBar updateBottomBarWithAssets:self.selectedAssets];
        
        __weak typeof(*&self) wSelf = self;
        [_bottomBar setConfirmBlock:^{
            __weak typeof(*&self) self = wSelf;
            [(ZFPhotoPickerController *)self.navigationController didFinishPickingPhoto:self.selectedAssets];
        }];
    }
    return _bottomBar;
}


+ (UICollectionViewLayout *)photoPreviewViewLayoutWithSize:(CGSize)size {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(size.width, size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return layout;
}


@end
