//
//  StoreHomeViewController.h
//  Demo1
//
//  Created by 林世木 on 12/9/19.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"


@interface StoreCategoryViewController : UIViewController<PullingRefreshTableViewDelegate,
UITableViewDataSource,UITableViewDelegate>{
    id mainObject;
    
   
    
    
    NSOperationQueue *operationQueue;
    

}

@property (strong,nonatomic) PullingRefreshTableView *mTableView;
@property (nonatomic) BOOL refreshing;
@property (nonatomic) NSInteger page;

@property (nonatomic,strong) NSMutableArray *listItemArray;

- (id)initWithObject:(id)obj;


@end
