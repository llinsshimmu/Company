//
//  LoginViewController.h
//  Demo1
//
//  Created by 林世木 on 12/9/21.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController<UITextFieldDelegate>{

    id mainObject;
    
    UIScrollView *scrollView;
    
    
    UITextField *usernameField;
    UITextField *pwdField;
    
    CGSize viewSize;
    
    NSOperationQueue *operationQueue;
    

    UIButton *checkOnButton;
    UIButton *checkOffButton;

    BOOL autoLogin;
}

- (id)initWithObject:(id)obj;
- (void)loginFeedBackResult:(NSDictionary *)dic;


@end
