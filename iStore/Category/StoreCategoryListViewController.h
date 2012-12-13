//
//  StoreCategoryListViewController.h
//  iStore
//
//  Created by 林世木 on 12/9/29.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"


@interface StoreCategoryListViewController : UIViewController<PullingRefreshTableViewDelegate,
UITableViewDataSource,UITableViewDelegate>{
    id mainObject;

    NSOperationQueue *operationQueue;

    UIBarButtonItem *rightBarButtonItem;

    

    
    NSString *colparentid;

}

@property (strong,nonatomic) PullingRefreshTableView *mTableView;
@property (nonatomic) BOOL refreshing;
@property (nonatomic) NSInteger page;

@property (nonatomic,strong) NSMutableArray *listItemArray;

- (id)initWithObject:(id)obj withColparentid:(NSString *)value;

@end
