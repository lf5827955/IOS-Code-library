//
//  UITableView.m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//  liufeng

//-------------------------------代理方法开始----------------------------//

/**
 *  cell显示前调用
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  组头部标题显示前调用
 */
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

/**
 *  组尾部标题显示前调用
 */
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

/**
 *  指定的cell已经移出显示视图
 */
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);

/**
 *  指定的组头部标题已经移出显示视图。
 */
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

/**
 *  指定的组尾部标题已经移出显示视图。
 */
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

/**
 *  设置indexPath对应的cell的行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  设置section的头部行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

/**
 *  设置section的尾部行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

/**
 *  估算cell的高度 如果不知道一个cell的大小，返回UITableViewAutomaticDimension即可
 *  只是大概估计  实际cell的高度以heightForRowAtIndexPath方法返回值为准  为提高性能  
 *  ios7出的新特性   后面俩个方法同理
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0);
/**
 *  估算section的头部行高
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);
/**
 *  估算section的尾部行高
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);

/**
 *  设置第section组的头部显示什么样的自定义View
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

/**
 *  设置第section组的尾部显示什么样的自定义View
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

/**
 *  点击了右边附件View调用
 */
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  通知代理是否开启点击高亮显示，YES为显示
 */
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);

/**
 *  通知代理indexPath行被高亮显示
 */
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);

/**
 *  通知代理指定行不在高亮显示，一般是点击其他行的时候。
 */
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);

/**
 *  通知代理指定行即将被选中
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  通知代理指定行即将取消选中
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);

/**
 *  通知代理选中了哪一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  通知代理取消选中了哪一行
 */
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);

/**
 *  对当前行设置编辑模式，删除、插入或者不可编辑
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  在删除模式启动下，改变每行删除按钮的文字（默认为“Delete”）
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);

/**
 *  编辑模式下是否需要对cell指进行缩进，NO为关闭缩进，这个方法可以用来去掉移动时cell前面的空白
 */
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  indexPath行cell即将进入编辑模式
 */
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  indexPath行cell完成编辑
 */
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  移动行的过程中会多次调用此方法，返回值代表进行移动操作后回到的行，如果设置为当前行，则不论怎么移动都会回到当前行。
 */
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

/**
 *  设置Cell行缩进量
 */
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  允许长按菜单(复制粘贴功能要使用到这个方法)
 */
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0);

/**
 *  //每个cell都可以点击出现Menu菜单
 */
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender NS_AVAILABLE_IOS(5_0);

/**
 *  捕获选择项：根据用户实际上从快捷菜单中选定的项目，做相应的操作
 */
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender NS_AVAILABLE_IOS(5_0);
//-------------------------------代理方法结束----------------------------//



//-------------------------------数据源方法开始----------------------------//

/**
 *  返回指定组(section)中有多少条记录
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 *  返回indexPath 这行的显示什么样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  共有多少组数据  默认是一组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

/**
 *  返回每一组的头部标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

/**
 *  返回每一组的尾部标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

/**
 *  设置cell是否可以编辑
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  设置cell是否可以移动
 */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  右侧索引数组(如果不实现 就不显示右侧索引)  类似"ABCD...Z"
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;

/**
 *  点击右侧索引时调用
 */
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

/**
 *  设置删除时编辑状态
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 开始移动cell是调用
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

//-------------------------------数据源方法结束----------------------------//

