//
//  ViewController.m
//  ZFPhotoPickerKit
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 kang. All rights reserved.
//

#import "ViewController.h"
#import "ZFPhotoPickerKit/ZFPhotoPickerController.h"

@interface ViewController () <NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *Progress;
@property(nonatomic,assign)long long expectedContentLength; //要下载文件的总长度
@property(nonatomic,assign)long long currentLength;         //当前下载的长度

//@property(nonatomic,strong) NSMutableData *fileData;        //用来每次接受到数据，拼接数据使用
@property(nonatomic,copy) NSString *tartgetFilePath;        //保存的目标路径

//@property(nonatomic,assign,getter=isFinished)BOOL finished;

@property(nonatomic,assign)CFRunLoopRef downloadRunloop;    //下载线程的运行循环
/*
 保存文件的输出流
 - (void)open;      写入之前，打开流
 - (void)close;     完成之后，关闭流
 */
@property(nonatomic,strong)NSOutputStream *fileStrem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ZFPhotoPickerController *photoPickerC = [[ZFPhotoPickerController alloc] initWithMaxCount:5 delegate:self];
    photoPickerC.selectVideoEnable = YES;
    [self presentViewController:photoPickerC animated:YES completion:nil];
}

@end
