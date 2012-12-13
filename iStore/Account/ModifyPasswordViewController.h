//
//  ModifyPasswordViewController.h
//  iStore
//
//  Created by 林世木 on 12-12-7.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : UIViewController<UITextFieldDelegate> {
    
    id mainObject;
    
    NSString *sessionId;	//会话ID
    NSString *userId;		//会员ID
    
    UITextField *pwdField;
    UITextField *rePwdField;
    
    NSOperationQueue *operationQueue;
    
    UIButton *submitButton;
    
}


- (id)initWithObject:(id)obj withSessionId:(NSString *)session withUserId:(NSString *)user;

@end
