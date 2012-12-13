//
//  MainViewController.m
//  Demo1
//
//  Created by 林世木 on 12/9/18.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "MainViewController.h"
#import "StoreHomeViewController.h"
#import "TryViewController.h"
#import "ShareViewController.h"
#import "MyViewController.h"
#import "MoreViewController.h"
#import "LoginViewController.h"
#import "JsonParseOperation.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    StoreHomeViewController *homeController = [[StoreHomeViewController alloc] initWithObject:self];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeController];
    [homeNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg.png"] forBarMetrics: UIBarMetricsDefault];
    //Try
    TryViewController *tryController = [[TryViewController alloc] init];
    UINavigationController *tryNav = [[UINavigationController alloc] initWithRootViewController:tryController];
    [tryNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg.png"] forBarMetrics: UIBarMetricsDefault];
    
    //Share
    ShareViewController *shareController = [[ShareViewController alloc] init];
    UINavigationController *shareNav = [[UINavigationController alloc] initWithRootViewController:shareController];
    [shareNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg.png"] forBarMetrics: UIBarMetricsDefault];
    
    //My
    MyViewController *myController = [[MyViewController alloc] initWithObject:self];
    UINavigationController *myNav = [[UINavigationController alloc] initWithRootViewController:myController];
    [myNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg.png"] forBarMetrics: UIBarMetricsDefault];
    
    //More
    MoreViewController *moreController = [[MoreViewController alloc] initWithObject:self];
    UINavigationController *moreNav = [[UINavigationController alloc] initWithRootViewController:moreController];
    [moreNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg.png"] forBarMetrics: UIBarMetricsDefault];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.view.frame = self.view.bounds;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:homeNav, tryNav, shareNav,myNav, moreNav, nil];
    
    UIImage *image = [UIImage imageNamed:@"tabbar_bg.png"];
    self.tabBarController.tabBar.backgroundImage = image;
    
    [self.view addSubview:self.tabBarController.view];
    
    //解析document目录
    operationQueue = [[NSOperationQueue alloc] init];
    [self initAutoLogin];
}







#pragma -mark UITabBarControllerDelegate

//Asks the delegate whether the specified view controller should be made active.
- (BOOL)tabBarController:(UITabBarController *)aTabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //YES if the view controller’s tab should be selected or NO if the current tab should remain active.
    //应用场景，第一个tab提示输入用户名和密码，那么在输入正确之前，是要阻止其它tab被选中。
    if (viewController == [aTabBarController.viewControllers objectAtIndex:3]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *username = [ud objectForKey:@"username"];
        if ([username length] > 0) {
            return YES;
        } else {
            
          
            //初始化AlertView
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                           message:@"您还没登陆"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"登录",nil];
            alert.delegate = self;
            [alert show];
            return NO;
            
            
            
        }
        
    } else {
        return YES;
    }
}

#pragma mark UIAlertViewDelegate

//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //添加类别
    if (buttonIndex == 1 ) {
        LoginViewController *loginController = [[LoginViewController alloc] initWithObject:self];
        [self presentModalViewController:loginController animated:YES];
        
    }
}


- (void)loginSuccessBack
{
    self.tabBarController.selectedIndex = 3;

    [self dismissModalViewControllerAnimated:YES];
}

- (void)logoutAccount
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"" forKey:@"username"];
    [ud setObject:@"" forKey:@"sessionid"];
    [ud setObject:@"" forKey:@"userid"];
    [ud setObject:@"" forKey:@"autologin"];
    [ud synchronize];
    
     self.tabBarController.selectedIndex = 0;
    [self dismissModalViewControllerAnimated:YES];

}


#pragma mark - auto login
- (void)initAutoLogin
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *autoLogin = [ud objectForKey:@"autologin"];
    if ([autoLogin length] == 0) {
        return;
    }
    
    NSString *username = [ud objectForKey:@"username"];
    NSString *pwd = [ud objectForKey:@"pwd"];

    
       
    
    NSString *urlStr =@"http://api.tengchen.com:90/User/remoteLogin.do";
    NSArray *loginPostArray = [NSArray arrayWithObjects:
                               [NSDictionary dictionaryWithObjectsAndKeys:@"username",@"key",username,@"value", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"password",@"key",pwd,@"value", nil], nil];
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(loginFeedBackResult:) withURL:urlStr withPostKeyValue:loginPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
    
    
}



- (void)loginFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        
        NSDictionary *userinfoDic = [returnDic objectForKey:@"userinfo"];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[returnDic objectForKey:@"sessionid"] forKey:@"sessionid"];
        [ud setObject:[userinfoDic objectForKey:@"userid"] forKey:@"userid"];
        
        [ud synchronize];
                
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"自动登录失败！"
                                                      delegate:nil
                                             cancelButtonTitle: @"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
    }
    
}



#pragma mark - other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
