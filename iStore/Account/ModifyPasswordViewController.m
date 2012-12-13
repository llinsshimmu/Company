//
//  ModifyPasswordViewController.m
//  iStore
//
//  Created by 林世木 on 12-12-7.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "JsonParseOperation.h"


@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

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

    
    [self initNavBar];
    
    //密码
    UILabel *pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 50)];
    [pwdLabel setFont:[UIFont systemFontOfSize:15.0]];
    [pwdLabel setBackgroundColor:[UIColor clearColor] ];
    pwdLabel.text = @"请输入要修改的密码";
    [self.view addSubview:pwdLabel];
    
    pwdField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 60.0f, 200.0f, 30.0f)];
    pwdField.secureTextEntry = YES; //密码
    pwdField.autocorrectionType = UITextAutocorrectionTypeNo;
    pwdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwdField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    pwdField.returnKeyType = UIReturnKeyDone;
    pwdField.delegate = self;
    pwdField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    pwdField.placeholder =@"请输入密码"; //默认显示的字
    pwdField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:pwdField];
    
    rePwdField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 100.0f, 200.0f, 30.0f)];
    rePwdField.secureTextEntry = YES; //密码
    rePwdField.autocorrectionType = UITextAutocorrectionTypeNo;
    rePwdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    rePwdField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    rePwdField.returnKeyType = UIReturnKeyDone;
    rePwdField.delegate = self;
    rePwdField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    rePwdField.placeholder =@"请再次输入密码"; //默认显示的字
    rePwdField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:rePwdField];
    
    
    submitButton = [[UIButton alloc] initWithFrame:CGRectMake(80.0f,140.0f,140.0f,35.0f)];
    [submitButton setTitle:@"确 认" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];

    [pwdField becomeFirstResponder];
}

- (void)submitButtonClicked
{
    NSString *urlStr =@"http://api.tengchen.com:90/User/remoteModifyPassword.do";
    NSArray *submitPostArray = [NSArray arrayWithObjects:
                               [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",sessionId,@"value", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",userId,@"value", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"password",@"key",pwdField.text,@"value", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"re_password",@"key",rePwdField.text,@"value", nil],
                                nil];
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(pwdFeedBackResult:) withURL:urlStr withPostKeyValue:submitPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
}




- (void)pwdFeedBackResult:(NSDictionary *)returnDic
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:[returnDic objectForKey:@"msg"]
                                                  delegate:nil
                                         cancelButtonTitle: @"确定"
                                         otherButtonTitles:nil, nil];
    [alert show];
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        
        
         [self.navigationController popViewControllerAnimated:YES];
        
        [mainObject performSelector:@selector(logoutAction)];
    }

    
}



#pragma mark - other
- (void)initNavBar
{
    self.navigationItem.title = @"修改密码";
    
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
