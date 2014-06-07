//
//  UILable.m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//

/**
 *  初始化
 */
UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(90, 37, 30, 18)];
/**
 *  设置背景颜色
 */
[lable setBackgroundColor:[UIColor clearColor]];
/**
 *  设置字体
 */
[lable setFont:[UIFont systemFontOfSize:10]];
/**
 *  设置文本颜色
 */
[lable setTextColor:[UIColor colorWithRed:150/255.00 green:150/255.00 blue:150/255.0 alpha:1.0]];
/**
 *  设置文本
 */
[lable setText:@"类型:"];

/**
 *  UILabel单行模式下，自适应文字
 这种情况用于，frame，一定，根据字数多少来自动显示，当文本多的时候，自动调整字体大小以适应UILable
 */
[lable.text setAdjustsFontSizeToFitWidth:YES];

