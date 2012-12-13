//
//  MoreViewController.m
//  iStore
//
//  Created by 林世木 on 12/9/29.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "MoreViewController.h"
#import "StoreCategoryViewController.h"
#import "StoreSearchViewController.h"


@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithObject:(id)obj
{
    self = [super init];
    if (self) {
        mainObject = obj;
        
        //工具栏，当前选项卡
        UITabBarItem *tab = [[UITabBarItem alloc]
                             initWithTitle:@""
                             image:[UIImage imageNamed:@"more_tab.png"]
                             tag:1];
        self.tabBarItem = tab;
        self.navigationItem.title = @"更多";

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.moreItemArray = [NSArray arrayWithObjects:@"类别",@"搜索",@"使用帮助", @"关于",nil];
    
    self.mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.moreItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.moreItemArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        StoreCategoryViewController *categoryController = [[StoreCategoryViewController alloc] initWithObject:self];
        [self.navigationController pushViewController:categoryController animated:YES];


    } else if(row == 1) {
        //
        StoreSearchViewController *searchController = [[StoreSearchViewController alloc] initWithObject:self];
        [self.navigationController pushViewController:searchController animated:YES];
    }
    
     
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
