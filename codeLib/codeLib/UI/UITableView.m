//
//  UITableView.m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//  liufeng

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

