//
//  ProductFavoriteListsViewController.m
//  iStore
//
//  Created by 林世木 on 12/10/15.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "ProductFavoriteListsViewController.h"
#import "JsonParseOperation.h"
#import "MyFavoriteCell.h"
#import "StoreProductDetailViewController.h"


@interface ProductFavoriteListsViewController ()

@end

@implementation ProductFavoriteListsViewController

- (id)initWithObject:(id)obj withSessionId:(NSString *)session withUserId:(NSString *)user
{
    self = [super init];
    if (self) {
        mainObject = obj;
        sessionId = session;
        userId = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavBar];
    
    operationQueue = [[NSOperationQueue alloc] init];
    self.listItemArray = [[NSMutableArray alloc] init];
    
    CGRect bounds = self.view.bounds;
    bounds.size.height -= 44.0f;
    self.mTableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    [self.view addSubview:self.mTableView];
    
    
    
    if (self.page == 0) {
        [self.mTableView launchRefreshing];
    }
}

#pragma mark - ReloadData
- (void)reloadCategory
{
    self.page++;
    if (self.refreshing) {
        self.page = 1;
        self.refreshing = NO;
        [self.listItemArray removeAllObjects];
    } else {
        if (self.page > pageTotal) {
            [self.mTableView tableViewDidFinishedLoadingWithMessage:@"All loaded!"];
            self.mTableView.reachedTheEnd  = YES;
            return;
        }
    }
    
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductFavoriteLists.do";
    
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",userId,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",sessionId,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"pageIndex",@"key",[NSString stringWithFormat:@"%d",self.page],@"value", nil],
                                nil];
    NSLog(@"%@",[columnPostArray description]);
    
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(columnFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
}

- (void)columnFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        NSInteger productTotal = [[returnDic objectForKey:@"favtotal"] integerValue];
        if (productTotal%10 == 0) {
            pageTotal = productTotal/10;
        } else {
            pageTotal = productTotal/10 + 1;
        }
        
        
        [self.listItemArray addObjectsFromArray:[returnDic objectForKey:@"favoritelists"]];
        [self.mTableView tableViewDidFinishedLoading];
        self.mTableView.reachedTheEnd  = NO;
        [self.mTableView reloadData];
        
        NSLog(@"%@",[self.listItemArray description]);
        
    }
    
}

#pragma mark - delete favorite
- (void)deleteFavorite:(NSString *)productid
{
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductFavoriteDelete.do";
    
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",userId,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",sessionId,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"productid",@"key",productid,@"value", nil],
                                nil];
    
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(delFavoriteFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
}

- (void)delFavoriteFeedBackResult:(NSDictionary *)returnDic
{
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
       
        
    }
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyFavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *itemDic = [self.listItemArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [itemDic objectForKey:@"productname"];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    NSURL *imageUrl = [NSURL URLWithString:[itemDic objectForKey:@"productsmall"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    cell.imageView.image = image;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemDic = [self.listItemArray objectAtIndex:indexPath.row];
    StoreProductDetailViewController *productDetailController = [[StoreProductDetailViewController alloc] initWithObject:self withProductId:[itemDic objectForKey:@"productid"]];
    [self.navigationController pushViewController:productDetailController animated:YES];
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(editingStyle == UITableViewCellEditingStyleDelete)
	{
        NSDictionary *itemDic = [self.listItemArray objectAtIndex:indexPath.row];
        [self deleteFavorite:[itemDic objectForKey:@"productid"]];
        
        [self.listItemArray removeObjectAtIndex:indexPath.row];
        
        [self.mTableView reloadData];
        
	}
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(reloadCategory) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [df dateFromString:@"2012-05-03 10:10"];
    return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(reloadCategory) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.mTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.mTableView tableViewDidEndDragging:scrollView];
}

#pragma mark - other
- (void)initNavBar
{
    self.navigationItem.title = @"我的收藏";
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 5.0, 50.0, 35.0)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"bac_btn.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //收藏
    editButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 5.0, 50.0, 35.0)];
    [editButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)editAction
{
    [self.mTableView setEditing:YES animated:YES];

    [editButton setTitle:@"取消" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(cancelEditAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelEditAction
{
    [self.mTableView setEditing:NO animated:YES];

    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
