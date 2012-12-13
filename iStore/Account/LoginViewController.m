//
//  LoginViewController.m
//  Demo1
//
//  Created by 林世木 on 12/9/21.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "LoginViewController.h"
#import "JsonParseOperation.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithObject:(id)obj
{
    self = [super init];
    if (self) {
        mainObject = obj;
        autoLogin = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    viewSize = self.view.bounds.size;
    
    [self initToolBar];
    
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,44,viewSize.width,viewSize.height-44.0f)];
    scrollView.backgroundColor=[UIColor lightGrayColor];
    //    scrollView.pagingEnabled=YES;//是否自己动适应
    [self.view addSubview:scrollView];
    
    operationQueue = [[NSOperationQueue alloc] init];
    
    [self initField];

}

- (void)initField
{
    //用户名
    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 50, 30)];
    [usernameLabel setFont:[UIFont systemFontOfSize:15.0]];
    [usernameLabel setBackgroundColor:[UIColor clearColor] ];
    usernameLabel.text = @"用户名";
    [scrollView addSubview:usernameLabel];
    
    usernameField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 20.0f, 200.0f, 30.0f)];
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    usernameField.returnKeyType = UIReturnKeyDone;
    usernameField.delegate = self;
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    usernameField.placeholder =@"请输入用户名"; //默认显示的字
    usernameField.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:usernameField];
    
    //密码
    UILabel *pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 50, 30)];
    [pwdLabel setFont:[UIFont systemFontOfSize:15.0]];
    [pwdLabel setBackgroundColor:[UIColor clearColor] ];
    pwdLabel.text = @"密  码";
    [scrollView addSubview:pwdLabel];
    
    pwdField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 70.0f, 200.0f, 30.0f)];
    pwdField.secureTextEntry = YES; //密码
    pwdField.autocorrectionType = UITextAutocorrectionTypeNo;
    pwdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwdField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    pwdField.returnKeyType = UIReturnKeyDone;
    pwdField.delegate = self;
    pwdField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    pwdField.placeholder =@"请输入密码"; //默认显示的字
    pwdField.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:pwdField];
    
       
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(160.0f,120.0f,140.0f,35.0f)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginButton];
    
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f,120.0f,140.0f,35.0f)];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:registerButton];
    
    //check box
    checkOffButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f,165.0f,20.0f,20.0f)];
    [checkOffButton setBackgroundImage:[UIImage imageNamed:@"cb_glossy_off.png"] forState:UIControlStateNormal];
    [checkOffButton addTarget:self action:@selector(checkOffButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:checkOffButton];
    
    checkOnButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f,165.0f,20.0f,20.0f)];
    [checkOnButton setBackgroundImage:[UIImage imageNamed:@"cb_glossy_on.png"] forState:UIControlStateNormal];
    [checkOnButton addTarget:self action:@selector(checkOnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *autoLoginLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 160, 100, 30)];
    [autoLoginLabel setFont:[UIFont systemFontOfSize:15.0]];
    [autoLoginLabel setBackgroundColor:[UIColor clearColor] ];
    autoLoginLabel.text = @"下次自动登陆";
    [scrollView addSubview:autoLoginLabel];
    
    [usernameField becomeFirstResponder];
    
}

#pragma mark login
- (void)loginButtonClicked:(id)sender
{
    NSString *urlStr =@"http://api.tengchen.com:90/User/remoteLogin.do";
    NSArray *loginPostArray = [NSArray arrayWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:@"username",@"key",usernameField.text,@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"password",@"key",pwdField.text,@"value", nil], nil];
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(loginFeedBackResult:) withURL:urlStr withPostKeyValue:loginPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
    
    
}

- (void)registerButtonClicked:(id)sender
{
    RegisterViewController *registerController = [[RegisterViewController alloc] initWithObject:self];
    [self presentModalViewController:registerController animated:YES];
    
    
}


- (void)loginFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        
        NSDictionary *userinfoDic = [returnDic objectForKey:@"userinfo"];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:usernameField.text forKey:@"username"];
        [ud setObject:[returnDic objectForKey:@"sessionid"] forKey:@"sessionid"];
        [ud setObject:[userinfoDic objectForKey:@"userid"] forKey:@"userid"];
        [ud setObject:pwdField.text forKey:@"pwd"];
        if (autoLogin) {
            [ud setObject:@"autologin" forKey:@"autologin"];

        } else {
            [ud setObject:@"" forKey:@"autologin"];

        }
        [ud synchronize];
        
        [mainObject performSelector:@selector(loginSuccessBack)];
        
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"登录失败，请重新登录！"
                                                      delegate:nil
                                             cancelButtonTitle: @"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (void)checkOnButtonClicked
{
    autoLogin = NO;
    [checkOnButton removeFromSuperview];
    [scrollView addSubview:checkOffButton];
}


- (void)checkOffButtonClicked
{
    autoLogin = YES;
    [checkOffButton removeFromSuperview];
    [scrollView addSubview:checkOnButton];

}



#pragma mark UITextFieldDelegate
//要实现的Delegate方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - other

- (void)initToolBar
{
    

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, 44)];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg" ] forToolbarPosition:0 barMetrics:0];
    [toolBar sizeToFit];

    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 5.0, 50.0, 35.0)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"bac_btn.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backButton];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5.0, 50, 100)];
    [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [titleLabel setText:@"用户登录"];
    titleLabel.backgroundColor = [UIColor clearColor];
    [toolBar addSubview:titleLabel];
 
    [self.view addSubview:toolBar];

}

- (void)backAction
{
    [self dismissModalViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
