//
//  ProductFavoriteListsViewController.h
//  iStore
//
//  Created by 林世木 on 12/10/15.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface ProductFavoriteListsViewController : UIViewController<PullingRefreshTableViewDelegate,
UITableViewDataSource,UITableViewDelegate>{
    id mainObject;
    
    NSString *sessionId;	//会话ID
    NSString *userId;		//会员ID
    
    UIButton *editButton;

    
    NSOperationQueue *operationQueue;
    
    NSInteger pageTotal;
    
}

@property (strong,nonatomic) PullingRefreshTableView *mTableView;
@property (nonatomic) BOOL refreshing;
@property (nonatomic) NSInteger page;

@property (nonatomic,strong) NSMutableArray *listItemArray;

- (id)initWithObject:(id)obj withSessionId:(NSString *)session withUserId:(NSString *)user;


@end
