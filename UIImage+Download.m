//
//  UIImage+Download.m
//  bingo
//
//  Created by 林继沅 on 2020/10/29.
//  Copyright © 2020 chinamobile. All rights reserved.
//

#import "UIImage+Download.h"

@implementation UIImage (Download)

+ (UIImage *)getDownloadImageWithImageUrl:(NSString *)imageUrl {
    NSString *filePath = [self getFilePathWithImageUrl:imageUrl];
    UIImage *image = [[UIImage imageWithContentsOfFile:filePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];// 通过路径获取图片
    return image;
}

+ (void)downloadImageWithImages:(NSArray *)imageUrls{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.imagedownload", DISPATCH_QUEUE_CONCURRENT);

    __block BOOL needNotice = NO;
    for (NSString *imageUrl in imageUrls) {
        dispatch_group_enter(group);
        NSString *filePath = [self getFilePathWithImageUrl:imageUrl];
        __block UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        // 如果imageUrl的图片已经下载过，就不下载了
        if (image){
            dispatch_group_leave(group);
            return;
        }
        dispatch_async(queue, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            image = [UIImage imageWithData:imageData];
            if (image != nil) {
                if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
                    NSLog(@"保存成功");
                    needNotice = YES;
                }else {
                    NSLog(@"保存失败");
                }
                dispatch_group_leave(group);
            }
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (needNotice) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kImagesDownloadCompleteNotification object:nil];
        }
    });
}

+ (void)downloadImageWithImageUrl:(NSString *)imageUrl {
    NSString *filePath = [self getFilePathWithImageUrl:imageUrl];
    __block UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    // 如果imageUrl的图片已经下载过，就不下载了
    if (image) return;
    
    dispatch_queue_t queue = dispatch_queue_create("com.imagedownload", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        image = [UIImage imageWithData:imageData];
        if (image != nil) {
            if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
                NSLog(@"保存成功");
            }else {
                NSLog(@"保存失败");
            }
        }
    });
}

+ (NSString *)getFilePathWithImageUrl:(NSString *)imageUrl {

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/", pathDocuments];
    
   // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else {
        NSLog(@"FileDir is exists.");
    }
    
    if (imageUrl) {
        NSArray *array = [imageUrl componentsSeparatedByString:@"/"];
        NSString *string = @"test.png";
        if (array.count > 0) {
            string = array.lastObject;
        }
        NSString *filePath = [createPath stringByAppendingString:string];
        return filePath;
    }

    return nil;
}

@end
