//
//  RegisterViewController.h
//  Demo1
//
//  Created by 林世木 on 12/9/25.
//  Copyright (c) 2012年 林世木. All rights reserved.
//
/*
 required	username	String	会员名
 required	password	string	密码
 required	re_password	string	确认密码
 optional	email	string	邮件地址
 optional	sex	string	性别（值为文本字符串）
 optional	xingming	string	会员的姓名
 optional	mobile	string	手机号码
 */

#import <UIKit/UIKit.h>



@interface RegisterViewController : UIViewController<UITextFieldDelegate>{
    id mainObject;
    
    UIScrollView *scrollView;

    
    UITextField *usernameField;
    UITextField *pwdField;
    UITextField *re_passwordField;
    UITextField *emailField;
    UITextField *sexField;
    UITextField *xingmingField;
    UITextField *mobileField;
    
    CGSize viewSize;
    
    NSOperationQueue *operationQueue;

    
}
- (id)initWithObject:(id)obj;
- (void)registerFeedBackResult:(NSDictionary *)dic;


@end
