//
//  MoreViewController.h
//  iStore
//
//  Created by 林世木 on 12/9/29.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    id mainObject;

}

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSArray *moreItemArray;

- (id)initWithObject:(id)obj;


@end
