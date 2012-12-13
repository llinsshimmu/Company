//
//  ModifyUserinfoViewController.m
//  iStore
//
//  Created by 林世木 on 12-12-7.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "ModifyUserinfoViewController.h"
#import "JsonParseOperation.h"

@interface ModifyUserinfoViewController ()

@end

@implementation ModifyUserinfoViewController

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

    
    
    //email
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    [emailLabel setFont:[UIFont systemFontOfSize:15.0]];
    [emailLabel setBackgroundColor:[UIColor clearColor] ];
    emailLabel.text = @"邮箱";
    [self.view addSubview:emailLabel];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 10.0f, 200.0f, 30.0f)];
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    emailField.returnKeyType = UIReturnKeyDone;
    emailField.delegate = self;
    emailField.placeholder =@"请输入用户名"; //默认显示的字
    emailField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:emailField];
    
    //xingming
    UILabel *xingmingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 50, 30)];
    [xingmingLabel setFont:[UIFont systemFontOfSize:15.0]];
    [xingmingLabel setBackgroundColor:[UIColor clearColor] ];
    xingmingLabel.text = @"姓名";
    [self.view addSubview:xingmingLabel];
    
    xingmingField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 50.0f, 200.0f, 30.0f)];
    xingmingField.autocorrectionType = UITextAutocorrectionTypeNo;
    xingmingField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    xingmingField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    xingmingField.returnKeyType = UIReturnKeyDone;
    xingmingField.delegate = self;
    xingmingField.placeholder =@"请输入姓名"; //默认显示的字
    xingmingField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:xingmingField];
    
    
    UILabel *mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 50, 30)];
    [mobileLabel setFont:[UIFont systemFontOfSize:15.0]];
    [mobileLabel setBackgroundColor:[UIColor clearColor] ];
    mobileLabel.text = @"手机号";
    [self.view addSubview:mobileLabel];
    
    mobileField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 90.0f, 200.0f, 30.0f)];
    mobileField.autocorrectionType = UITextAutocorrectionTypeNo;
    mobileField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mobileField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    mobileField.returnKeyType = UIReturnKeyDone;
    mobileField.delegate = self;
    mobileField.placeholder =@"请输入用户名"; //默认显示的字
    mobileField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:mobileField];
    
    
    
    UIButton *modifyButton = [[UIButton alloc] initWithFrame:CGRectMake(80.0f,140.0f,200.0f,35.0f)];
    [modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    modifyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [modifyButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
    [modifyButton addTarget:self action:@selector(modifyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyButton];

    [emailField becomeFirstResponder];
}


#pragma mark register
- (void)modifyButtonClicked
{
    NSString *urlStr =@"http://api.tengchen.com:90/User/remoteModifyUserinfo.do";
    NSArray *submitPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",sessionId,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",userId,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"email",@"key",emailField.text,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"xingming",@"key",xingmingField.text,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"mobile",@"key",mobileField.text,@"value", nil],
                                nil];
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(modifyFeedBackResult:) withURL:urlStr withPostKeyValue:submitPostArray];
    
    [operationQueue addOperation:jsonParseOperation];
    
    
    
}


- (void)modifyFeedBackResult:(NSDictionary *)returnDic
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



#pragma mark - other
- (void)initNavBar
{
    self.navigationItem.title = @"修改资料";
    
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
