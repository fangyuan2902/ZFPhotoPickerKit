//
//  ZFPhotoCollectionController.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFPhotoCollectionController.h" 
#import "ZFPhotoPickerController.h"
#import "ZFPhotoPreviewController.h"
#import "ZFAssetModel.h"
#import "ZFPhotoManager.h"
#import "ZFAssetCell.h"
#import "ZFBottomBar.h"

@interface ZFPhotoCollectionController ()

@property (nonatomic, assign) BOOL scrollBottom;

@property (nonatomic, weak)   ZFBottomBar *bottomBar;

@property (nonatomic, copy)   NSArray *assets;
@property (nonatomic, strong) NSMutableArray *selectedAssets;

@end

@implementation ZFPhotoCollectionController

static NSString * const kZFAssetCellIdentifier = @"ZFAssetCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navigation_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backEvent)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.title = self.album.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancelAction)];
    
    
    self.selectedAssets = [NSMutableArray array];
    self.scrollBottom = YES;
    
    [self setupCollectionView];
    __weak typeof(*&self) wSelf = self;
    [[ZFPhotoManager sharedManager] getAssetsFromResult:self.album.fetchResult pickingVideoEnable:[(ZFPhotoPickerController *)self.navigationController selectVideoEnable] completionBlock:^(NSArray<ZFAssetModel *> *assets) {
        __weak typeof(*&self) self = wSelf;
        self.assets = [NSArray arrayWithArray:assets];
        [self.collectionView reloadData];
        if (self.scrollBottom) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            self.scrollBottom = !self.scrollBottom;
        }
    }];
    
}

- (void)backEvent {
    if (self.assets.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self handleCancelAction];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"photo collection dealloc ");
}

#pragma mark - Methods

- (void)setupCollectionView {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(4, 4, 54, 4);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width, ((self.assets.count + 3) / 4) * self.view.frame.size.width);
    [self.collectionView registerClass:[ZFAssetCell class] forCellWithReuseIdentifier:kZFAssetCellIdentifier];
    
    ZFBottomBar *bottomBar = [[ZFBottomBar alloc] initWithBarType:ZFCollectionBottomBar];
    bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    __weak typeof(*&self) wSelf = self;
    [bottomBar setConfirmBlock:^{
        __weak typeof(*&self) self = wSelf;
        [(ZFPhotoPickerController *)self.navigationController didFinishPickingPhoto:self.selectedAssets];
    }];
    [self.view addSubview:self.bottomBar = bottomBar];
}

- (void)handleCancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    ZFPhotoPickerController *photoPickerVC = (ZFPhotoPickerController *)self.navigationController;
    [photoPickerVC didCancelPickingPhoto];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFAssetCell *assetCell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFAssetCellIdentifier forIndexPath:indexPath];
    [assetCell configCellWithItem:self.assets[indexPath.row]];
    __weak typeof(*&self) wSelf = self;
    [assetCell setWillChangeSelectedStateBlock:^BOOL(UIButton *button) {
        if (!button.selected) {
            __weak typeof(*&self) self = wSelf;
            ZFPhotoPickerController *photoPickerC = (ZFPhotoPickerController *)self.navigationController;
            if (self.selectedAssets.count < photoPickerC.maxCount) {
                return YES;
            }else{
                [photoPickerC showAlertWithTitle:[NSString stringWithFormat:@"最多只能选择%lu张照片",(unsigned long)photoPickerC.maxCount]];
            }
            return self.selectedAssets.count < photoPickerC.maxCount;
        }else {
            return NO;
        }
    }];
    
    [assetCell setDidChangeSelectedStateBlock:^(BOOL selected, ZFAssetModel *asset) {
        __weak typeof(*&self) self = wSelf;
        if (selected) {
            [self.selectedAssets containsObject:asset] ? nil : [self.selectedAssets addObject:asset];
        }else {
            [self.selectedAssets containsObject:asset] ? [self.selectedAssets removeObject:asset] : nil;
        }
        asset.selected = selected;
        [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
    }];
    
    return assetCell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFPhotoPreviewController *previewC = [[ZFPhotoPreviewController alloc] initWithCollectionViewLayout:[ZFPhotoPreviewController photoPreviewViewLayoutWithSize:[UIScreen mainScreen].bounds.size]];
    previewC.assets = self.assets;
    previewC.selectedAssets = [NSMutableArray arrayWithArray:self.selectedAssets];
    previewC.currentIndex = indexPath.row;
    __weak typeof(*&self) wSelf = self;
    [previewC setDidPreviewFinishBlock:^(NSArray<ZFAssetModel *> *selectedAssets) {
        __weak typeof(*&self) self = wSelf;
        self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
        [self.collectionView reloadData];
    }];
    [self.navigationController pushViewController:previewC animated:YES];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


#pragma mark - Getters

+ (UICollectionViewLayout *)photoCollectionViewLayoutWithWidth:(CGFloat)width {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 4;
    CGFloat itemWH = (width - 2 * margin - 4) / 4 - margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    return layout;
}

@end
