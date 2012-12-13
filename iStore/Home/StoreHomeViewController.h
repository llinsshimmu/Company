//
//  StoreHomeViewController.h
//  Demo1
//
//  Created by 林世木 on 12/9/19.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToolBarOpaque.h"

@interface StoreHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    id mainObject;

   

}

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSArray *listItemArray;
- (id)initWithObject:(id)obj;


@end
