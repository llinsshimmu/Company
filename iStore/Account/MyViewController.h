//
//  MyViewController.h
//  iStore
//
//  Created by 林世木 on 12/9/29.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    id mainObj;
    NSString *sessionId;	//会话ID
    NSString *userId;		//会员ID
}

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSArray *listItemArray;
- (id)initWithObject:(id)obj;

@end
