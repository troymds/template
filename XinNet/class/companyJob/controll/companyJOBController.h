//
//  companyJOBController.h
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface companyJOBController : UIViewController{
    UITableView *_tableView;

}
@property(nonatomic,copy)NSString *company_id;
@property(nonatomic,strong)UITableView *tableView;
@end
