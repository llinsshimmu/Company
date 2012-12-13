//
//  MyViewController.m
//  iStore
//
//  Created by 林世木 on 12/9/29.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "MyViewController.h"
#import "ProductMemberCommentViewController.h"
#import "ProductFavoriteListsViewController.h"
#import "ModifyPasswordViewController.h"
#import "ModifyUserinfoViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (id)initWithObject:(id)obj
{
    if (self = [super init]) {
        // Custom initialization
        //工具栏，当前选项卡
        UITabBarItem *tab = [[UITabBarItem alloc]
                             initWithTitle:@""
                             image:[UIImage imageNamed:@"my_tab.png"]
                             tag:4];
        self.tabBarItem = tab;
        
        mainObj = obj;
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //收藏
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 5.0, 50.0, 35.0)];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
    [logoutButton setTitle:@"注销" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"username"];
    userId = [ud objectForKey:@"userid"];
    sessionId = [ud objectForKey:@"sessionid"];
    
    self.navigationItem.title = username;
    
    // Do any additional setup after loading the view.
    self.listItemArray = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:@"我的收藏",@"我的评论",@"我的分享", nil],
                        [NSArray arrayWithObject:@"浏览历史"],
                        [NSArray arrayWithObjects:@"修改密码",@"修改资料",nil],nil];
    
    self.mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
    
    
}



#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [self.listItemArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listItemArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSArray *itemArray = [self.listItemArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [itemArray objectAtIndex:indexPath.row];

    return cell;
}



#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger secion = indexPath.section;
    NSInteger row = indexPath.row;
    if (secion == 0 && row == 0) { //我的收藏
        ProductFavoriteListsViewController *favoriteController = [[ProductFavoriteListsViewController alloc] initWithObject:self withSessionId:sessionId withUserId:userId ];
        [self.navigationController pushViewController:favoriteController animated:YES];
    } else if (secion == 0 && row == 1) { //我的评论
        ProductMemberCommentViewController *commentShowController = [[ProductMemberCommentViewController alloc] initWithObject:self withSessionId:sessionId withUserId:userId ];
        [self.navigationController pushViewController:commentShowController animated:YES];
    } else if (secion == 2 && row == 0) {
        ModifyPasswordViewController *modifyController = [[ModifyPasswordViewController alloc] initWithObject:self withSessionId:sessionId withUserId:userId];
        [self.navigationController pushViewController:modifyController animated:YES];
    } else if (secion == 2 && row == 1) {
        ModifyUserinfoViewController *modifyController = [[ModifyUserinfoViewController alloc] initWithObject:self withSessionId:sessionId withUserId:userId];
        [self.navigationController pushViewController:modifyController animated:YES];

        
    }
    
    
    
       
}


#pragma mark - logout
- (void)logoutAction
{

    
    [mainObj performSelector:@selector(logoutAccount)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
