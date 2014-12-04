//
//  searchTableViewController.h
//  XinNet
//
//  Created by YY on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSString *titleStr;
@property(nonatomic)NSInteger searchSelectedIndex;
@property(nonatomic,retain)NSString *keyWordesIndex;
@property(nonatomic,retain)NSString *allIndex;
@property(nonatomic,strong)UITableView *tableView;
@end
