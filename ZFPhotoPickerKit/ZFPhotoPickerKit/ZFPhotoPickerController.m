//
//  ZFPhotoPickerController.m
//  SimpleExample
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ZFPhotoPickerController.h"
#import "ZFPhotoCollectionController.h"
#import "ZFPhotoManager.h"
#import "ZFAlbumCell.h"

@implementation ZFPhotoPickerController

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

#pragma mark - ZFPhotoPickerController Life Cycle

- (instancetype)initWithMaxCount:(NSUInteger)maxCount delegate:(id<ZFPhotoPickerControllerDelegate>)delegate {
    ZFAlbumListController *albumListC = [[ZFAlbumListController alloc] init];
    if (self = [super initWithRootViewController:albumListC]) {
        _photoPickerDelegate = delegate;
        _maxCount = maxCount ? : NSUIntegerMax;
        _autoPushToPhotoCollection = YES;
        _selectVideoEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_setupUnAuthorizedTips:) name:@"Notification_SetupUnAuthorizedTips" object:nil];
    [self _setupNavigationBarAppearance];
    [self _setupUnAuthorizedTips:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[ZFPhotoManager sharedManager] hasAuthorized]) {
        if (self.autoPushToPhotoCollection) {
            ZFPhotoCollectionController *photoCollectionC = [[ZFPhotoCollectionController alloc] initWithCollectionViewLayout:[ZFPhotoCollectionController photoCollectionViewLayoutWithWidth:self.view.frame.size.width]];
            __weak typeof(*&self) wSelf = self;
            [[ZFPhotoManager sharedManager] getAlbumsPickingVideoEnable:self.selectVideoEnable completionBlock:^(NSArray<ZFAlbumModel *> *albums) {
                __weak typeof(*&self) self = wSelf;
                photoCollectionC.album = [albums firstObject];
                [self pushViewController:photoCollectionC animated:NO];
            }];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_SetupUnAuthorizedTips" object:nil];
    NSLog(@"photo picker dealloc");
}

#pragma mark - ZFPhotoPickerController Methods

- (void)didFinishPickingPhoto:(NSArray<ZFAssetModel *> *)assets {
    NSMutableArray *images = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(ZFAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj.previewImage);
        [images addObject:obj.previewImage];
    }];
    if (self.photoPickerDelegate && [self.photoPickerDelegate respondsToSelector:@selector(photoPickerController:didFinishPickingPhotos:sourceAssets:)]) {
        [self.photoPickerDelegate photoPickerController:self didFinishPickingPhotos:images sourceAssets:assets];
    }
    self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(images,assets) : nil;
}

- (void)didFinishPickingVideo:(ZFAssetModel *)asset {
    if (self.photoPickerDelegate && [self.photoPickerDelegate respondsToSelector:@selector(photoPickerController:didFinishPickingVideo:sourceAssets:)]) {
        [self.photoPickerDelegate photoPickerController:self didFinishPickingVideo:asset.previewImage sourceAssets:asset];
    }
    
    self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(asset.previewImage , asset) : nil;
}

- (void)didCancelPickingPhoto {
    if (self.photoPickerDelegate && [self.photoPickerDelegate respondsToSelector:@selector(photoPickerControllerDidCancel:)]) {
        [self.photoPickerDelegate photoPickerControllerDidCancel:self];
    }
    self.didCancelPickingPhotosBlock ? self.didCancelPickingPhotosBlock() : nil;
}

- (void)showAlertWithTitle:(NSString *)title {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action];
    [self showDetailViewController:alertC sender:self];
}

/**
 *  设置当用户未授权访问照片时提示
 */
- (void)_setupUnAuthorizedTips:(NSNotification *)noti {
    UILabel *tipsLabel = [self.view viewWithTag:10000];
    if (![[ZFPhotoManager sharedManager] hasAuthorized]) {
        if (tipsLabel == nil) {
            tipsLabel = [[UILabel alloc] init];
            tipsLabel.tag = 10000;
            tipsLabel.frame = CGRectMake(8, 88, self.view.frame.size.width - 16, 300);
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.numberOfLines = 0;
            tipsLabel.font = [UIFont systemFontOfSize:16];
            tipsLabel.textColor = [UIColor blackColor];
            tipsLabel.userInteractionEnabled = YES;
            NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
            if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
            tipsLabel.text = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册。",[UIDevice currentDevice].model,appName];
            [self.view addSubview:tipsLabel];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTipsTap)];
            [tipsLabel addGestureRecognizer:tap];
        }
    } else {
        if (tipsLabel != nil) {
            [tipsLabel removeFromSuperview];
        }
        if (noti != nil && [noti.object integerValue] == 0) {
//            [MBProgressHUD showWithText:@"您的手机相册暂时没有图片"];
        }
    }
}

- (void)_handleTipsTap {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

/**
 *  设置navigationBar的样式
 */
- (void)_setupNavigationBarAppearance {
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    ;
    ;
    UIBarButtonItem *barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[ZFPhotoPickerController class]]];
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[ZFPhotoPickerController class]]];
    [barItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f]}];
    [navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}


@end

@implementation ZFAlbumListController

#pragma mark - ZFAlbumListController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_handleCancelAction)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 70.0f;
    [self.tableView registerClass:[ZFAlbumCell class] forCellReuseIdentifier:@"ZFAlbumCell"];
    
    [self loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)loadData {
    ZFPhotoPickerController *imagePickerVC = (ZFPhotoPickerController *)self.navigationController;
    __weak typeof(*&self) wSelf = self;
    [[ZFPhotoManager sharedManager] getAlbumsPickingVideoEnable:imagePickerVC.selectVideoEnable completionBlock:^(NSArray<ZFAlbumModel *> *albums) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_SetupUnAuthorizedTips" object:[NSString stringWithFormat:@"%ld",(long)[albums count]]];
        __weak typeof(*&self) self = wSelf;
        self.albums = [NSArray arrayWithArray:albums];
        [self.tableView reloadData];
    }];
}

- (void)applicationBecomeActive:(NSNotification *)noti {
    if (self.albums.count == 0) {
        [self loadData];
    }
}

#pragma mark - ZFAlbumListController Methods

- (void)_handleCancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    ZFPhotoPickerController *photoPickerVC = (ZFPhotoPickerController *)self.navigationController;
    [photoPickerVC didCancelPickingPhoto];
    
}


#pragma mark - ZFAlbumListController UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZFAlbumCell *albumCell = [tableView dequeueReusableCellWithIdentifier:@"ZFAlbumCell"];
    [albumCell configCellWithItem:self.albums[indexPath.row]];
    return albumCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFPhotoCollectionController *photoCollectionC = [[ZFPhotoCollectionController alloc] initWithCollectionViewLayout:[ZFPhotoCollectionController photoCollectionViewLayoutWithWidth:self.view.frame.size.width]];
    photoCollectionC.album = self.albums[indexPath.row];
    [self.navigationController pushViewController:photoCollectionC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
