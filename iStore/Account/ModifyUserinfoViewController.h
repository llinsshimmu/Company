//
//  ModifyUserinfoViewController.h
//  iStore
//
//  Created by 林世木 on 12-12-7.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyUserinfoViewController : UIViewController<UITextFieldDelegate> {
    NSOperationQueue *operationQueue;
    NSString *sessionId;	//会话ID
    NSString *userId;		//会员ID
    
    id mainObject;
    
    UITextField *emailField;
    UITextField *sexField;
    UITextField *xingmingField;
    UITextField *mobileField;
    
}

- (id)initWithObject:(id)obj withSessionId:(NSString *)session withUserId:(NSString *)user;

@end
