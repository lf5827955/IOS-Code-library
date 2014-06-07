//
//  UIImage+CL.m
//
//  Created by ftxbird on 14-4-2.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//

#import "UIImage+(CL).h"

@implementation UIImage (CL)
/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}
@end
