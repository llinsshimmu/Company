//
//  RegisterViewController.m
//  Demo1
//
//  Created by 林世木 on 12/9/25.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "RegisterViewController.h"
#import "JsonParseOperation.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    
    [self initToolBar];
    
    viewSize = self.view.bounds.size;
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,44,viewSize.width,viewSize.height-44.0f)];
    scrollView.contentSize=CGSizeMake(viewSize.width,550);
    scrollView.backgroundColor=[UIColor lightGrayColor];
    //    scrollView.pagingEnabled=YES;//是否自己动适应
    [self.view addSubview:scrollView];

    //解析document目录
    operationQueue = [[NSOperationQueue alloc] init];
    
    [self initField];
    
//    UITextField *usernameField;
//    UITextField *pwdField;
//    UITextField *re_passwordField;
//    UITextField *emailField;
//    UITextField *sexField;
//    UITextField *xingmingField;
//    UITextField *mobileField;
}

- (void)initField
{
    //用户名
    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    [usernameLabel setFont:[UIFont systemFontOfSize:15.0]];
    [usernameLabel setBackgroundColor:[UIColor clearColor] ];
    usernameLabel.text = @"用户名";
    [scrollView addSubview:usernameLabel];
    
    usernameField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 10.0f, 200.0f, 30.0f)];
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
    UILabel *pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 50, 30)];
    [pwdLabel setFont:[UIFont systemFontOfSize:15.0]];
    [pwdLabel setBackgroundColor:[UIColor clearColor] ];
    pwdLabel.text = @"密码";
    [scrollView addSubview:pwdLabel];
    
    pwdField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 50.0f, 200.0f, 30.0f)];
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
    
    
    //确认密码
    UILabel *re_passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 50, 30)];
    [re_passwordLabel setFont:[UIFont systemFontOfSize:15.0]];
    [re_passwordLabel setBackgroundColor:[UIColor clearColor] ];
    re_passwordLabel.text = @"确认密码";
    [scrollView addSubview:re_passwordLabel];
    
    re_passwordField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 90.0f, 200.0f, 30.0f)];
    re_passwordField.secureTextEntry = YES; //密码
    re_passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    re_passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    re_passwordField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    re_passwordField.returnKeyType = UIReturnKeyDone;
    re_passwordField.delegate = self;
    re_passwordField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    re_passwordField.placeholder =@"请输入用户名"; //默认显示的字
    re_passwordField.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:re_passwordField];
    
    
    //email
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 50, 30)];
    [emailLabel setFont:[UIFont systemFontOfSize:15.0]];
    [emailLabel setBackgroundColor:[UIColor clearColor] ];
    emailLabel.text = @"邮箱";
    [scrollView addSubview:emailLabel];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 130.0f, 200.0f, 30.0f)];
    emailField.secureTextEntry = YES; //密码
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    emailField.returnKeyType = UIReturnKeyDone;
    emailField.delegate = self;
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    emailField.placeholder =@"请输入用户名"; //默认显示的字
    emailField.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:emailField];
    
    //xingming
    UILabel *xingmingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 50, 30)];
    [xingmingLabel setFont:[UIFont systemFontOfSize:15.0]];
    [xingmingLabel setBackgroundColor:[UIColor clearColor] ];
    xingmingLabel.text = @"姓名";
    [scrollView addSubview:xingmingLabel];
    
    xingmingField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 170.0f, 200.0f, 30.0f)];
    xingmingField.secureTextEntry = YES; //密码
    xingmingField.autocorrectionType = UITextAutocorrectionTypeNo;
    xingmingField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    xingmingField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    xingmingField.returnKeyType = UIReturnKeyDone;
    xingmingField.delegate = self;
    xingmingField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    xingmingField.placeholder =@"请输入姓名"; //默认显示的字
    xingmingField.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:xingmingField];
    
    
    UILabel *mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 50, 30)];
    [mobileLabel setFont:[UIFont systemFontOfSize:15.0]];
    [mobileLabel setBackgroundColor:[UIColor clearColor] ];
    mobileLabel.text = @"手机号";
    [scrollView addSubview:mobileLabel];
    
    mobileField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 210.0f, 200.0f, 30.0f)];
    mobileField.secureTextEntry = YES; //密码
    mobileField.autocorrectionType = UITextAutocorrectionTypeNo;
    mobileField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mobileField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    mobileField.returnKeyType = UIReturnKeyDone;
    mobileField.delegate = self;
    mobileField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    mobileField.placeholder =@"请输入用户名"; //默认显示的字
    mobileField.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:mobileField];
    
    

    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(70.0f,250.0f,200.0f,35.0f)];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:registerButton];


}

#pragma mark register
- (void)registerButtonClicked:(id)sender
{
    NSString *urlStr =@"http://api.tengchen.com:90/User/remoteReg.do";
    NSArray *loginPostArray = [NSArray arrayWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:@"username",@"key",usernameField.text,@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"password",@"key",pwdField.text,@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"re_password",@"key",re_passwordField.text,@"value", nil],
                               nil];
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(registerFeedBackResult:) withURL:urlStr withPostKeyValue:loginPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
    
    

}


- (void)registerFeedBackResult:(NSDictionary *)returnDic
{    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:[returnDic objectForKey:@"msg"]
                                                  delegate:nil
                                         cancelButtonTitle: @"确定"
                                         otherButtonTitles:nil, nil];
    [alert show];
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        [self dismissModalViewControllerAnimated:YES];
    } 

}





#pragma mark UITextFieldDelegate
//要实现的Delegate方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - others

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
