//
//  GCD 代码.m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//

/**
 *  整理自https://github.com/nixzhu/dev-blog/blob/master/2014-04-19-grand-central-dispatch-in-depth-part-1.md
 */


/**
 *  dispatch_async
 */
/**
 *  当你需要在后台执行一个基于网络或 CPU 紧张的任务时就使用 dispatch_async ，这样就不会阻塞当前线程。
 */
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
    UIImage *overlayImage = [self faceOverlayImageFromImage:_image];
    dispatch_async(dispatch_get_main_queue(), ^{ // 2
        [self fadeInNewImage:overlayImage]; // 3
    });
});

/**下面是一个关于在 dispatch_async 上如何以及何时使用不同的队列类型的快速指导：

自定义串行队列：当你想串行执行后台任务并追踪它时就是一个好选择。这消除了资源争用，因为你知道一次只有一个任务在执行。注意若你需要来自某个方法的数据，你必须内联另一个 Block 来找回它或考虑使用 dispatch_sync。
主队列（串行）：这是在一个并发队列上完成任务后更新 UI 的共同选择。要这样做，你将在一个 Block 内部编写另一个 Block 。以及，如果你在主队列调用 dispatch_async 到主队列，你能确保这个新任务将在当前方法完成后的某个时间执行。
并发队列：这是在后台执行非 UI 工作的共同选择。*
 
 
 /**
 *  dispatch_after
 */

- (void)showOrHideNavPrompt
{
    NSUInteger count = [[PhotoManager sharedManager] photos].count;
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
        if (!count) {
            [self.navigationItem setPrompt:@"Add photos with faces to Googlyify them!"];
        } else {
            [self.navigationItem setPrompt:nil];
        }
    });
}

/**你声明了一个变量指定要延迟的时长。
然后等待 delayInSeconds 给定的时长，再异步地添加一个 Block 到主线程。

dispatch_after 工作起来就像一个延迟版的 dispatch_async 。你依然不能控制实际的执行时间，且一旦 dispatch_after 返回也就不能再取消它。

不知道何时适合使用 dispatch_after ？

自定义串行队列：在一个自定义串行队列上使用 dispatch_after 要小心。你最好坚持使用主队列。
主队列（串行）：是使用 dispatch_after 的好选择；Xcode 提供了一个不错的自动完成模版。
并发队列：在并发队列上使用 dispatch_after 也要小心；你会这样做就比较罕见。还是在主队列做这些操作吧。
 */


/**
 *  dispatch_once()
 */
//dispatch_once() 以线程安全的方式执行且仅执行其代码块一次。试图访问临界区（即传递给 dispatch_once 的代码）的不同的线程会在临界区已有一个线程的情况下被阻塞，直到临界区完成为止。

//需要记住的是，这只是让访问共享实例线程安全。它绝对没有让类本身线程安全。类中可能还有其它竞态条件，例如任何操纵内部数据的情况。这些需要用其它方式来保证线程安全，例如同步访问数据

+ (instancetype)sharedManager
{
    static PhotoManager *sharedPhotoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPhotoManager = [[PhotoManager alloc] init];
        sharedPhotoManager->_photosArray = [NSMutableArray array];
    });
    return sharedPhotoManager;
}

/**
 *  Dispatch barriers
 */
@interface PhotoManager ()
@property (nonatomic,strong,readonly) NSMutableArray *photosArray;
@property (nonatomic, strong) dispatch_queue_t concurrentPhotoQueue; ///< Add this
@end
- (void)addPhoto:(Photo *)photo
{
    if (photo) { // 1
        //这个 Block 永远不会同时和其它 Block 一起在 concurrentPhotoQueue 中执行。
        dispatch_barrier_async(self.concurrentPhotoQueue, ^{ // 2
            [_photosArray addObject:photo]; // 3
            dispatch_async(dispatch_get_main_queue(), ^{ // 4
                [self postContentAddedNotification];
            });
        });
    }
}
//读者写者问题
//虽然许多线程可以同时读取 NSMutableArray 的一个实例而不会产生问题，但当一个线程正在读取时让另外一个线程修改数组就是不安全的。你的单例在目前的状况下不能预防这种情况的发生。
//这就是软件开发中经典的读者写者问题。GCD 通过用 dispatch barriers 创建一个读者写者锁 提供了一个优雅的解决方案。
//Dispatch barriers是一组函数，在并发队列上工作时扮演一个串行式的瓶颈。使用 GCD 的障碍（barrier）API 确保提交的 Block 在那个特定时间上是指定队列上唯一被执行的条目。这就意味着所有的先于调度障碍提交到队列的条目必能在这个 Block 执行前完成。

//当这个 Block 的时机到达，调度障碍执行这个 Block 并确保在那个时间里队列不会执行任何其它 Block 。一旦完成，队列就返回到它默认的实现状态。 GCD 提供了同步和异步两种障碍函数。

/**
 *  dispatch_sync
 */

- (NSArray *)photos
{
    __block NSArray *array; // 1
    dispatch_sync(self.concurrentPhotoQueue, ^{ // 2
        array = [NSArray arrayWithArray:_photosArray]; // 3
    });
    return array;
}
//什么时候用 dispatch_sync

/**自定义串行队列：在这个状况下要非常小心！如果你正运行在一个队列并调用 dispatch_sync 放在同一个队列，那你就百分百地创建了一个死锁。
主队列（串行）：同上面的理由一样，必须非常小心！这个状况同样有潜在的导致死锁的情况。
并发队列：这才是做同步工作的好选择，不论是通过调度障碍，或者需要等待一个任务完成才能执行进一步处理的情况。
 */

