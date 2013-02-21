//
//  ViewController.m
//  sqlitedemo
//
//  Created by oo on 12-11-28.
//  Copyright (c) 2012年 oo. All rights reserved.
//

#import "ViewController.h"
#import "sqlite3.h"
#import "myViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize studentId;
@synthesize studentName;
@synthesize studentClass;
@synthesize listData;
@synthesize listData1;
@synthesize a;
-(NSString *)dataFilePath {
    NSArray * myPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,
                                                             NSUserDomainMask, YES); NSString * myDocPath = [myPaths objectAtIndex:0];
    NSString *filename = [myDocPath stringByAppendingPathComponent:DATA_FILE];
    return filename;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *SimpleCellIdentifier = @"SimpleCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleCellIdentifier];
    
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									   reuseIdentifier:SimpleCellIdentifier] autorelease];
	}
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [listData objectAtIndex:row];
    //cell.detailTextLabel.text = [listData1 objectAtIndex:row];
	return cell;
    
}

#pragma mark -- 实现TableView委托方法
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //	NSUInteger row = [indexPath row];
    //	NSString *rowValue = [listData objectAtIndex:row];
    //	NSString *message = [[NSString alloc] initWithFormat:@"你选择了%@队。", rowValue];
    //
    //	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"行选择"
    //                                                   message:message
    //                                                  delegate:self
    //                                         cancelButtonTitle:@"Ok"
    //                                         otherButtonTitles:nil];
    //	[message release];
    //	[alert show];
    //	[alert release];
    //	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myViewController * my=[[myViewController alloc]initWithNibName:@"myViewController" bundle:nil];
    
    
    my.image=[self getImage];
    [self presentModalViewController:my animated:YES];
    
    
    
}
-(UIImage*)getImage{
     NSString *filename = [self dataFilePath];
    UIImage*image=nil;
    if (sqlite3_open([filename UTF8String], &db) == SQLITE_OK){
      //  const char *sqlStatement="select studentImage from student where studentId=1";
        NSString * sqlstr=[NSString stringWithFormat:@"select studentImage from student where studentId=%@",self.studentId.text];
        sqlite3_stmt *compliedStatement;
        if(sqlite3_prepare(db, [sqlstr UTF8String], -1, &compliedStatement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(compliedStatement)==SQLITE_ROW) {
                int bytes = sqlite3_column_bytes(compliedStatement, 0);
                const void *value = sqlite3_column_blob(compliedStatement, 0);
                if( value != NULL && bytes != 0 ){
                    NSData *data = [NSData dataWithBytes:value length:bytes];
                    NSLog(@"imaga data =%d",[data length]);
                    image=[UIImage imageWithData:data];
                }}
        }
    }
        return image;
        
}
-(void)writeImage{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@”sqlite.sqlite”];
//
    NSString *filename = [self dataFilePath];

    NSData *image=UIImagePNGRepresentation([UIImage imageNamed:@"sun.png"]);
    NSString *aaa=[[NSString alloc]initWithFormat:@"update student set studentImage=? where studentId=1″"];
    
    
    
    if (sqlite3_open([filename UTF8String], &db) == SQLITE_OK){
        sqlite3_stmt * compliedStatement;
        sqlite3_prepare(db,[aaa UTF8String],-1,&compliedStatement,0);
        sqlite3_bind_blob(compliedStatement, 1, [image bytes], [image length], NULL);
        int result=sqlite3_step(compliedStatement);
        if (result==SQLITE_DONE) {
        }
        sqlite3_finalize(compliedStatement);
        
    }
    sqlite3_close(db);
    [aaa release];
}

//--------
-(NSMutableArray*)selectAll
{
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:nil];;
	NSString *filename = [self dataFilePath];
	NSLog(@"%@",filename);
	if (sqlite3_open([filename UTF8String], &db) != SQLITE_OK) {
		sqlite3_close(db);
		NSAssert(NO,@"数据库打开失败。");
	} else {
		
		NSString *qsql = [NSString stringWithFormat: @"SELECT %@ FROM %@", FIELDS_NAME_SID, TABLE_NAME];
		NSLog(@"%@",qsql);
		sqlite3_stmt *statement;
		//预处理过程
		if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			//绑定参数开始
			sqlite3_bind_text(statement, 1, [studentId.text UTF8String], -1, NULL);
			
			//执行
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *field1 = (char *) sqlite3_column_text(statement, 0);
				NSString *field1Str = [[NSString alloc] initWithUTF8String: field1];
				//studentId.text = field1Str;
				//[field1Str release];
                [list addObject:field1Str];
                NSLog(@"%d",list.count);
                
			}
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(db);
		
	}
    return list;
}

-(NSMutableArray*)selectAll1
{
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:nil];;
	NSString *filename = [self dataFilePath];
	
	if (sqlite3_open([filename UTF8String], &db) != SQLITE_OK) {
		sqlite3_close(db);
		NSAssert(NO,@"数据库打开失败。");
	} else {
		
		NSString *qsql = [NSString stringWithFormat: @"SELECT %@ FROM %@", FIELDS_NAME_SNAME, TABLE_NAME];
		NSLog(@"%@",qsql);
		sqlite3_stmt *statement;
		//预处理过程
		if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			//绑定参数开始
			sqlite3_bind_text(statement, 1, [studentId.text UTF8String], -1, NULL);
			
			//执行
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *field1 = (char *) sqlite3_column_text(statement, 0);
				NSString *field1Str = [[NSString alloc] initWithUTF8String: field1];
				//studentId.text = field1Str;
				//[field1Str release];
                [list addObject:field1Str];
                NSLog(@"%d",list.count);
                
			}
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(db);
		
	}
    return list;
}
//-------
- (void)viewDidLoad
{
    [super viewDidLoad];
   // NSArray *array = [[NSArray alloc] initWithObjects:@"今天下午2:00开会",@"今天晚上12:00世界杯",nil];
    
   // NSMutableArray *array = [self selectAll];
    //NSMutableArray *array1 = [self selectAll1];
    
   
    
    
    
	self.listData = [[NSMutableArray alloc]initWithCapacity:0];
    self.listData1 = [[NSMutableArray alloc]initWithCapacity:0];
	NSString *filename = [self dataFilePath];
	
	if (sqlite3_open([filename UTF8String], &db) != SQLITE_OK) {
		sqlite3_close(db);
		NSAssert(NO,@"数据库打开失败。");
	} else {
		char *err;
		NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT, studentImage BLOB)" ,
							   TABLE_NAME,FIELDS_NAME_SID,FIELDS_NAME_SNAME,FIELDS_NAME_SCLASS];
        NSLog(@"cretae table %@",createSQL);
		if (sqlite3_exec(db,[createSQL UTF8String],NULL,NULL,&err) != SQLITE_OK) {
			sqlite3_close(db);
			//NSAssert1(NO, @"建表失败, %@", err);
		}
		sqlite3_close(db);
	}
    
    
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.a.bounds.size.height, self.view.frame.size.width, self.a.bounds.size.height)];
        
        view.delegate = self;
        [self.a addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(IBAction)textFieldDoneEditing:(id)sender
{
    //[sender resignFirstResponder];
}

-(IBAction) save {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"sun" ofType:@"png"];
    UIImage * iamges=[UIImage imageWithContentsOfFile:filePath];
   // NSData *imgData=UIImagePNGRepresentation([UIImage imageNamed:@"sun.png"]);
    UIGraphicsBeginImageContext(iamges.size);
    
    NSData *imgData=UIImagePNGRepresentation(iamges);
    UIGraphicsEndImageContext();
    
	NSString *filename = [self dataFilePath];
	
	if (sqlite3_open([filename UTF8String], &db) != SQLITE_OK) {
		sqlite3_close(db);
		NSAssert(NO,@"数据库打开失败。");
	} else {
		
		NSString *sqlStr = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@ ,studentImage) VALUES (?,?,?,?)",
							TABLE_NAME, FIELDS_NAME_SID, FIELDS_NAME_SNAME, FIELDS_NAME_SCLASS];
        
		
		sqlite3_stmt *statement;
       
        NSLog(@"imageData lenth%d",[imgData length]);
		//预处理过程
        NSLog(@"  %d",sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL));
		if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			//绑定参数开始
			sqlite3_bind_text(statement, 1, [studentId.text UTF8String], -1, NULL);
			sqlite3_bind_text(statement, 2, [studentName.text UTF8String], -1, NULL);
			sqlite3_bind_text(statement, 3, [studentClass.text UTF8String], -1, NULL);
			sqlite3_bind_blob(statement, 4, [imgData bytes], [imgData length], NULL);
			
			//执行插入
           // NSLog(@" 插入返回代码 %d",sqlite3_step(statement));
			if (sqlite3_step(statement) != SQLITE_DONE) {
				NSAssert(0, @"插入数据失败。");
			}
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(db);
		
	}
	
	
}

-(IBAction) load {
	NSString *filename = [self dataFilePath];
	
	if (sqlite3_open([filename UTF8String], &db) != SQLITE_OK) {
		sqlite3_close(db);
		NSAssert(NO,@"数据库打开失败。");
	} else {
		
		NSString *qsql = [NSString stringWithFormat: @"SELECT %@,%@,%@ FROM %@ where %@ = ?", FIELDS_NAME_SID, FIELDS_NAME_SNAME, FIELDS_NAME_SCLASS, TABLE_NAME,FIELDS_NAME_SID];
		NSLog(@"%@",qsql);
		sqlite3_stmt *statement;
        NSLog(@"std id =%@",studentId.text);
		//预处理过程
		if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			//绑定参数开始
			sqlite3_bind_text(statement, 1, [studentId.text UTF8String], -1, NULL);
			
			//执行
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *field1 = (char *) sqlite3_column_text(statement, 0);
				NSString *field1Str = [[NSString alloc] initWithUTF8String: field1];
				studentId.text = field1Str;
				
				char *field2 = (char *) sqlite3_column_text(statement, 1);
				NSString *field2Str = [[NSString alloc] initWithUTF8String: field2];
				studentName.text = field2Str;
				
				char *field3 = (char *) sqlite3_column_text(statement, 2);
				NSString *field3Str = [[NSString alloc] initWithUTF8String: field3];
				studentClass.text = field3Str;
                [self.listData addObject:studentClass.text];
				NSLog(@"student class =%@",studentClass.text);
				[field1Str release];
				[field2Str release];
				[field3Str release];
			}
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(db);
		
	}
    [self.a reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-----
-(void)reloadTableViewDataSource
{
    NSLog(@"==开始加载数据");
    NSMutableArray *array = [self selectAll];
    NSMutableArray *array1 = [self selectAll1];
    
    NSLog(@"%d",array.count);
    
    
    
	self.listData = array;
    self.listData1 = array1;
    
    [self.a reloadData];
    _reloading = YES;

    
}
- (void)doneLoadingTableViewData{
    
    NSLog(@"===加载完数据");
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.a];
    
    
}
#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
    
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}
@end
