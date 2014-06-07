//
//  UIScrollView.m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//

/**
 *  设置scrollView内容的尺寸(滚动的范围)
 */
self.scrollView.contentSize = CGSizeMake(892, 480);
/**
 *  设置可视范围
 */
self.scrollView.contentInset = UIEdgeInsetsMake(10, 20, 40, 80);
/**
 *  设置可视范围的偏移
 */
self.scrollView.contentOffset = CGPointMake(0, -64);


// 设置内容尺寸
self.scrollView.contentSize = self.minionView.frame.size;

// 设置
self.scrollView.delegate = self;

// 设置最大和最小的缩放比例
self.scrollView.maximumZoomScale = 2.0;
self.scrollView.minimumZoomScale = 0.2;

// 3.隐藏水平滚动条
self.scrollView.showsHorizontalScrollIndicator = NO;

// 4.分页
self.scrollView.pagingEnabled = YES;

// 5.设置pageControl的总页数
self.pageControl.numberOfPages = MJImageCount;
/**
 *  当用户开始拖拽scrollView时就会调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

/**
 *  只要scrollView正在滚动,就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据scrollView的滚动位置决定pageControl显示第几页
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.pageControl.currentPage = page;
}

/**
 *  当用户使用捏合手势的时候会调用
 *
 *  @return 返回的控件就是需要进行缩放的控件
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.minionView;
}
/**
 *  正在缩放的时候会调用
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView;