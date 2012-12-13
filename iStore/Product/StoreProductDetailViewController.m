//
//  StoreProductDetailViewController.m
//  iStore
//
//  Created by 林世木 on 12/9/29.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "StoreProductDetailViewController.h"
#import "LoginViewController.h"
#import "JsonParseOperation.h"
#import "ProductDetailHeaderCell.h"
#import "ProductCommentCell.h"

#import "ProductCommentViewController.h"


@interface StoreProductDetailViewController ()

@end

@implementation StoreProductDetailViewController

- (id)initWithObject:(id)obj withProductId:(NSString *)value
{
    self = [super init];
    if (self) {
        mainObject = obj;
        productid = value;
        isCommentLogin = NO;
        refreshingComment = NO;
        totalComment = 0;
        commentPage = 0;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initNavBar];
    [self initView];
    
    operationQueue = [[NSOperationQueue alloc] init];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductDetail.do";
    
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",[ud objectForKey:@"userid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",[ud objectForKey:@"sessionid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"productid",@"key",productid,@"value", nil],
                                nil];
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(productFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
    
}

- (void)initView
{
    // Do any additional setup after loading the view.
    self.commentArray = [NSMutableArray array];
    
    CGRect tableRect = self.view.bounds;
    tableRect.size.height = tableRect.size.height - 44.0f- 50.0f;
    
    self.mTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mTableView];
    
}


- (void)productFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
   
       
        detailDic = [returnDic objectForKey:@"productdetail"];
        
        isFavorite = [self isFavoriteProduct:[detailDic objectForKey:@"isfav"]];

        [self refreshFavoriteStatus];
        
        [self.mTableView reloadData];
        
        //取得评论信息
        [self getProductComment];
    }
    
    
    
}

#pragma mark - comment

- (void)getProductComment
{
    if (refreshingComment) {
        return;
    }
    
    commentPage++;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductComment.do";
    
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",[ud objectForKey:@"userid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",[ud objectForKey:@"sessionid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"pageIndex",@"key",[NSString stringWithFormat:@"%d",commentPage],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"productid",@"key",productid,@"value", nil],
                                nil];
    NSLog(@"%@",[columnPostArray description]);
    
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(columnFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
}


- (void)columnFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@", returnDic);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        totalComment = [[returnDic objectForKey:@"commtotal"] integerValue];

        [self.commentArray addObjectsFromArray:[returnDic objectForKey:@"commlists"]];
        [self.mTableView reloadData];
    }
    
    refreshingComment = NO;
}

- (void)commentAction:(id)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"username"];
    if ([username length] == 0) {  //no login
        isCommentLogin = YES;
        [self openLoginView];
        return;
    }

    ProductCommentViewController *commentController = [[ProductCommentViewController alloc] initWithObject:self withProductId:[detailDic objectForKey:@"productid"]];
    [self.navigationController pushViewController:commentController animated:YES];
    
}



#pragma mark - favorite


- (BOOL)isFavoriteProduct:(NSString *)fav
{
    BOOL isFav = YES;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"username"];
    if ([username length] == 0) {  //还位登陆
       
        isFav = NO;
    }
    
    //已经登录网络获取收藏信息
    if ([fav isEqualToString:@"0"] == YES) {
        isFav = NO;
    }
    return isFav;
}

- (void)refreshFavoriteStatus
{
    if (isFavorite) {
        [favoriteButton setTitle:@"已收藏" forState:UIControlStateNormal];
        [favoriteButton addTarget:self action:@selector(deleteFavoriteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [favoriteButton setTitle:@"收藏" forState:UIControlStateNormal];
        [favoriteButton addTarget:self action:@selector(addFavoriteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)addFavoriteButtonAction
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"username"];
    if ([username length] == 0) {  //no login
        [self openLoginView];
        return;
    } 
    
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductFavorite.do";
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",[ud objectForKey:@"userid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",[ud objectForKey:@"sessionid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"productid",@"key",productid,@"value", nil],
                                nil];
    NSLog(@"%@",columnPostArray);
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(addFavoriteFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
}


- (void)addFavoriteFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        isFavorite = YES;
        [self refreshFavoriteStatus];
    } else {
        //初始化AlertView

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[returnDic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

    }
    
    
}

- (void)deleteFavoriteButtonAction
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"username"];
    if ([username length] == 0) {  //no login
        [self openLoginView];
        return;
    }

    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductFavoriteDelete.do";
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",[ud objectForKey:@"userid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",[ud objectForKey:@"sessionid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"productid",@"key",productid,@"value", nil],
                                nil];
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(deleteFavoriteFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
}


- (void)deleteFavoriteFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        isFavorite = NO;
        [self refreshFavoriteStatus];
    }
}



- (void)openLoginView
{
    LoginViewController *loginController = [[LoginViewController alloc] initWithObject:self];
    [self presentModalViewController:loginController animated:YES];

}

- (void)loginSuccessBack
{
    [self dismissModalViewControllerAnimated:YES];
    if (isCommentLogin) {
        isCommentLogin = NO;
        
        ProductCommentViewController *commentController = [[ProductCommentViewController alloc] initWithObject:self withProductId:[detailDic objectForKey:@"productid"]];
        [self.navigationController pushViewController:commentController animated:YES];
        
        return;
    }
    
    if (isFavorite) {
        [self deleteFavoriteButtonAction];
    } else {
        [self addFavoriteButtonAction];
    }
    
}



#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (totalComment <= [self.commentArray count]) {
        endCommentPage = YES;
        return totalComment;
    } else {
        endCommentPage = NO;
        return [self.commentArray count]+1;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        static NSString *CellHeaderIdentifier = @"DetailHeaderCell";
        ProductDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellHeaderIdentifier];
        if (cell == nil) {
            cell = [[ProductDetailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellHeaderIdentifier withObj:self];
        }
        
        NSURL *imageUrl = [NSURL URLWithString:[detailDic objectForKey:@"productmid"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        cell.productImageView.image = image;
        
        cell.nameLabel.text = [detailDic objectForKey:@"productname"];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"%@ 元",[detailDic objectForKey:@"price"]];
        
        cell.introLabel.text = [detailDic objectForKey:@"content"];
        
        return cell;
    }
    
    if ( indexPath.row == [self.commentArray count] && !endCommentPage) {
        static NSString *CellLoadingCommentIdentifier = @"CommentLoadCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellLoadingCommentIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellLoadingCommentIdentifier];
        }
        cell.textLabel.text = @"更多评论";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
        return cell;
    }
    
    static NSString *CellLoadingCommentIdentifier = @"CommentCell";
    ProductCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellLoadingCommentIdentifier];
    if (cell == nil) {
        cell = [[ProductCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellLoadingCommentIdentifier];
    }
    NSDictionary *itemDic = [self.commentArray objectAtIndex:indexPath.row];
    cell.commentLabel.text = [itemDic objectForKey:@"memo"];
    
    cell.commentTimeLabel.text = [itemDic objectForKey:@"time"];

    cell.usernameLabel.text = [itemDic objectForKey:@"username"];

        
    return cell;
    
    
    
//    UITableViewCell *cell;
//
//    NSInteger row = indexPath.row;
//    if (row == 0) { //展示图片
//        
//        cell = [[StoreProductImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier
//                                withObject:self
//                                withImageUrl:[detailDic objectForKey:@"productmid"]];
//        
//    } else if (row == 1) {
//        cell = [[StoreProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
//                        reuseIdentifier:CellIdentifier
//                            Productname:[detailDic objectForKey:@"productname"]
//                              Brandname:[detailDic objectForKey:@"brandname"]
//                             Columnname:[detailDic objectForKey:@"columnname"]
//                                  Price:[detailDic objectForKey:@"price"]
//                                Content:[detailDic objectForKey:@"content"]
//                                Addtime:[detailDic objectForKey:@"addtime"]];
//    } else if (row == 2) {
//        cell = [[StoreProductBuyCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                          reuseIdentifier:CellIdentifier
//                                               withObject:self];
//    } else if (row == 3) {
//       cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        
//        cell.textLabel.text = @"评价详情";
//    } else if (row == 4) {
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        
//        cell.textLabel.text = @"产品收藏";
//    }
//    
//    return cell;
    

}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 450.0f;
    } 
    return 60.0f;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 && indexPath.row == [self.commentArray count] && !endCommentPage) {
        [self getProductComment];
    }
    
}

#pragma mark - button action
- (void)buyButtonClicked
{
    
}








#pragma mark - other
- (void)initNavBar
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 5.0, 50.0, 35.0)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"bac_btn.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //收藏
    favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 5.0, 60.0, 35.0)];
    [favoriteButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:favoriteButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
