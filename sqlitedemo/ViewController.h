//
//  ViewController.h
//  sqlitedemo
//
//  Created by oo on 12-11-28.
//  Copyright (c) 2012年 oo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "EGORefreshTableHeaderView.h"
#define DATA_FILE @"afile.sqlite"
#define TABLE_NAME @"student"
#define FIELDS_NAME_SID @"studentId"
#define FIELDS_NAME_SNAME @"studentName"
#define FIELDS_NAME_SCLASS @"studentClass"
@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,
UIScrollViewDelegate,EGORefreshTableHeaderDelegate>
{
    NSMutableArray *listData;
    NSMutableArray *listdata1;
    UITextField *studentId;
    UITextField *studentName;
    UITextField *studentClass;
    sqlite3 *db;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    UITableView *a;
}
@property (nonatomic,retain) IBOutlet UITableView *a;
@property (nonatomic, retain) IBOutlet UITextField *studentId;
@property (nonatomic, retain) IBOutlet UITextField *studentName;
@property (nonatomic, retain) IBOutlet UITextField *studentClass;
@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) NSMutableArray *listData1;
-(IBAction) save;
-(IBAction) load;
-(IBAction)textFieldDoneEditing:(id)sender;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData; 
-(NSString *)dataFilePath;
@end
