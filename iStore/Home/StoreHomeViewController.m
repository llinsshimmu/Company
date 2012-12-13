//
//  StoreHomeViewController.m
//  Demo1
//
//  Created by 林世木 on 12/9/19.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "StoreHomeViewController.h"
#import "HomeTopCell.h"
#import "HomeTryCell.h"
#import "HomeRecommendCell.h"

@interface StoreHomeViewController ()

@end

@implementation StoreHomeViewController

- (id)initWithObject:(id)obj
{
    self = [super init];
    if (self) {
        mainObject = obj;
        
        //工具栏，当前选项卡
//        UITabBarItem *tab = [[UITabBarItem alloc]
//                              initWithTitle:@""
//                              image:[UIImage imageNamed:@"home_tab.png"]
//                              tag:1];
        self.tabBarItem.image = [UIImage imageNamed:@"home_tab.png"];
//        self.tabBarItem = tab;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.listItemArray = [NSArray arrayWithObjects:@"top",@"hot",@"recommend", nil];
    
    [self initNavigationView];
    
    CGRect tableRect = self.view.bounds;
    tableRect.size.height = tableRect.size.height - 94.0f;
    
    self.mTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    //UITableView 去掉背景 分割线
    [self.mTableView setBackgroundColor:[UIColor clearColor]];
    [self.mTableView setSeparatorColor:[UIColor clearColor]];
    [self.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:self.mTableView];
}

- (void)initNavigationView
{
    //navigationbar logo
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_home_button2.png"]];
    logoView.frame = CGRectMake(0.0f, 0.0f, 100.0f, 44.0f);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoView];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //navigation search
    UIImageView *searchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_home_button1.png"]];
    searchView.frame = CGRectMake(0.0f, 0.0f, 200.0f, 44.0f);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchView];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
   
}

#pragma mark - action
- (void)tryButtonClicked:(id)sender
{
    
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell;
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell = [[HomeTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withObject:self];
    } else if (row == 1 ) {
        cell = [[HomeTryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withObject:self];
    } else if (row == 2 ) {
        cell = [[HomeRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withObject:self];
    } 
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
//    cell.textLabel.text = [self.listItemArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        return 100.0f;
    } else if (row == 1) {
        return 200.0f;
    } else {
        return 200.0f;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - other

#pragma mark - login action
//- (void)registerButtonClicked:(id)sender
//{
//    RegisterViewController *registerController = [[RegisterViewController alloc] initWithObject:self];
//    [self.navigationController pushViewController:registerController animated:YES];
//    
//}
//
//- (void)loginButtonClicked:(id)sender
//{
//    LoginViewController *loginController = [[LoginViewController alloc] initWithObject:self];
//    [self.navigationController pushViewController:loginController animated:YES];
//    
//    
//}
//
//- (void)logoutButtonClicked:(id)sender
//{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:@"" forKey:@"username"];
//    [ud synchronize];
//    //    rightBarButtonItem.customView = loginToolBar;
//    [self loginView];
//}

#pragma mark - login

//- (void)loginView
//{
//    loginToolBar = [[UIToolBarOpaque alloc] init];
//    loginToolBar.backgroundColor = [UIColor clearColor];
//    loginToolBar.frame = CGRectMake(0.0f, 0.0f,120.0f, 44.0f);
//
//    loginedToolBar = [[UIToolBarOpaque alloc] init];
//    loginedToolBar.backgroundColor = [UIColor clearColor];
//    loginedToolBar.frame = CGRectMake(0.0f, 0.0f,120.0f, 44.0f);
//
//
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *username = [ud objectForKey:@"username"];
//
//
//
//    if ([username length] > 0) {
//
//        UIButton *userButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f,5.0f,45.0f,35.0f)];
//        [userButton setTitle:username forState:UIControlStateNormal];
//        userButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        userButton.enabled = NO;
//
//        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(40.0f,5.0f,45.0f,35.0f)];
//        [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
//        logoutButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [logoutButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
//        [logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//
//        [loginedToolBar addSubview:userButton];
//        [loginedToolBar addSubview:logoutButton];
//
//        rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginedToolBar];
//
//
//    } else {
//
//        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f,5.0f,45.0f,35.0f)];
//        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
//        loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [loginButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
//        [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//        UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(40.0f,5.0f,45.0f,35.0f)];
//        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
//        registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [registerButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
//        [registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//
//        [loginToolBar addSubview:loginButton];
//        [loginToolBar addSubview:registerButton];
//
//        rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginToolBar];
//    }
//
//
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//
//}


@end
