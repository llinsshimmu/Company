//
//  AppDelegate.h
//  iStore
//
//  Created by 林世木 on 12/9/28.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

/*
 AR 添加
 1 Add foundation  OpenCV.framework coremedia corevideo
   iStore-Prefix.pch
    add
 #ifdef __cplusplus
 #import <OpenCV/opencv2/opencv.hpp>
 #endif
 
 
 2 Build Settings
    Apple LLVM compiler 4.1 language
    C++ Standard Library libstdc++(GUN C++ standard library)
 
 3 ARC open
 
 */

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *mainController;

@end
