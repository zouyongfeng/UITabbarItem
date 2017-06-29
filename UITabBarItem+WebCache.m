//
//  UITabBarItem+WebCache.m
//  米庄理财
//
//  Created by aicai on 15/7/24.
//  Copyright (c) 2015年 aicai. All rights reserved.
//

#import "UITabBarItem+WebCache.h"

@implementation UITabBarItem (WebCache)

- (void)zy_setImageWithURL:(NSString *)urlString withImage:(UIImage *)placeholderImage {

    //1.从内存中加载图片
    UIImage *image = [[ZYImageCacheManager sharedImageCacheManager] imageFromDictionary:urlString];

    if (image) {
        //内存有图片，就只接使用图片
        self.image = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toScale:0.5];
        //[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
    } else {
        //内存没有图片，就从本地读区图片
        image = [[ZYImageCacheManager sharedImageCacheManager] imageFromLocal:urlString];

        if (image) {
            //从本地读取到了图片，就直接使用
            self.image = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toScale:0.5];

            //保存图片到内存中
            [[ZYImageCacheManager sharedImageCacheManager] setImage:image withURL:urlString];
        } else {
            //从本地没有读取到图片，从网络下载
            [[ZYImageCacheManager sharedImageCacheManager] imageFromNetwork:urlString complete:^(UIImage *image) {
                //图片下载完成后的操作
                //使用图片
                self.image = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toScale:0.5];
                if (image == NULL) {
                    self.image = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    return;
                }
                //加载到内存
                [[ZYImageCacheManager sharedImageCacheManager] setImage:image withURL:urlString];

                //加载到本地
                [[ZYImageCacheManager sharedImageCacheManager] saveImage:image withURL:urlString];
            }];
        }
    }
}

- (void)zy_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    self.image = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self zy_setImageWithURL:urlString withImage:placeholderImage];
}

- (void)zy_setSelectImageWithURL:(NSString *)urlString withImage:(UIImage *)placeholderImage {
    //1.从内存中加载图片
    UIImage *image = [[ZYImageCacheManager sharedImageCacheManager] imageFromDictionary:urlString];

    if (image) {
        //内存有图片，就只接使用图片
        self.selectedImage = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toScale:0.5];
    } else {
        //内存没有图片，就从本地读区图片
        image = [[ZYImageCacheManager sharedImageCacheManager] imageFromLocal:urlString];

        if (image) {
            //从本地读取到了图片，就直接使用
            self.selectedImage = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toScale:0.5];

            //保存图片到内存中
            [[ZYImageCacheManager sharedImageCacheManager] setImage:image withURL:urlString];
        } else {
            //从本地没有读取到图片，从网络下载
            [[ZYImageCacheManager sharedImageCacheManager] imageFromNetwork:urlString complete:^(UIImage *image) {
                //图片下载完成后的操作

                //使用图片
                self.selectedImage = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toScale:0.5];
                if (image == NULL) {
                    self.selectedImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    return;
                }
                //加载到内存
                [[ZYImageCacheManager sharedImageCacheManager] setImage:image withURL:urlString];

                //加载到本地
                [[ZYImageCacheManager sharedImageCacheManager] saveImage:image withURL:urlString];
            }];
        }
    }
}
- (void)zy_setSelectImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    self.selectedImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self zy_setSelectImageWithURL:urlString withImage:placeholderImage];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), NO, 0);
    [image drawInRect:CGRectIntegral(CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize))];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [scaledImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
