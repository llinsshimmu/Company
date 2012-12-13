//
//  StoreProductListViewController.m
//  iStore
//
//  Created by 林世木 on 12/9/29.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "StoreProductListViewController.h"
#import "JsonParseOperation.h"
#import "StoreProductDetailViewController.h"
#import "StoreProductListCell.h"

@interface StoreProductListViewController ()

@end

@implementation StoreProductListViewController

- (id)initWithObject:(id)obj withColumnid:(NSString *)value;
{
    self = [super init];
    if (self) {
        mainObject = obj;
        columnid = value;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavBar];
    
    operationQueue = [[NSOperationQueue alloc] init];
    
    self.listItemArray = [[NSMutableArray alloc] init];
    
    
	// Do any additional setup after loading the view.
    CGRect bounds = self.view.bounds;
    bounds.size.height -= 44.0f;
    self.mTableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    [self.view addSubview:self.mTableView];
    
    
    
    //解析document目录
    operationQueue = [[NSOperationQueue alloc] init];
    
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
    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductLists.do";
    
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",[ud objectForKey:@"userid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",[ud objectForKey:@"sessionid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"pageIndex",@"key",[NSString stringWithFormat:@"%d",self.page],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"columnid",@"key",columnid,@"value", nil],
                                nil];
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(columnFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
}

- (void)columnFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        NSInteger productTotal = [[returnDic objectForKey:@"producttotal"] integerValue];
        if (productTotal%10 == 0) {
            pageTotal = productTotal/10;
        } else {
            pageTotal = productTotal/10 + 1;
        }
        
        
        [self.listItemArray addObjectsFromArray:[returnDic objectForKey:@"productlists"]];
        [self.mTableView tableViewDidFinishedLoading];
        self.mTableView.reachedTheEnd  = NO;
        [self.mTableView reloadData];
        
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
    StoreProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StoreProductListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *itemDic = [self.listItemArray objectAtIndex:indexPath.row];
    
    
    cell.nameLabel.text = [itemDic objectForKey:@"productname"];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"价格: %@", [itemDic objectForKey:@"price"]];
    cell.introLabel.text = [itemDic objectForKey:@"memo"];
    
    //    NSLog(@"%@",[itemDic objectForKey:@"columnsmall"]);
    NSURL *imageUrl = [NSURL URLWithString:[itemDic objectForKey:@"productsmall"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    cell.productImageView.image = image;
    
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemDic = [self.listItemArray objectAtIndex:indexPath.row];
    StoreProductDetailViewController *productDetailController = [[StoreProductDetailViewController alloc] initWithObject:self withProductId:[itemDic objectForKey:@"productid"]];
    [self.navigationController pushViewController:productDetailController animated:YES];
    
    //    StoreCategorySubViewController *detailController = [[StoreCategorySubViewController alloc] initWithObject:storeObject isiPad:isiPad cidValue:[[itemDic objectForKey:@"cid"] integerValue]];
    //    detailController.listItemArray = [itemDic objectForKey:@"desc"];
    
    //    [self.navigationController pushViewController:detailController animated:YES];
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
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
