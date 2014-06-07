//
//  Session上传.m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//

#pragma mark - 监控上传进度
//
- (void)uploadFile1
{
    // 1. URL
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"head8.png" withExtension:nil];
    NSURL *url = [NSURL URLWithString:@"http://localhost/uploads/1.png"];
    
    // 2. Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
    // 1> PUT方法
    // PUT
    //    1) 文件大小无限制
    //    2) 可以覆盖文件
    // POST
    //    1) 通常有限制2M
    //    2) 新建文件,不能重名
    request.HTTPMethod = @"PUT";
    
    // 2> 安全认证
    // admin:123456
    // result base64编码
    // Basic result
    /**
     BASE 64是网络传输中最常用的编码格式 - 用来将二进制的数据编码成字符串的编码方式
     
     BASE 64的用法:
     1> 能够编码,能够解码
     2> 被很多的加密算法作为基础算法
     */
    NSString *authStr = @"admin:123456";
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [authData base64EncodedStringWithOptions:0];
    NSString *resultStr = [NSString stringWithFormat:@"Basic %@", base64Str];
    [request setValue:resultStr forHTTPHeaderField:@"Authorization"];
    
    // 3. Session,全局单例(我们能够给全局的session设置代理吗?如果不能为什么?)
    // sharedSession是全局共享的,因此如果要设置代理,需要单独实例化一个Session
    /**
     NSURLSessionConfiguration(会话配置)
     
     defaultSessionConfiguration;       // 磁盘缓存,适用于大的文件上传下载
     ephemeralSessionConfiguration;     // 内存缓存,以用于小的文件交互,GET一个头像
     backgroundSessionConfiguration:(NSString *)identifier; // 后台上传和下载
     */
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    
    // 需要监听任务的执行状态
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromFile:fileURL];
    
    // 4. resume
    [task resume];
}

#pragma mark - 上传进度的代理方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    // bytesSent totalBytesSent totalBytesExpectedToSend
    // 发送字节(本次发送的字节数)    总发送字节数(已经上传的字节数)     总希望要发送的字节(文件大小)
    NSLog(@"%lld-%lld-%lld-", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    // 已经上传的百分比
    float progress = (float)totalBytesSent / totalBytesExpectedToSend;
    NSLog(@"%f", progress);
}

#pragma mark - 上传完成的代理方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"完成 %@", [NSThread currentThread]);
}
