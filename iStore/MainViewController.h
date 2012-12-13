//
//  MainViewController.h
//  Demo1
//
//  Created by 林世木 on 12/9/18.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITabBarControllerDelegate,UIAlertViewDelegate>{

    NSOperationQueue *operationQueue;

}
@property (strong, nonatomic) UITabBarController *tabBarController;


@end
