//
//  StoreHomeViewController.m
//  Demo1
//
//  Created by 林世木 on 12/9/19.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "StoreCategoryViewController.h"
#import "JsonParseOperation.h"
#import "StoreCategoryListViewController.h"
#import "StoreProductListViewController.h"

@interface StoreCategoryViewController ()

@end

@implementation StoreCategoryViewController

- (id)initWithObject:(id)obj
{
    self = [super init];
    if (self) {
        mainObject = obj;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavBar];
    
    //解析document目录
    operationQueue = [[NSOperationQueue alloc] init];
    
    // Do any additional setup after loading the view.
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
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteColumnLists.do";
    
    
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                               [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",[ud objectForKey:@"userid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",[ud objectForKey:@"sessionid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"colparentid",@"key",@"0",@"value", nil],
                                nil];
    
    NSLog(@"%@",columnPostArray);
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(columnFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
}

- (void)columnFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        
        if (self.page >1 ) {
            [self.mTableView tableViewDidFinishedLoadingWithMessage:@"All loaded!"];
            self.mTableView.reachedTheEnd  = YES;
            return;
        }
        
        [self.listItemArray addObjectsFromArray:[returnDic objectForKey:@"columnlists"]];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *itemDic = [self.listItemArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [itemDic objectForKey:@"columnname"];

    NSURL *imageUrl = [NSURL URLWithString:[itemDic objectForKey:@"columnsmall"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    cell.imageView.image = image;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemDic = [self.listItemArray objectAtIndex:indexPath.row];
    NSString *colhavechildren = [itemDic objectForKey:@"colhavechildren"];
    if ([colhavechildren integerValue] == 0) {
        StoreProductListViewController *productListController = [[StoreProductListViewController alloc] initWithObject:self withColumnid:[itemDic objectForKey:@"columnid"]];
        [self.navigationController pushViewController:productListController animated:YES];
    } else {
        StoreCategoryListViewController *categoryListController = [[StoreCategoryListViewController alloc] initWithObject:self withColparentid:[itemDic objectForKey:@"columnid"]];
        [self.navigationController pushViewController:categoryListController animated:YES];
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
