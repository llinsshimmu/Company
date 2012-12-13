//
//  ProductMemberCommentViewController.m
//  iStore
//
//  Created by 林世木 on 12/10/15.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "ProductMemberCommentViewController.h"
#import "JsonParseOperation.h"
#import "MemberProductCommentCell.h"

@interface ProductMemberCommentViewController ()

@end

@implementation ProductMemberCommentViewController

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
    
    operationQueue = [[NSOperationQueue alloc] init];
    self.listItemArray = [[NSMutableArray alloc] init];
    
    [self initNavBar];
    
    CGRect bounds = self.view.bounds;
    bounds.size.height -= 88.0f;
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
    
    
    
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductMemberComment.do";
    
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",userId,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",sessionId,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"pageIndex",@"key",[NSString stringWithFormat:@"%d",self.page],@"value", nil],
                                nil];
//    NSLog(@"%@",[columnPostArray description]);
    
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(columnFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
}

- (void)columnFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        NSInteger productTotal = [[returnDic objectForKey:@"commtotal"] integerValue];
        if (productTotal%10 == 0) {
            pageTotal = productTotal/10;
        } else {
            pageTotal = productTotal/10 + 1;
        }
        
        
        [self.listItemArray addObjectsFromArray:[returnDic objectForKey:@"commlists"]];
        [self.mTableView tableViewDidFinishedLoading];
        self.mTableView.reachedTheEnd  = NO;
        [self.mTableView reloadData];
        
        NSLog(@"%@",[self.listItemArray description]);
        
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
    MemberProductCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MemberProductCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *itemDic = [self.listItemArray objectAtIndex:indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:[itemDic objectForKey:@"productsmall"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    cell.imageView.image = image;
    
    cell.textLabel.text = [itemDic objectForKey:@"memo"];
    cell.detailTextLabel.text = [itemDic objectForKey:@"time"];
    
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary *itemDic = [self.listItemArray objectAtIndex:indexPath.row];
    //    StoreProductDetailViewController *productDetailController = [[StoreProductDetailViewController alloc] initWithObject:self withProductId:[itemDic objectForKey:@"productid"]];
    //    [self.navigationController pushViewController:productDetailController animated:YES];
    
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
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
    self.navigationItem.title = @"我的评论";

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 5.0, 50.0, 35.0)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"bac_btn.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    
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
