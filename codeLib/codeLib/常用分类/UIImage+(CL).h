//
//  UIImage+CL.h
//
//  Created by ftxbird on 14-4-2.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CL)
/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name;
@end