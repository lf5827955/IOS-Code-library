//
//  Session上传(普通上传).m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//

#pragma mark - 简单上传
//
- (void)uploadFile
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
    
    // 3. Session,全局单例
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromFile:fileURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 回调函数,完成之后调用函数
        NSLog(@"%@", response);
    }];
    
    // 4. resume
    [task resume];
}
