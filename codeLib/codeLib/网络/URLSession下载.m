//
//  URLSession下载.m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//

/**
 // 下载进度跟进
 - (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
 totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
 
 didWriteData totalBytesWritten totalBytesExpectedToWrite
 本次写入的字节数 已经写入的字节数   预期下载的文件大小
 
 // 完成下载
 - (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didFinishDownloadingToURL:(NSURL *)location;
 */
#pragma mark - 下载(GET)
//
- (void)downloadTask
{
    // 1. URL
    NSURL *url = [NSURL URLWithString:@"http://localhost/images/head1.png"];
    
    // 2. Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0];
    
    // 3. Session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 4. download
    [[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        // 下载的位置,沙盒中tmp目录中的临时文件,会被及时删除
        NSLog(@"下载完成 %@ %@", location, [NSThread currentThread]);
        /**
         document       备份,下载的文件不能放在此文件夹中
         cache          缓存的,不备份,重新启动不会被清空,如果缓存内容过多,可以考虑新建一条线程检查缓存目录中的文件大小,自动清理缓存,给用户节省控件
         tmp            临时,不备份,不缓存,重新启动iPhone,会自动清空
         */
        // 直接通过文件名就可以加载图像,图像会常驻内存,具体的销毁有系统负责
        // [UIImage imageNamed:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 从网络下载下来的是二进制数据
            NSData *data = [NSData dataWithContentsOfURL:location];
            // 这种方式的图像会自动释放,不占据内存,也不需要放在临时文件夹中缓存
            // 如果用户需要,可以提供一个功能,保存到用户的相册即可
            UIImage *image = [UIImage imageWithData:data];
            
            self.imageView.image = image;
        });
    }] resume];
    
    //    [task resume];
}

