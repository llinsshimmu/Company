//
//  StoreProductDetailViewController.h
//  iStore
//
//  Created by 林世木 on 12/9/29.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToolBarOpaque.h"

@interface StoreProductDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    id mainObject;
    
    NSOperationQueue *operationQueue;
    
    UIButton *favoriteButton;

    NSString *productid;
    
    NSDictionary *detailDic;
    
    BOOL isFavorite;
    
    //评论
    NSInteger totalComment;
    NSInteger commentPage;
    BOOL refreshingComment;
    BOOL isCommentLogin;
    BOOL endCommentPage;
 
}

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *commentArray;

- (id)initWithObject:(id)obj withProductId:(NSString *)value;


@end
