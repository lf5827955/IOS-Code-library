//
//  Sqlite.m
//  codeLib
//
//  Created by ftxbird on 14-6-7.
//  Copyright (c) 2014年 ftxbird. All rights reserved.
//
// 0.获得沙盒中的数据库文件名
NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"student.sqlite"];

// 1.创建(打开)数据库（如果数据库文件不存在，会自动创建）
int result = sqlite3_open(filename.UTF8String, &_db);
if (result == SQLITE_OK) {
    NSLog(@"成功打开数据库");
    
    // 2.创表
    const char *sql = "create table if not exists t_student (id integer primary key autoincrement, name text, age integer);";
    char *errorMesg = NULL;
    int result = sqlite3_exec(_db, sql, NULL, NULL, &errorMesg);
    if (result == SQLITE_OK) {
        NSLog(@"成功创建t_student表");
    } else {
        NSLog(@"创建t_student表失败:%s", errorMesg);
    }
} else {
    NSLog(@"打开数据库失败");
}
}

/**
 *  插入
 */
- (IBAction)insert
{
    for (int i = 0; i<30; i++) {
        NSString *name = [NSString stringWithFormat:@"Jack-%d", arc4random()%100];
        int age = arc4random()%100;
        NSString *sql = [NSString stringWithFormat:@"insert into t_student (name, age) values('%@', %d);", name, age];
        
        char *errorMesg = NULL;
        int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMesg);
        if (result == SQLITE_OK) {
            NSLog(@"成功添加数据");
        } else {
            NSLog(@"添加数据失败:%s", errorMesg);
        }
    }
}
/**
 *  查询
 */
- (IBAction)query
{
    // SQL注入漏洞
    
    /**
     登录功能
     
     1.用户输入账号和密码
     * 账号：123' or 1 = 1 or '' = '
     * 密码：456654679
     
     2.拿到用户输入的账号和密码去数据库查询（查询有没有这个用户名和密码）
     select * from t_user where username = '123' and password = '456';
     
     
     select * from t_user where username = '123' and password = '456';
     */
    
    // 1.定义sql语句
    const char *sql = "select id, name, age from t_student where name = ?;";
    
    // 2.定义一个stmt存放结果集
    sqlite3_stmt *stmt = NULL;
    
    // 3.检测SQL语句的合法性
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"查询语句是合法的");
        
        // 设置占位符的内容
        sqlite3_bind_text(stmt, 1, "jack", -1, NULL);
        
        // 4.执行SQL语句，从结果集中取出数据
        //        int stepResult = sqlite3_step(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) { // 真的查询到一行数据
            // 获得这行对应的数据
            
            // 获得第0列的id
            int sid = sqlite3_column_int(stmt, 0);
            
            // 获得第1列的name
            const unsigned char *sname = sqlite3_column_text(stmt, 1);
            
            // 获得第2列的age
            int sage = sqlite3_column_int(stmt, 2);
            
            NSLog(@"%d %s %d", sid, sname, sage);
        }
    } else {
        NSLog(@"查询语句非合法");
    }
}

/**
 *  SQL语句 批量插入
 */
NSMutableString *sql = [NSMutableString string];

NSArray *names = @[@"jack", @"rose", @"jim", @"jake"];

for (int i = 0; i<100; i++) {
    int index = arc4random()%names.count;
    NSString *namePre = names[index];
    
    NSString *name = [NSString stringWithFormat:@"%@-%d", namePre, arc4random()%100];
    int age = arc4random() % 100;
    double score = arc4random() % 100;
    [sql appendFormat:@"insert into t_student (name, age, score) values('%@', %d, %f);\n", name, age, score];
}

[sql writeToFile:@"/Users/aplle/Desktop/student.sql" atomically:YES encoding:NSUTF8StringEncoding error:nil];
