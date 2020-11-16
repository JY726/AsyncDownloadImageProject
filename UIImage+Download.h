//
//  UIImage+Download.h
//  bingo
//
//  Created by 林继沅 on 2020/10/29.
//  Copyright © 2020 chinamobile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kImagesDownloadCompleteNotification @"kImagesDownloadCompleteNotification"

@interface UIImage (Download)

+ (UIImage *)getDownloadImageWithImageUrl:(NSString *)imageUrl;

+ (void)downloadImageWithImageUrl:(NSString *)imageUrl;

+ (void)downloadImageWithImages:(NSArray *)imageUrls;

@end

NS_ASSUME_NONNULL_END
