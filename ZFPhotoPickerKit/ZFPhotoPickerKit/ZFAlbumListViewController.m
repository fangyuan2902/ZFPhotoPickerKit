//
//  ZFAlbumListViewController.m
//  ZFPhotoPickerKit
//
//  Created by mac on 2019/2/1.
//  Copyright © 2019年 kang. All rights reserved.
//

#import "ZFAlbumListViewController.h"
#import "ZFAlbumCell.h"
#import "ZFPhotoPickerController.h"
#import "ZFPhotoManager.h"

@interface ZFAlbumListViewController ()

@end

@implementation ZFAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancelAction)];
    
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

- (void)handleCancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    ZFPhotoPickerController *photoPickerVC = (ZFPhotoPickerController *)self.navigationController;
    [photoPickerVC didCancelPickingPhoto];
    
}

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
