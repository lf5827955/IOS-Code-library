//
//  NSOperation.m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//


1. 全局队列与并行队列的区别
dispatch_queue_t q =
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
1> 不需要创建，直接GET就能用
2> 两个队列的执行效果相同
3> 全局队列没有名称，调试时，无法确认准确队列

4> 全局队列有高中默认优先级


2. 并行队列
dispatch_queue_t q =
dispatch_queue_create("ftxbird", DISPATCH_QUEUE_CONCURRENT);


3. 串行队列

dispatch_queue_t t = dispatch_queue_create("ftxbird",DISPATCH_QUEUE_SERIAL);


4. 开发中，跟踪当前线程
[NSThread currentThread]


5. 并行队列的任务嵌套例子
dispatch_queue_t q = dispatch_queue_create("ftxbird", DISPATCH_QUEUE_CONCURRENT);

// 任务嵌套
dispatch_sync(q, ^{
    NSLog(@"1 %@", [NSThread currentThread]);
    
    dispatch_sync(q, ^{
        NSLog(@"2 %@", [NSThread currentThread]);
        
        dispatch_sync(q, ^{
            
            NSLog(@"3 %@", [NSThread currentThread]);
        });
    });
    
    dispatch_async(q, ^{
        
        NSLog(@"4 %@", [NSThread currentThread]);
    });
    
    NSLog(@"5 %@", [NSThread currentThread]);
    
});



// 运行结果是: 12345 或12354


6. 主队列(线程)
1>每一个应用程序都只有一个主线程
2>所有UI的更新工作，都必须在主线程上执行！
3>主线程是一直工作的，而且除非将程序杀掉，否则主线程的工作永远不会结束！
dispatch_queue_t q = dispatch_get_main_queue();


7.在主队列上更新UI的例子


//创建代码块
void (^TaskOne)(void) = ^(void)
{
    NSLog(@"Current thread = %@", [NSThread currentThread]);
    NSLog(@"Main thread = %@", [NSThread mainThread]);
    
    [[[UIAlertView alloc] initWithTitle:@"GCD"
                                message:@"Great Center Dispatcher"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
};

//取得分发队列
dispatch_queue_t mainQueue = dispatch_get_main_queue();

//提交任务
dispatch_async(mainQueue, TaskOne);
}
//简便写法
dispatch_async( dispatch_get_main_queue(), ^(void)
               {
                   
                   NSLog(@"Current thread = %@", [NSThread currentThread]);
                   NSLog(@"Main thread = %@", [NSThread mainThread]);
                   
                   [[[UIAlertView alloc] initWithTitle:@"GCD"
                                               message:@"Great Center Dispatcher"
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil, nil] show];
               });

//输出结果
//2014-05-02 20:34:27.872 serirl[835:60b] Current thread = <NSThread: 0x8e24540>{name = (null), num = 1}
//2014-05-02 20:34:27.873 serirl[835:60b] Main thread = <NSThread: 0x8e24540>{name = (null), num = 1}


NSOperation 多线程技术

8. NSBlockOperation 简单使用



//开发中一般给自定义队列定义为属性
@property (nonatomic, strong) NSOperationQueue *myQueue;

self.myQueue = [[NSOperationQueue alloc] init];



1>在自定义队列

NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"%@", [NSThread currentThread]);
}];

所有的自定义队列，都是在子线程中运行.
[self.myQueue addOperation:block];

或者:
[self.myQueue addOperationWithBlock:^{
    NSLog(@"%@", [NSThread currentThread]);
}];


2>在主队列中执行
[[NSOperationQueue mainQueue] addOperationWithBlock:^{
    NSLog(@"%@", [NSThread currentThread]);
}];


3> NSBlockOperation 的使用例子



NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"下载图片 %@", [NSThread currentThread]);
}];
NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"修饰图片 %@", [NSThread currentThread]);
}];
NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"保存图片 %@", [NSThread currentThread]);
}];
NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"更新UI %@", [NSThread currentThread]);
}];

// 设定执行顺序, Dependency依赖，可能会开多个，但不会太多
// 依赖关系是可以跨队列的！
[op2 addDependency:op1];
[op3 addDependency:op2];
[op4 addDependency:op3];
// GCD是串行队列，异步任务，只会开一个线程

[self.myQueue addOperation:op1];
[self.myQueue addOperation:op2];
[self.myQueue addOperation:op3];
// 所有UI的更新需要在主线程上进行
[[NSOperationQueue mainQueue] addOperation:op4];


9. NSInvocationOperation 简单使用




NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(demoOp:) object:@"hello op"];



- (void)demoOp:(id)obj
{
    NSLog(@"%@ - %@", [NSThread currentThread], obj);
}


10. performSelectorOnMainThread 方法使用


// 1> 模拟下载，延时
[NSThread sleepForTimeInterval:1.0];

// 2> 设置图像，苹果底层允许使用performSelectorInBackground方法
// 在后台线程更新UI，强烈不建议大家这么做！
// YES会阻塞住线程，直到调用方法完成
// NO不会阻塞线程，会继续执行
[self performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:imagePath] waitUntilDone:NO];


// 1. 图像
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView sizeToFit];
}

11.
提问：代码存在什么问题？如果循环次数非常大，会出现什么问题？应该如何修改？

// 解决办法1：如果i比较大，可以在for循环之后@autoreleasepool
// 解决方法2：如果i玩命大，一次循环都会造成
自动释放池被填满,一次循环就@autoreleasepool
for (int i = 0; i < 10000000; ++i) {
    @autoreleasepool {
        // *
        NSString *str = @"Hello World!";
        // new *
        str = [str uppercaseString];
        // new *
        str = [NSString stringWithFormat:@"%@ %d", str, i];
        
        NSLog(@"%@", str);
    }
}



