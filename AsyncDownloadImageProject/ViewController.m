//
//  ViewController.m
//  AsyncDownloadImageProject
//
//  Created by 林继沅 on 2020/11/16.
//

#import "ViewController.h"
#import "UIImage+Download.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 下载一张图片
    [UIImage downloadImageWithImageUrl:@""];
    
    // 下载多张图片
    [UIImage downloadImageWithImages:@[]];
    
    // 根据URL获取下载到本地的图片
    [UIImage getDownloadImageWithImageUrl:@""];
    
}


@end
